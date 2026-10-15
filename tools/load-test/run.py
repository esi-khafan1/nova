#!/usr/bin/env python3
"""Manual, bounded k6 staircase runner. No application/database writes."""
import argparse
import csv
from collections import Counter
import datetime as dt
import json
import math
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time

TARGETS = {
    'production': 'https://nova-academy.ir',
    'preview': 'https://feature-exam-designer-reports-nova.doob4347.workers.dev',
}
WARMUP_SECONDS = 10
WINDOW_SECONDS = 15
MIN_WINDOW_SAMPLES = 10


def percentile(values, q=0.95):
    if not values:
        return None
    a = sorted(values)
    position = (len(a) - 1) * q
    lower = math.floor(position)
    return a[lower] + (a[min(lower + 1, len(a) - 1)] - a[lower]) * (position - lower)


def levels(max_users):
    return sorted({x for x in [1, 5, 10, 25, 50, 75, 100, 150, 200, 300, 400, 500, max_users] if x <= max_users})


def measure(samples):
    durations = [x['value'] for x in samples if x['metric'] == 'nova_request_ms']
    failed = [x['value'] for x in samples if x['metric'] == 'nova_request_failed']
    return {'requests': len(failed), 'p95_ms': percentile(durations),
            'error_percent': 100 * sum(failed) / len(failed) if failed else None,
            'responses': dict(Counter(x.get('result', 'unclassified') for x in samples if x['metric'] == 'nova_request_failed'))}


def breaches(stats, p95_limit, error_limit):
    return ((stats['p95_ms'] is not None and stats['p95_ms'] > p95_limit)
            or (stats['error_percent'] is not None and stats['error_percent'] > error_limit))


def classify_window(samples, p95_limit, error_limit):
    stats = measure(samples)
    stats['state'] = ('insufficient' if stats['requests'] < MIN_WINDOW_SAMPLES
                      else 'breach' if breaches(stats, p95_limit, error_limit) else 'healthy')
    return stats


def args_parser():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--target', choices=TARGETS, default='preview')
    p.add_argument('--max-users', type=int, default=10)
    p.add_argument('--step-seconds', type=int, default=60)
    p.add_argument('--p95-limit-ms', type=float, default=2000)
    p.add_argument('--error-limit-percent', type=float, default=1)
    p.add_argument('--scenario', choices=['public', 'student'], default='public')
    p.add_argument('--confirm-production', action='store_true')
    p.add_argument('--output', default='load-test-results')
    p.add_argument('--k6', default='k6')
    return p


def validate(args):
    if not 1 <= args.max_users <= 500:
        raise ValueError('max-users must be between 1 and 500')
    if not 60 <= args.step_seconds <= 180:
        raise ValueError('step-seconds must be between 60 and 180')
    if not 100 <= args.p95_limit_ms <= 10000:
        raise ValueError('p95-limit-ms must be between 100 and 10000')
    if not 0 <= args.error_limit_percent <= 10:
        raise ValueError('error-limit-percent must be between 0 and 10')
    if args.target == 'production' and not args.confirm_production:
        raise ValueError('Production requires explicit --confirm-production')
    if args.scenario == 'student':
        try:
            cookies = json.loads(os.environ.get('NOVA_STUDENT_COOKIES', '[]'))
        except json.JSONDecodeError:
            raise ValueError('NOVA_STUDENT_COOKIES must be a JSON array') from None
        if (not isinstance(cookies, list) or not cookies
                or any(not isinstance(c, str) or not c.strip() or '\r' in c or '\n' in c for c in cookies)):
            raise ValueError('Student scenario requires test-session Cookie strings in NOVA_STUDENT_COOKIES')
        return len(cookies)
    return 0


def stop_process(process):
    if process.poll() is None:
        process.send_signal(signal.SIGINT)
        try:
            process.wait(timeout=12)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait(timeout=5)


def run_stage(args, users, output, windows):
    raw = output / '.metrics.jsonl'
    raw.unlink(missing_ok=True)
    env = os.environ.copy()
    env.update(NOVA_BASE_URL=TARGETS[args.target], NOVA_SCENARIO=args.scenario,
               K6_NO_USAGE_REPORT='true', K6_NO_COLOR='true',
               NOVA_VUS=str(users), NOVA_DURATION=f'{args.step_seconds}s', K6_ADDRESS='127.0.0.1:0')
    env.pop('K6_HTTP_DEBUG', None)
    # No shell and no interpolation of workflow input into executable code.
    command = [args.k6, 'run', '--quiet', '--out', f'json={raw}', str(Path(__file__).with_name('scenario.js'))]
    start_wall = time.time()
    samples, pending, position = [], '', 0
    next_boundary, bad_windows = WARMUP_SECONDS + WINDOW_SECONDS, 0
    stopped, infrastructure_error = False, None
    process = subprocess.Popen(command, env=env, stdout=subprocess.DEVNULL)

    def collect():
        nonlocal position, pending
        if not raw.exists():
            return
        with raw.open(encoding='utf-8') as stream:
            stream.seek(position)
            pending += stream.read()
            position = stream.tell()
        lines = pending.split('\n')
        pending = lines.pop()
        for line in lines:
            if not line:
                continue
            point = json.loads(line)
            if point.get('type') != 'Point' or point.get('metric') not in ['nova_request_ms', 'nova_request_failed']:
                continue
            data = point['data']
            stamp = dt.datetime.fromisoformat(data['time'].replace('Z', '+00:00')).timestamp()
            if stamp >= start_wall + WARMUP_SECONDS:
                samples.append({'time': stamp - start_wall, 'metric': point['metric'],
                                'value': data['value'], 'route': data.get('tags', {}).get('route', ''),
                                'result': data.get('tags', {}).get('result', 'unclassified')})
    try:
        while True:
            collect()
            elapsed = time.time() - start_wall
            # Leave a 2-second ingestion allowance before closing a completed time window.
            while elapsed >= next_boundary + 2:
                batch = [x for x in samples if next_boundary - WINDOW_SECONDS <= x['time'] < next_boundary]
                stats = classify_window(batch, args.p95_limit_ms, args.error_limit_percent)
                windows.append({'users': users, 'from_second': next_boundary - WINDOW_SECONDS,
                                'to_second': next_boundary, **stats})
                bad_windows = bad_windows + 1 if stats['state'] == 'breach' else 0
                next_boundary += WINDOW_SECONDS
                if bad_windows >= 2:
                    stopped = True
                    stop_process(process)
                    break
            if stopped or process.poll() is not None:
                collect()
                break
            if elapsed > args.step_seconds + 25:
                infrastructure_error = 'k6 exceeded its bounded runtime'
                stop_process(process)
                break
            time.sleep(0.25)
    finally:
        stop_process(process)
        raw.unlink(missing_ok=True)  # Never upload raw request output or response bodies.
    stats = measure(samples)
    state = 'healthy'
    if infrastructure_error or (process.returncode != 0 and not stopped):
        state = 'infrastructure_error'
    elif stopped or (stats['requests'] >= 20 and breaches(stats, args.p95_limit_ms, args.error_limit_percent)):
        state = 'guard_stop'
    elif stats['requests'] < 20:
        state = 'insufficient'
    routes = {route: measure([x for x in samples if x['route'] == route]) for route in sorted({x['route'] for x in samples})}
    return {'users': users, 'duration_seconds': round(time.time() - start_wall, 1), **stats,
            'rps': stats['requests'] / max(time.time() - start_wall - WARMUP_SECONDS, 1),
            'state': state, 'sustained_stop': stopped, 'routes': routes,
            'detail': infrastructure_error or ('k6 exited unexpectedly' if state == 'infrastructure_error' else '')}


def write_outputs(result, output):
    from report import render_html, markdown_summary
    output.mkdir(parents=True, exist_ok=True)
    (output / 'summary.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
    for name, records, columns in [
        ('stages.csv', result['stages'], ['users', 'duration_seconds', 'requests', 'p95_ms', 'error_percent', 'rps', 'state']),
        ('windows.csv', result['windows'], ['users', 'from_second', 'to_second', 'requests', 'p95_ms', 'error_percent', 'state'])]:
        with (output / name).open('w', newline='', encoding='utf-8-sig') as stream:
            writer = csv.DictWriter(stream, fieldnames=columns, extrasaction='ignore')
            writer.writeheader()
            writer.writerows(records)
    (output / 'report.html').write_text(render_html(result), encoding='utf-8')
    summary = markdown_summary(result)
    (output / 'summary.md').write_text(summary, encoding='utf-8')
    if os.environ.get('GITHUB_STEP_SUMMARY'):
        with open(os.environ['GITHUB_STEP_SUMMARY'], 'w', encoding='utf-8') as stream:
            stream.write(summary)


def main():
    args = args_parser().parse_args()
    try:
        sessions = validate(args)
    except ValueError as error:
        print(str(error), file=sys.stderr)
        return 2
    if not shutil.which(args.k6):
        print('k6 not found. Install k6 v1.0.0 or use the manual GitHub workflow.', file=sys.stderr)
        return 2
    output = Path(args.output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    if (output / 'summary.json').exists():
        print('Use a fresh output directory so old results cannot be mixed.', file=sys.stderr)
        return 2
    result = {'started_at': dt.datetime.now(dt.timezone.utc).isoformat(), 'target': TARGETS[args.target],
              'scenario': args.scenario, 'session_count': sessions, 'max_users': args.max_users,
              'p95_limit_ms': args.p95_limit_ms, 'error_limit_percent': args.error_limit_percent,
              'warmup_seconds': WARMUP_SECONDS, 'window_seconds': WINDOW_SECONDS,
              'stages': [], 'windows': [], 'outcome': 'running'}
    exit_code = 0
    try:
        for users in levels(args.max_users):
            print(f'Stage: {users} concurrent virtual users', flush=True)
            stage = run_stage(args, users, output, result['windows'])
            result['stages'].append(stage)
            print(f"  {stage['state']} — requests={stage['requests']}, p95={stage['p95_ms']}, errors={stage['error_percent']}", flush=True)
            write_outputs(result, output)
            if stage['state'] != 'healthy':
                result['outcome'] = stage['state']
                exit_code = 2 if stage['state'] == 'infrastructure_error' else 0
                break
        else:
            result['outcome'] = 'limit_reached_without_breach'
    except (KeyboardInterrupt, Exception) as error:
        result['outcome'] = 'interrupted' if isinstance(error, KeyboardInterrupt) else 'infrastructure_error'
        # Do not put arbitrary exception messages / credentials in public artifacts.
        print('Test interrupted or runner error; partial report preserved.', file=sys.stderr)
        exit_code = 2
    finally:
        result['finished_at'] = dt.datetime.now(dt.timezone.utc).isoformat()
        write_outputs(result, output)
    return exit_code


if __name__ == '__main__':
    sys.exit(main())

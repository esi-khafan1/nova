import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import run
import report


class RunnerTests(unittest.TestCase):
    def test_levels_are_bounded_and_include_exact_limit(self):
        for n in [1, 3, 10, 26, 100, 500]:
            xs = run.levels(n)
            self.assertEqual(xs[-1], n)
            self.assertEqual(xs, sorted(set(xs)))
            self.assertTrue(all(1 <= x <= n for x in xs))

    def test_input_limits_and_production_consent(self):
        for args in [['--max-users', '501'], ['--max-users', '0'], ['--step-seconds', '59'],
                     ['--p95-limit-ms', 'nan'], ['--error-limit-percent', 'inf'], ['--target', 'production']]:
            with self.assertRaises(ValueError):
                run.validate(run.args_parser().parse_args(args))
        run.validate(run.args_parser().parse_args(['--target', 'production', '--confirm-production']))

    def test_secret_validation(self):
        with patch.dict(os.environ, {'NOVA_STUDENT_COOKIES': '[]'}):
            with self.assertRaises(ValueError):
                run.validate(run.args_parser().parse_args(['--scenario', 'student']))
        with patch.dict(os.environ, {'NOVA_STUDENT_COOKIES': '["test-session=value"]'}):
            self.assertEqual(run.validate(run.args_parser().parse_args(['--scenario', 'student'])), 1)

    def test_window_error_latency_and_minimum_sample(self):
        def samples(n, ms=100, bad=0):
            return ([{'metric': 'nova_request_ms', 'value': ms} for _ in range(n)]
                    + [{'metric': 'nova_request_failed', 'value': i < bad} for i in range(n)])
        self.assertEqual(run.classify_window(samples(9, 9000), 2000, 1)['state'], 'insufficient')
        self.assertEqual(run.classify_window(samples(20), 2000, 1)['state'], 'healthy')
        self.assertEqual(run.classify_window(samples(20, 2100), 2000, 1)['state'], 'breach')
        self.assertEqual(run.classify_window(samples(20, bad=1), 2000, 1)['state'], 'breach')
        self.assertEqual(run.classify_window(samples(20, 2000), 2000, 1)['state'], 'healthy')

    def test_percentile_and_empty(self):
        self.assertIsNone(run.percentile([]))
        self.assertEqual(run.percentile([10]), 10)
        self.assertAlmostEqual(run.percentile(list(range(1, 101))), 95.05)

    def test_report_does_not_claim_capacity_without_breach(self):
        result = fixture()
        self.assertIn('هنوز پیدا نشده', report.conclusion(result))
        html = report.render_html(result)
        self.assertEqual(html.count('<svg '), 4)
        self.assertNotIn('<script', html)
        self.assertNotIn('Cookie', html)
        with tempfile.TemporaryDirectory() as directory:
            run.write_outputs(result, Path(directory))
            self.assertEqual(len(list(Path(directory).iterdir())), 5)
            self.assertEqual(json.loads((Path(directory) / 'summary.json').read_text())['max_users'], 10)
        result['stages'][-1]['state'] = 'guard_stop'
        result['outcome'] = 'guard_stop'
        self.assertIn('بار بیشتر نشد', report.conclusion(result))

    def test_never_advances_after_guard_stop(self):
        with tempfile.TemporaryDirectory() as directory:
            calls = []
            def fake_stage(args, users, output, windows):
                calls.append(users)
                stage = dict(fixture()['stages'][0])
                stage.update(users=users, state='guard_stop' if users == 5 else 'healthy')
                return stage
            argv = ['run.py', '--max-users', '10', '--output', directory]
            with patch('sys.argv', argv), patch('run.shutil.which', return_value='/fake/k6'), patch('run.run_stage', side_effect=fake_stage):
                self.assertEqual(run.main(), 0)
            self.assertEqual(calls, [1, 5])
            result = json.loads((Path(directory) / 'summary.json').read_text())
            self.assertEqual(result['outcome'], 'guard_stop')
            self.assertNotIn(10, [s['users'] for s in result['stages']])

    def test_response_classification_is_preserved(self):
        samples = [{'metric': 'nova_request_failed', 'value': 0, 'result': 'ok'},
                   {'metric': 'nova_request_failed', 'value': 1, 'result': 'http_429'}]
        self.assertEqual(run.measure(samples)['responses'], {'ok': 1, 'http_429': 1})
        self.assertEqual(run.measure(samples)['error_percent'], 50)

    def test_workflow_is_manual_only(self):
        path = Path(__file__).parents[2] / '.github/workflows/manual-load-test.yml'
        text = path.read_text()
        trigger = text.split('\non:\n', 1)[1].split('\npermissions:', 1)[0]
        self.assertIn('workflow_dispatch:', trigger)
        self.assertNotIn('  push:', trigger)
        self.assertNotIn('  pull_request:', trigger)
        self.assertNotIn('  schedule:', trigger)


def fixture():
    return {'started_at': '2026-10-15T12:00:00+00:00', 'target': 'https://nova-academy.ir',
            'scenario': 'public', 'session_count': 0, 'max_users': 10, 'p95_limit_ms': 2000,
            'error_limit_percent': 1, 'stages': [
                {'users': n, 'duration_seconds': 60, 'requests': n * 22, 'p95_ms': 200 + n * 35,
                 'error_percent': 0, 'rps': n * .44, 'state': 'healthy', 'routes': {'/': {'p95_ms': 200, 'error_percent': 0}}}
                for n in [1, 5, 10]], 'windows': [], 'outcome': 'limit_reached_without_breach'}


if __name__ == '__main__':
    unittest.main()

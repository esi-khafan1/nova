"""Offline, dependency-free report; no CDN, analytics or embedded session data."""
import math
from html import escape

STATES = {'healthy': 'در محدوده', 'guard_stop': 'توقف محافظ', 'insufficient': 'نمونه ناکافی',
          'infrastructure_error': 'اشکال اجرای ابزار', 'running': 'در حال اجرا', 'interrupted': 'متوقف‌شده'}


def number(value, digits=0):
    return '—' if value is None else f'{value:,.{digits}f}'


def conclusion(result):
    stages = result['stages']
    last_good = next((s['users'] for s in reversed(stages) if s['state'] == 'healthy'), None)
    stopped = next((s for s in stages if s['state'] == 'guard_stop'), None)
    if stopped:
        prefix = f"در پلهٔ {stopped['users']} کاربر مجازی، حد زمان پاسخ یا خطا رد شد و بار بیشتر نشد."
        return prefix + (f' آخرین پلهٔ داخل محدوده: {last_good} کاربر.' if last_good else ' هیچ پلهٔ سالمی تأیید نشد.') + ' این یک مرز مشاهده‌شده است، نه ظرفیت قطعی سرور.'
    if result['outcome'] == 'limit_reached_without_breach':
        return f"تا سقف انتخاب‌شدهٔ {result['max_users']} کاربر مجازی، عبور از حد دیده نشد؛ نقطهٔ کندی هنوز پیدا نشده است."
    if result['outcome'] == 'insufficient':
        return 'تعداد نمونه برای قضاوت کافی نبود؛ تست بدون افزایش بار متوقف شد. مدت پله را بیشتر کن.'
    return 'تست کامل نشده یا اجرای ابزار مشکل داشته است؛ از این گزارش نتیجهٔ ظرفیت نگیر.'


def chart(result, metric, title, unit, limit, color):
    points = [(s['users'], s[metric]) for s in result['stages'] if s[metric] is not None]
    if not points:
        return f'<section><h2>{escape(title)}</h2><p>هنوز داده‌ای ثبت نشده است.</p></section>'
    xmax = max(1, max(x for x, _ in points))
    ymax = max(limit, max(y for _, y in points), 1) * 1.15
    tick_step = max(1, math.ceil(xmax / 4))
    ticks = list(range(0, xmax + 1, tick_step))
    if ticks[-1] != xmax:
        if len(ticks) > 1 and xmax - ticks[-1] < tick_step * .6:
            ticks.pop()
        ticks.append(xmax)

    def plot(mobile):
        width, height, left, right, top, bottom = (480, 340, 106, 20, 38, 78) if mobile else (880, 320, 90, 30, 28, 60)
        px = lambda x: left + x / xmax * (width - left - right)
        py = lambda y: height - bottom - y / ymax * (height - top - bottom)
        labels = ''.join(f'<text x="{left-12}" y="{py(y)+5}" text-anchor="end">{number(y, 0 if ymax > 20 else 1)}</text><line x1="{left}" x2="{width-right}" y1="{py(y)}" y2="{py(y)}" stroke="#e6e5e3"/>' for y in [ymax * i / 4 for i in range(5)])
        labels += ''.join(f'<text x="{px(x)}" y="{height-bottom+30}" text-anchor="middle">{x}</text>' for x in ticks)
        marks = '<polyline points="' + ' '.join(f'{px(x)},{py(y)}' for x, y in points) + f'" fill="none" stroke="{color}" stroke-width="3"/>'
        marks += ''.join(f'<circle cx="{px(x)}" cy="{py(y)}" r="5" fill="{color}"><title>{x} users: {number(y, 2)} {unit}</title></circle>' for x, y in points)
        key = escape(metric) + ('-mobile' if mobile else '-desktop')
        css = 'chart-mobile' if mobile else 'chart-desktop'
        return f'''<svg class="{css}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="title-{key} desc-{key}" direction="ltr">
<title id="title-{key}">{escape(title)}</title><desc id="desc-{key}">Horizontal: concurrent virtual users; vertical: {unit}. Exact values in the table below.</desc>
{labels}<line x1="{left}" x2="{width-right}" y1="{py(limit)}" y2="{py(limit)}" stroke="#bc632b" stroke-width="2" stroke-dasharray="6 5"/>{marks}
<text x="{left}" y="24">{unit}</text><text x="{width/2}" y="{height-8}" text-anchor="middle">Concurrent virtual users</text></svg>'''

    return f'''<section><h2>{escape(title)}</h2><p class="legend"><span style="color:{color}">━━</span> مقدار هر پله &nbsp; <span style="color:#bc632b">┄┄</span> حد توقف: {number(limit)} {unit}</p>{plot(False)}{plot(True)}</section>'''


def markdown_summary(result):
    rows = ['## Nova manual load test', '', conclusion(result), '',
            f"- Target: {result['target']}", f"- Scenario: `{result['scenario']}` (read-only)",
            f"- Limits: p95 > {result['p95_limit_ms']} ms OR errors > {result['error_limit_percent']}%",
            '- Guard: two consecutive 15-second windows (at least 10 requests each); also checks each completed stage.',
            '- Download the workflow artifact, extract it, and open `report.html` for charts.', '',
            '| Concurrent VUs | Requests | p95 ms | Errors % | State |', '|---:|---:|---:|---:|---|']
    rows += [f"| {s['users']} | {s['requests']} | {number(s['p95_ms'], 1)} | {number(s['error_percent'], 2)} | {s['state']} |" for s in result['stages']]
    rows += ['', 'HTTP/server timings, not browser rendering or a write/submit-exam capacity test. A single regional runner is not all real users.', '']
    return '\n'.join(rows)


def render_html(result):
    rows = ''.join(f"<tr><th>{s['users']}</th><td>{s['requests']}</td><td>{number(s['p95_ms'],1)}</td><td>{number(s['error_percent'],2)}</td><td>{number(s['rps'],2)}</td><td>{STATES[s['state']]}</td></tr>" for s in result['stages'])
    responses = ''.join(f"<tr><td>{s['users']}</td><th dir='ltr'>{escape(kind)}</th><td>{count}</td></tr>" for s in result['stages'] for kind, count in s.get('responses', {'unclassified': s['requests']}).items())
    routes = ''.join(f"<tr><td>{s['users']}</td><th dir='ltr'>{escape(route)}</th><td>{number(v['p95_ms'],1)}</td><td>{number(v['error_percent'],2)}</td></tr>" for s in result['stages'] for route, v in s['routes'].items())
    scope = ('صفحات عمومی: خانه، اخبار، پادکست، دربارهٔ ما. این سناریو ظرفیت پنل، ثبت پاسخ یا ورود هم‌زمان را نمی‌سنجد.'
             if result['scenario'] == 'public' else f"فقط دریافت فهرست آزمون دانش‌آموز؛ {result['session_count']} نشست تستی میان کاربران مجازی توزیع شده است. اگر نشست کمتر از کاربر باشد، هویت‌ها مشترک‌اند. ورود و ثبت پاسخ تست نشده است.")
    charts = chart(result, 'p95_ms', 'زمان پاسخ p95 در برابر تعداد کاربران', 'ms', result['p95_limit_ms'], '#2783de') + chart(result, 'error_percent', 'خطا در برابر تعداد کاربران', '%', result['error_limit_percent'], '#c13f35')
    return f'''<!doctype html><html lang="fa" dir="rtl"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>گزارش تست بار نوا</title>
<style>*{{box-sizing:border-box}}body{{margin:0;background:#fff;color:#24374b;font:16px/1.8 system-ui,sans-serif}}main{{max-width:1100px;margin:auto;padding:32px 24px}}h1{{font-size:30px;line-height:1.5}}h2{{font-size:21px;margin:0 0 12px}}p{{margin:12px 0}}header{{border-bottom:1px solid #d9e8fa;padding-bottom:24px}}section{{padding:28px 0;border-bottom:1px solid #e6e5e3}}.verdict{{padding:16px 20px;background:#edf5ff;border-right:4px solid #2783de}}.muted,.legend{{color:#536477;font-size:14px}}svg{{display:block;width:100%;height:auto;font:18px system-ui;fill:#536477}}.chart-mobile{{display:none}}.scroll{{overflow-x:auto}}table{{border-collapse:collapse;min-width:580px;width:100%;font-size:14px}}th,td{{padding:12px;text-align:right;border-bottom:1px solid #e6e5e3}}thead{{background:#edf5ff}}code{{direction:ltr;unicode-bidi:embed}}@media(max-width:600px){{.chart-desktop{{display:none}}.chart-mobile{{display:block;font-size:24px}}}}@media(max-width:480px){{main{{padding:24px 16px}}h1{{font-size:25px}}}}</style>
<main><header><p class="muted">NOVA / MANUAL LOAD TEST</p><h1>گزارش پاسخ‌گویی سایت زیر بار</h1><p class="verdict">{escape(conclusion(result))}</p><p><b>هدف:</b> <span dir="ltr">{escape(result['target'])}</span></p><p class="muted">شروع UTC: <span dir="ltr">{escape(result['started_at'])}</span> — سناریو: {escape(result['scenario'])}</p></header>
<section><h2>این تست چه چیزی را اندازه گرفته؟</h2><p>{escape(scope)}</p><p>هر کاربر مجازی یک درخواست خواندنی می‌فرستد و ۱ تا ۳ ثانیه مکث می‌کند. کاربران هم‌زمان با درخواست در ثانیه یکسان نیستند. ۱۰ ثانیهٔ اول هر پله از آمار حذف می‌شود.</p><p>محافظ: p95 بالاتر از {number(result['p95_limit_ms'])} میلی‌ثانیه یا خطای بالاتر از {number(result['error_limit_percent'],1)}٪ در دو بازهٔ متوالی ۱۵ثانیه‌ای با حداقل ۱۰ درخواست در هر بازه؛ همچنین هر پلهٔ کامل با حداقل ۲۰ درخواست ارزیابی می‌شود. نمونهٔ ناکافی یا خطای ابزار، افزایش بار را متوقف می‌کند.</p></section>
{charts}<section><h2>دادهٔ دقیق پله‌ها</h2><div class="scroll"><table><thead><tr><th>کاربر مجازی</th><th>درخواست</th><th>p95 (ms)</th><th>خطا (%)</th><th>درخواست/ثانیه</th><th>وضعیت</th></tr></thead><tbody>{rows}</tbody></table></div></section>
<section><h2>تفکیک مسیرها</h2><div class="scroll"><table><thead><tr><th>کاربر</th><th>مسیر</th><th>p95 (ms)</th><th>خطا (%)</th></tr></thead><tbody>{routes}</tbody></table></div></section>
<section><h2>نوع پاسخ‌ها و علت خطا</h2><p class="muted">ok: پاسخ معتبر؛ http_429: محدودیت نرخ؛ http_403: دسترسی یا فیلتر امنیتی؛ network_error: تایم‌اوت یا خطای شبکه؛ unexpected_content: محتوای نامنتظره یا نشست نامعتبر. unclassified: جزئیات نوع پاسخ در این اجرا ثبت نشده؛ این دسته‌بندی نشانه است، نه تشخیص قطعی ریشهٔ خطا.</p><div class="scroll"><table><thead><tr><th>کاربر</th><th>نوع پاسخ</th><th>تعداد</th></tr></thead><tbody>{responses}</tbody></table></div></section><section><h2>محدودیت تفسیر</h2><p>این زمان HTTP است، نه زمان نمایش کامل صفحه در مرورگر. کش Cloudflare، محل GitHub Runner و شرایط لحظه‌ای شبکه روی نتیجه اثر دارند. این تست علت کندی را از دیتابیس، شبکه یا برنامه جدا نمی‌کند؛ برای ریشه‌یابی، آمار Cloudflare و Supabase در همین بازه را بررسی کن.</p><p>توقف به‌علت خطا می‌تواند ناشی از WAF، نشست منقضی یا محدودیت سرویس باشد، نه فقط کمبود ظرفیت. هیچ رکوردی در آزمون‌ها، پاسخ‌ها یا ثبت‌نام ایجاد یا ویرایش نشده است. درخواست‌ها ممکن است لاگ، مصرف سرویس و تمدید عادی نشست ایجاد کنند.</p><p class="muted">برای مرز دقیق‌تر، پس از استراحت سایت بازهٔ بین آخرین پلهٔ سالم و اولین پلهٔ ناموفق را دوباره بررسی کن. این نتیجه را به بار نوشتنی یا تعداد دانش‌آموزان واقعی تعمیم نده.</p></section></main></html>'''

import http from 'k6/http';
import { sleep } from 'k6';
import { Trend, Rate } from 'k6/metrics';

const latency = new Trend('nova_request_ms', true);
const failures = new Rate('nova_request_failed');
const base = __ENV.NOVA_BASE_URL;
const student = __ENV.NOVA_SCENARIO === 'student';
const cookies = student ? JSON.parse(__ENV.NOVA_STUDENT_COOKIES || '[]') : [];
const paths = student ? ['/dashboard/student/exams'] : ['/', '/news', '/podcasts', '/about'];

export const options = {
  scenarios: {
    browse: { executor: 'constant-vus', vus: Number(__ENV.NOVA_VUS || 1),
      duration: __ENV.NOVA_DURATION || '60s', gracefulStop: '0s' },
  },
  discardResponseBodies: false,
  maxRedirects: 0,
  insecureSkipTLSVerify: false,
  userAgent: 'Mozilla/5.0 (compatible; NovaOwnerLoadTest/1.0; k6)',
  systemTags: ['name', 'status', 'method', 'scenario'],
  summaryTrendStats: ['avg', 'med', 'p(95)', 'p(99)', 'max'],
};

export default function browse() {
  // Offset journeys to avoid every user hitting exactly the same route at once.
  const path = paths[(__ITER + __VU - 1) % paths.length];
  const headers = { Accept: 'text/html', 'X-Nova-Load-Test': 'manual-read-only' };
  if (student) headers.Cookie = cookies[(__VU - 1) % cookies.length];
  const response = http.get(`${base}${path}`, {
    headers, timeout: '10s', redirects: 0, tags: { name: path },
  });
  const valid = response.status === 200
    && (response.headers['Content-Type'] || '').includes('text/html')
    && response.headers['Cf-Mitigated'] !== 'challenge'
    && (!student || (response.body || '').includes('آزمون‌های کنکوری'));
  // Redirects to login, bot challenges and HTTP errors must not count as fast successes.
  latency.add(response.timings.duration, { route: path });
  const result = valid ? 'ok' : response.status === 0 ? 'network_error'
    : response.status !== 200 ? `http_${response.status}`
    : response.headers['Cf-Mitigated'] === 'challenge' ? 'challenge' : 'unexpected_content';
  failures.add(!valid, { route: path, result });
  // Think time: concurrent virtual users are NOT requests per second.
  sleep(1 + Math.random() * 2);
}

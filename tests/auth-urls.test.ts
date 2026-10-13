import assert from "node:assert/strict";
import { AUTH_SITE_ORIGIN, emailConfirmationUrl, authRedirectUrl, authCallbackErrorUrl, canonicalWorkerCallback } from "../lib/auth-urls";

assert.equal(emailConfirmationUrl("/dashboard/student"), `${AUTH_SITE_ORIGIN}/auth/callback?next=%2Fdashboard%2Fstudent`);
assert.equal(authRedirectUrl("/dashboard/counselor?tab=students"), `${AUTH_SITE_ORIGIN}/dashboard/counselor?tab=students`);
for (const unsafe of ["https://evil.example", "//evil.example", "/\\evil.example", "/auth", null]) {
  assert.equal(authRedirectUrl(unsafe), `${AUTH_SITE_ORIGIN}/dashboard`);
  assert.equal(new URL(emailConfirmationUrl(unsafe)).searchParams.get("next"), "/dashboard");
}
assert.equal(new URL(authCallbackErrorUrl("/dashboard/student")).origin, AUTH_SITE_ORIGIN);
assert.equal(new URL(authCallbackErrorUrl("/dashboard/student")).searchParams.get("next"), "/dashboard/student");
assert.equal(canonicalWorkerCallback("https://nova.example.workers.dev/auth/callback?code=test&next=%2Fdashboard%2Fstudent", "nova.example.workers.dev"), `${AUTH_SITE_ORIGIN}/auth/callback?code=test&next=%2Fdashboard%2Fstudent`);
assert.equal(canonicalWorkerCallback("https://internal.example.workers.dev/auth/callback?code=test", "nova-academy.ir"), null);
assert.equal(canonicalWorkerCallback(`${AUTH_SITE_ORIGIN}/auth/callback?code=test`, "nova-academy.ir"), null);
assert.equal(canonicalWorkerCallback("http://localhost:3000/auth/callback", "localhost:3000"), null);
console.log("Auth URL tests passed.");

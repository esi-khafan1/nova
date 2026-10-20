import assert from "node:assert/strict";
import { validConfirmationHash, confirmationHeaders } from "../lib/email-confirmation";
assert.equal(validConfirmationHash("a".repeat(56)), true);
assert.equal(validConfirmationHash("a".repeat(64)), true);
for (const invalid of [null, undefined, "", "x", "a".repeat(257), '<script>alert("x")</script>', '" onload="alert(1)', "foo&next=https://evil.example", "a".repeat(56) + "\n"]) {
  assert.equal(validConfirmationHash(invalid), false);
}
assert.equal(confirmationHeaders["Referrer-Policy"], "same-origin");
assert.match(confirmationHeaders["Cache-Control"], /no-store/);
console.log("Email confirmation validation tests passed.");

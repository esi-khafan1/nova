import assert from "node:assert/strict";
import { isEnglishPasswordInput } from "../lib/password-input";
for (const value of ["", "Password123", "Abc!@#$%^&*()_+-=[]{};:'\",.<>/?\\|`~", "pass word", " leading and trailing "]) {
  assert.equal(isEnglishPasswordInput(value), true);
}
for (const value of ["رمزعبور", "Password۱۲۳", "Password١٢٣", "Pässword", "abc🙂", "abc\n", "abc\t", "abc\u200c", "abc\u200f", "abc\u00a0"]) {
  assert.equal(isEnglishPasswordInput(value), false);
}
console.log("English password input validation tests passed.");

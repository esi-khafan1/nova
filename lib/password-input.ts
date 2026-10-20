/** Printable English-keyboard characters; never transliterate or trim passwords. */
export function isEnglishPasswordInput(value: string): boolean {
  return !/[^\x20-\x7e]/.test(value);
}

export const englishPasswordMessage = "لطفاً رمز عبورت را با کیبورد انگلیسی بنویس.";

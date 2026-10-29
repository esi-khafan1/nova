/** Normalize Iranian mobile numbers only; never coerce passwords or OTPs. */
export function normalizeMobile(value: unknown): string | null {
 if(typeof value!=="string")return null;
 const text=value.trim().replace(/[۰-۹]/g,c=>String(c.charCodeAt(0)-1776)).replace(/[٠-٩]/g,c=>String(c.charCodeAt(0)-1632)).replace(/[\s()-]/g,"").replace(/^\+/,"").replace(/^0098/,"98");
 return /^09\d{9}$/.test(text)?`98${text.slice(1)}`:/^989\d{9}$/.test(text)?text:null;
}
// Keep legacy normalization for existing records, but public auth accepts only
// ASCII phone input so Persian/Arabic keypad digits are never silently changed.
export function isEnglishMobileInput(value: unknown): value is string {
 return typeof value === "string" && !/[^\x20-\x7e]/.test(value) && normalizeMobile(value) !== null;
}
export const englishPhoneMessage = "شماره تلفن همراه را با اعداد انگلیسی وارد کن.";
export function hasConfirmedContact(user:{email_confirmed_at?:string|null;phone_confirmed_at?:string|null}){
 return Boolean(user.email_confirmed_at||user.phone_confirmed_at);
}

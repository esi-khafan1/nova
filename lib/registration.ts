export const provinces = ["آذربایجان شرقی","آذربایجان غربی","اردبیل","اصفهان","البرز","ایلام","بوشهر","تهران","چهارمحال و بختیاری","خراسان جنوبی","خراسان رضوی","خراسان شمالی","خوزستان","زنجان","سمنان","سیستان و بلوچستان","فارس","قزوین","قم","کردستان","کرمان","کرمانشاه","کهگیلویه و بویراحمد","گلستان","گیلان","لرستان","مازندران","مرکزی","هرمزگان","همدان","یزد"];
export const registrationLabels:Record<string,string>={incomplete:"اطلاعات ناقص",pending:"منتظر تأیید و تخصیص مشاور",active:"فعال"};
export type RegistrationRow={student_id:string;full_name:string;phone:string|null;telegram_id:string|null;grade:number|null;study_field:import("./study-catalog").StudyField|null;province:string|null;city:string|null;registration_status:string;receipt_path:string|null;receipt_name:string|null;counselor_name:string|null;created_at:string};
export type RegistrationFormValues={full_name?:string;first_name?:string;last_name?:string;phone?:string;telegram_id?:string;grade?:number;study_field?:string;province?:string;city?:string;receipt_name?:string};
export function normalizeDigits(value:string){return value.replace(/[۰-۹٠-٩]/g,c=>String("۰۱۲۳۴۵۶۷۸۹".includes(c)?"۰۱۲۳۴۵۶۷۸۹".indexOf(c):"٠١٢٣٤٥٦٧٨٩".indexOf(c)));}
export function validateRegistration(v:RegistrationFormValues){
 if(v.full_name!==undefined){const name=v.full_name.trim();if(name.length<3||name.length>121||!/^\S+(?:\s+\S+)+$/u.test(name))return "نام و نام خانوادگی را کامل وارد کن.";}
 else if(!v.first_name||v.first_name.trim().length<2||v.first_name.length>50||!v.last_name||v.last_name.trim().length<2||v.last_name.length>70)return "نام و نام خانوادگی را کامل وارد کن.";
 if(!/^09\d{9}$/.test(v.phone??""))return "شمارهٔ همراه را به صورت ۰۹xxxxxxxxx وارد کن.";
 if(!/^[A-Za-z][A-Za-z0-9_]{4,31}$/.test(v.telegram_id??""))return "آیدی تلگرام معتبر را بدون لینک و با حداقل ۵ کاراکتر وارد کن.";
 if(![10,11,12].includes(v.grade??0)||!["mathematics","experimental_sciences","humanities"].includes(v.study_field??""))return "پایه و رشته را انتخاب کن.";
 if(!provinces.includes(v.province??"")||!v.city||v.city.trim().length<2||v.city.length>60)return "استان و شهر محل سکونت را وارد کن.";
 return null;
}
export function receiptImageType(bytes:Uint8Array):{mime:string;extension:string}|null{
 if(bytes[0]===255&&bytes[1]===216&&bytes[2]===255)return {mime:"image/jpeg",extension:"jpg"};
 if([137,80,78,71,13,10,26,10].every((n,i)=>bytes[i]===n))return {mime:"image/png",extension:"png"};
 if(new TextDecoder().decode(bytes.slice(0,4))==="RIFF"&&new TextDecoder().decode(bytes.slice(8,12))==="WEBP")return {mime:"image/webp",extension:"webp"};
 return null;
}
// Neutralize spreadsheet formulas, including whitespace-prefixed formulas.
export function csvCell(value:unknown){let s=String(value??"");if(/^[\s\uFEFF]*[=+@-]/u.test(s))s="'"+s;return '"'+s.replaceAll('"','""')+'"';}

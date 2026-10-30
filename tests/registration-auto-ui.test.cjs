const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { renderToStaticMarkup } = require('react-dom/server');

const student = '11111111-1111-4111-8111-111111111111';
const counselor = '22222222-2222-4222-8222-222222222222';
const receipt = `${student}/receipt.png`;
const row = (name, changes={}) => ({student_id:name,full_name:name,phone:null,telegram_id:null,grade:10,study_field:'humanities',province:null,city:null,registration_status:'incomplete',receipt_path:null,counselor_id:null,has_account_details:false,created_at:'2026-10-30',...changes});
const rows=[
  row('manual',{has_account_details:true}),
  row('paid',{registration_status:'pending',receipt_path:receipt,has_account_details:true}),
  row('active',{registration_status:'active',receipt_path:receipt}),
  row('incomplete'),
];
const moduleStub={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('components/dashboard/registration-directory.tsx','utf8'),{
  compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022},
}).outputText,{
  module:moduleStub,exports:moduleStub.exports,
  require(name){
    if(name==='react/jsx-runtime')return require('react/jsx-runtime');
    if(name==='next/link')return {default:props=>React.createElement('a',{href:props.href},props.children)};
    if(name==='@/lib/auth')return {requireProfile:async()=>({supabase:{from:()=>({select:()=>({eq:()=>({eq:()=>({order:async()=>({data:[{id:counselor,full_name:'مشاور'}],error:null})})})})})}})};
    if(name==='@/lib/load-registration-directory')return {loadRegistrationDirectory:async()=>rows};
    if(name==='@/lib/registration')return {
      isPendingUnassignedReceipt:r=>r.registration_status==='pending'&&Boolean(r.receipt_path)&&!r.counselor_id,
      prioritizePendingUnassignedReceipts:all=>[...all.filter(r=>r.registration_status==='pending'&&r.receipt_path&&!r.counselor_id),...all.filter(r=>!(r.registration_status==='pending'&&r.receipt_path&&!r.counselor_id))],
      registrationLabels:{incomplete:'ناقص',pending:'منتظر بررسی',active:'فعال'},
    };
    if(name==='@/lib/courses')return {courseTypeLabel:()=>'',courseDurationLabel:()=>''};
    if(name==='@/lib/study-catalog')return {studyFieldLabels:{humanities:'انسانی'}};
    if(name==='@/app/dashboard/admin/registrations/actions')return {activateStudent:()=>{},assignCounselor:()=>{},uploadStudentReceipt:()=>{}};
    if(name==='@/components/dashboard/activation-submit-button')return {ActivationSubmitButton:({hasReceipt})=>React.createElement('button',{'data-path':hasReceipt?'receipt':'manual'},hasReceipt?'تأیید فیش و فعال‌سازی':'فعال‌سازی بدون فیش')};
    if(name==='@/components/dashboard/required-fields-form')return {RequiredFieldsForm:({className,children})=>React.createElement('form',{className},children)};
    if(name==='@/app/registration.css')return {};
    throw Error(name);
  },
});
(async()=>{
  const html=renderToStaticMarkup(await moduleStub.exports.RegistrationDirectory({audience:'admin'}));
  const body=html.slice(html.indexOf('<tbody>'));
  const cards=[...body.matchAll(/<tr\b[^>]*>([\s\S]*?)<\/tr>/g)].map(match=>match[1]);
  assert.equal(cards.length,4);
  assert.match(cards[0],/paid/);
  assert.match(cards[0],/اولویت بررسی · فیش ارسال شده/);
  assert.match(cards[0],/data-path="receipt"/);
  assert.match(cards[0],/name="receipt"[^>]*type="file"|type="file"[^>]*name="receipt"/);
  assert.match(cards[0],/جایگزینی فیش دریافت‌شده در تلگرام/);
  assert.match(cards[1],/بارگذاری فیش دریافت‌شده در تلگرام/);
  assert.doesNotMatch(cards[2],/name="receipt"/);
  assert.doesNotMatch(cards[3],/name="receipt"/);
  const css=fs.readFileSync('app/registration.css','utf8');
  assert.match(html, /<tr class="registration-priority-row"/);
  assert.match(html, /<tr class="registration-receipt-row"/);
  assert.match(html, /<tr class="registration-ordinary-row"/);
  assert.match(css, /tbody tr\.registration-receipt-row\{width:100%/);
  assert.match(css, /tbody tr\{width:calc\(100% - 28px\)/);
  assert.match(css, /tbody tr\.registration-priority-row\{width:100%[^}]*border-right:6px solid/);
  assert.match(css, /tbody tr\.registration-priority-row td\{padding-top:28px;padding-bottom:28px\}/);
  assert.match(css, /@container \(max-width:960px\)[\s\S]*tbody tr\{[^}]*width:calc\(100% - 18px\)/);
  assert.match(cards[1],/manual/);
  assert.match(cards[1],/data-path="manual"/);
  assert.match(cards[2],/active/);
  assert.match(cards[2],/اختصاص مشاور به حساب فعال/);
  assert.doesNotMatch(cards[3],/data-path=|اختصاص مشاور به حساب فعال/);
  assert.doesNotMatch(body,/receipt_confirmation|manual_confirmation|فعال‌سازی دستی بدون فیش|اختصاص مشاور و فعال‌سازی حساب/);
  const confirm=fs.readFileSync('components/dashboard/activation-submit-button.tsx','utf8');
  assert.match(confirm,/window\.confirm\(message\)/);
  assert.match(confirm,/if \(!event\.currentTarget\.form\?\.reportValidity\(\)\)/);
  console.log('PASS: one labeled activation path per inactive account; receipt submissions visibly first; no redundant checkboxes or unsafe assignment');
})().catch(error=>{console.error(error);process.exitCode=1});

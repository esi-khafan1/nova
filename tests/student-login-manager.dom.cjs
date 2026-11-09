const assert=require('node:assert/strict');const fs=require('node:fs');const vm=require('node:vm');const ts=require('typescript');const React=require('react');
const {JSDOM}=require('jsdom');const dom=new JSDOM('<div id="root"></div>',{url:'https://example.test'});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');const {act}=React;
const calls=[];global.fetch=async(url,opts)=>{const body=JSON.parse(opts.body);calls.push(body);return {ok:true,json:async()=>body.step==='lookup'?{phone:'989123456789',student:{student_id:'student',full_name:'دانش آموز',phone_confirmed:false}}:body.step==='start'?{challenge_id:'challenge'}:{ok:true}}};
const mod={exports:{}};const compiled=ts.transpileModule(fs.readFileSync('components/dashboard/student-login-manager.tsx','utf8'),{compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
vm.runInThisContext(`(function(require,module,exports){${compiled}\n})`)(require,mod,mod.exports);
const root=createRoot(document.getElementById('root'));
function setValue(el,value){Object.getOwnPropertyDescriptor(el.tagName==='SELECT'?window.HTMLSelectElement.prototype:window.HTMLInputElement.prototype,'value').set.call(el,value);el.dispatchEvent(new window.Event(el.tagName==='SELECT'?'change':'input',{bubbles:true}));}
(async()=>{
 await act(async()=>root.render(React.createElement(mod.exports.StudentLoginManager)));
 await act(async()=>setValue(document.querySelector('input[type=tel]'),'09123456789'));
 await act(async()=>document.querySelector('form').dispatchEvent(new window.Event('submit',{bubbles:true,cancelable:true})));
 assert.equal(calls[0].step,'lookup');assert.match(document.body.textContent,/دانش آموز/);
 await act(async()=>setValue(document.querySelector('select'),'password_confirm'));
 await act(async()=>document.querySelectorAll('form')[1].dispatchEvent(new window.Event('submit',{bubbles:true,cancelable:true})));
 assert.equal(calls[1].action,'password_confirm');assert.equal(calls[1].target_id,'student');
 assert.match(document.body.textContent,/کد به ایمیل/);assert.ok(document.querySelector('input[autocomplete=one-time-code]'));
 await act(async()=>setValue(document.querySelector('input[autocomplete=one-time-code]'),'12345678'));
 await act(async()=>setValue(document.querySelector('input[type=password]'),'English123'));
 await act(async()=>document.querySelectorAll('form')[1].dispatchEvent(new window.Event('submit',{bubbles:true,cancelable:true})));
 assert.equal(calls[2].step,'verify');assert.equal(calls[2].challenge_id,'challenge');assert.equal(calls[2].code,'12345678');assert.equal(calls[2].password,'English123');
 assert.match(document.body.textContent,/خدمات و مشاور تغییری نکردند/);
 await act(async()=>root.unmount());console.log('PASS: student login lookup, operation selection and OTP confirmation UI');
})().catch(e=>{console.error(e);process.exitCode=1});

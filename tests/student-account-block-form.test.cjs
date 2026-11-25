const assert = require('node:assert/strict');
const esbuild = require('esbuild');
const { JSDOM } = require('jsdom');
const React = require('react');
const { act } = React;
const { createRoot } = require('react-dom/client');

(async () => {
  const {outputFiles} = await esbuild.build({entryPoints:['components/dashboard/student-account-block-form.tsx'],
    bundle:true,platform:'node',format:'cjs',jsx:'automatic',packages:'external',write:false});
  const mod={exports:{}};
  new Function('require','module','exports',outputFiles[0].text)(require,mod,mod.exports);
  const dom = new JSDOM('<!doctype html><html><body><div id="root"></div></body></html>',{url:'https://example.test'});
  global.window=dom.window; global.document=dom.window.document; global.navigator=dom.window.navigator;
  global.IS_REACT_ACT_ENVIRONMENT=true;
  dom.window.HTMLDialogElement.prototype.showModal=function(){this.setAttribute('open','')};
  dom.window.HTMLDialogElement.prototype.close=function(){this.removeAttribute('open')};
  const root=createRoot(document.querySelector('#root'));
  const props={studentId:'11111111-1111-4111-8111-111111111111',studentName:'دانش‌آموز نمونه',blocked:false,search:'نام',page:2,filter:'all',action:async()=>{}};
  await act(async()=>root.render(React.createElement(mod.exports.StudentAccountBlockForm,props)));
  const dialog=document.querySelector('dialog');
  assert.ok(!dialog.hasAttribute('open'));
  assert.equal(document.querySelector('.user-block-button').textContent,'مسدود کردن حساب');
  assert.ok(dialog.textContent.includes('دانش‌آموز نمونه'));
  assert.ok(dialog.textContent.includes('سوابق محفوظ می‌ماند'));
  assert.equal(document.querySelector('input[name=blocked]').value,'true');
  assert.equal(document.querySelector('input[name=directory_search]').value,'نام');
  assert.equal(document.querySelector('input[name=directory_page]').value,'2');
  await act(async()=>document.querySelector('.user-block-button').click());
  assert.ok(dialog.hasAttribute('open'));
  await act(async()=>document.querySelector('.user-block-cancel').click());
  assert.ok(!dialog.hasAttribute('open'));
  await act(async()=>root.render(React.createElement(mod.exports.StudentAccountBlockForm,{...props,blocked:true})));
  assert.equal(document.querySelector('.user-block-button').textContent,'رفع مسدودی حساب');
  assert.equal(document.querySelector('input[name=blocked]').value,'false');
  assert.equal(document.querySelector('.user-block-confirm').textContent,'رفع مسدودی');
  await act(async()=>root.unmount());
  console.log('PASS: block confirmation, cancellation, labels and preserved directory state');
})().catch(error=>{console.error(error);process.exitCode=1});

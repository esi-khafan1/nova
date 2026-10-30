const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const { JSDOM } = require('jsdom');
const React = require('react');
const { act } = React;

(async () => {
  const dom = new JSDOM('<!doctype html><html><body><div id="root"></div></body></html>', { url: 'https://nova.example' });
  for (const name of ['window', 'document', 'navigator', 'HTMLElement', 'HTMLInputElement', 'HTMLSelectElement', 'HTMLTextAreaElement', 'Event', 'MouseEvent']) {
    global[name] = name === 'navigator' ? dom.window.navigator : dom.window[name];
  }
  global.IS_REACT_ACT_ENVIRONMENT = true;
  const { createRoot } = require('react-dom/client');
  const load = file => {
    const mod = { exports: {} };
    vm.runInNewContext(ts.transpileModule(readFileSync(file, 'utf8'), {
      compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, jsx: ts.JsxEmit.ReactJSX },
    }).outputText, {
      module: mod, exports: mod.exports,
      HTMLInputElement: dom.window.HTMLInputElement,
      HTMLSelectElement: dom.window.HTMLSelectElement,
      HTMLTextAreaElement: dom.window.HTMLTextAreaElement,
      window: dom.window,
      require(name) { if (name === 'react') return React; if (name === 'react/jsx-runtime') return require('react/jsx-runtime'); throw Error(name); },
    });
    return mod.exports;
  };
  const { RequiredFieldsForm } = load('components/dashboard/required-fields-form.tsx');
  const { ActivationSubmitButton } = load('components/dashboard/activation-submit-button.tsx');
  const root = createRoot(dom.window.document.getElementById('root'));
  let serverCalls = 0, confirms = 0;
  dom.window.confirm = () => { confirms++; return false; };
  await act(async () => root.render(React.createElement(RequiredFieldsForm, { className: 'test', action: () => { serverCalls++; } },
    React.createElement('label', null, 'مشاور', React.createElement('select', { name: 'counselor_id', required: true, defaultValue: '' },
      React.createElement('option', { value: '', disabled: true }, 'انتخاب مشاور'),
      React.createElement('option', { value: 'counselor-id' }, 'مشاور تأییدشده'))),
    React.createElement(ActivationSubmitButton, { hasReceipt: true, disabled: false }))));
  const select = dom.window.document.querySelector('select');
  const button = dom.window.document.querySelector('button');
  const form = button.form;
  const layoutBeforeValidation = form.innerHTML;
  await act(async () => button.click());
  assert.equal(form.innerHTML, layoutBeforeValidation, 'Native browser bubble must not add an inline element or change row layout');
  assert.doesNotMatch(form.textContent, /لطفاً این فیلد را پر کن/);
  assert.equal(serverCalls, 0, 'No server action may run without an approved counselor choice');
  assert.equal(confirms, 0, 'Do not confirm an incomplete form');
  assert.equal(select.validationMessage, 'لطفاً این فیلد را پر کن.', 'Show the native required-field bubble by the select');
  await act(async () => {
    select.value = 'counselor-id';
    select.dispatchEvent(new dom.window.Event('input', { bubbles: true }));
    select.dispatchEvent(new dom.window.Event('change', { bubbles: true }));
  });
  assert.equal(select.validationMessage, '', 'Correcting the value clears the custom error');
  await act(async () => button.click());
  assert.equal(confirms, 1, 'Only a complete form reaches the confirmation');
  assert.equal(serverCalls, 0, 'Declining confirmation must not send a request');
  await act(async () => root.render(React.createElement(React.Fragment, null,
    React.createElement(RequiredFieldsForm, { className: 'assign', action: () => { serverCalls++; } },
      React.createElement('select', { name: 'counselor_id', required: true, defaultValue: '' },
        React.createElement('option', { value: '' }, 'انتخاب مشاور'), React.createElement('option', { value: 'counselor-id' }, 'مشاور')),
      React.createElement('button', { type: 'submit' }, 'اختصاص مشاور')),
    React.createElement(RequiredFieldsForm, { className: 'upload', action: () => { serverCalls++; } },
      React.createElement('input', { name: 'receipt', type: 'file', required: true }),
      React.createElement('button', { type: 'submit' }, 'ثبت فیش')))));
  const assignForm = dom.window.document.querySelector('.assign');
  const uploadForm = dom.window.document.querySelector('.upload');
  const assignLayout = assignForm.innerHTML;
  const uploadLayout = uploadForm.innerHTML;
  await act(async () => assignForm.querySelector('button').click());
  assert.equal(assignForm.querySelector('select').validationMessage, 'لطفاً این فیلد را پر کن.');
  assert.equal(assignForm.innerHTML, assignLayout);
  await act(async () => uploadForm.querySelector('button').click());
  assert.equal(uploadForm.querySelector('input').validationMessage, 'لطفاً این فیلد را پر کن.');
  assert.equal(uploadForm.innerHTML, uploadLayout);
  assert.equal(serverCalls, 0, 'Missing required counselor or receipt never reaches a server action');
  await act(async () => root.unmount());
  dom.window.close();
  console.log('PASS: empty counselor shows an immediate field-level browser message and cannot submit; correction clears it before confirmation');
})().catch(error => { console.error(error); process.exitCode = 1; });

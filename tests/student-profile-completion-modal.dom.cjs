const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { JSDOM } = require('jsdom');
const { act } = React;

test('panel entry opens the completion message; its action reaches the form without a repeat popup', async () => {
  const dom = new JSDOM('<!doctype html><html><body><div class="student-portal" id="root"></div></body></html>', {
    url: 'https://nova.test/dashboard/student', pretendToBeVisual: true,
  });
  global.window = dom.window;
  global.document = dom.window.document;
  global.navigator = dom.window.navigator;
  global.IS_REACT_ACT_ENVIRONMENT = true;
  const { createRoot } = require('react-dom/client');
  const Link = ({ children, ...props }) => React.createElement('a', props, children);
  const mod = { exports: {} };
  vm.runInNewContext(ts.transpileModule(readFileSync('components/dashboard/student-profile-completion-notice.tsx', 'utf8'), {
    compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
  }).outputText, {
    module: mod, exports: mod.exports, window: dom.window,
    require(name) {
      if (name === 'react') return React;
      if (name === 'react/jsx-runtime') return require('react/jsx-runtime');
      if (name === 'next/link') return { default: Link };
      throw Error(name);
    },
  });
  let opened = 0;
  dom.window.HTMLDialogElement.prototype.showModal = function () { opened++; this.setAttribute('open', ''); };
  dom.window.HTMLDialogElement.prototype.close = function () { this.removeAttribute('open'); };
  const { StudentProfileCompletionNotice: Notice } = mod.exports;
  const host = document.getElementById('root');
  let root = createRoot(host);
  try {
    await act(async () => root.render(React.createElement(Notice, { issue: 'استان و شهر محل سکونت را وارد کن.', active: false })));
    let dialog = host.querySelector('dialog');
    assert.equal(dialog.open, true);
    assert.equal(opened, 1);
    assert.match(dialog.textContent, /استان و شهر محل سکونت/);
    assert.doesNotMatch(dialog.textContent, /حسابت فعال است/);
    assert.equal(dialog.querySelector('a').getAttribute('href'), '/dashboard/student/account#student-account-details');
    await act(async () => dialog.querySelector('button').click());
    assert.equal(dialog.open, false);
    await act(async () => root.render(React.createElement(Notice, { issue: 'استان و شهر محل سکونت را وارد کن.', active: false })));
    assert.equal(opened, 1, 'A re-render is not a second panel entry.');
    await act(async () => root.unmount());

    dom.window.history.replaceState(null, '', '/dashboard/student/account#student-account-details');
    root = createRoot(host);
    await act(async () => root.render(React.createElement(Notice, { issue: 'پایه و رشته را انتخاب کن.', onAccountPage: true })));
    assert.equal(host.querySelector('dialog').open, false, 'Following the completion link must not cover the form.');
    await act(async () => root.unmount());
    dom.window.history.replaceState(null, '', '/dashboard/student/account');
    root = createRoot(host);
    await act(async () => root.render(React.createElement(Notice, { issue: 'پایه و رشته را انتخاب کن.', onAccountPage: true })));
    dialog = host.querySelector('dialog');
    assert.equal(dialog.open, true, 'Direct avatar entry to account shows the message.');
    assert.equal(dialog.querySelector('a').getAttribute('href'), '#student-account-details');
  } finally {
    await act(async () => root.unmount());
    dom.window.close();
    delete global.window; delete global.document; delete global.navigator; delete global.IS_REACT_ACT_ENVIRONMENT;
  }
});

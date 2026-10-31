// Header/menu choreography must keep the original navigation and keyboard access.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { act, forwardRef } = React;
const { JSDOM } = require('jsdom');
const source = fs.readFileSync('components/landing-header.tsx', 'utf8');
assert.match(source, /stiffness: 260, damping: 28, mass: \.9/);
assert.match(source, /opacity: 0, x: 18/);
assert.match(source, /\.18 \+ index \* \.05/);
assert.match(source, /rotate: open \? 45 : 0/);
assert.match(source, /rotate: open \? -45 : 0/);
assert.match(source, /useReducedMotion/);

const dom = new JSDOM('<div id="root"></div>', { url: 'https://nova.example/' });
global.window = dom.window;
global.document = dom.window.document;
global.IS_REACT_ACT_ENVIRONMENT = true;
const components = new Map();
const motion = new Proxy({}, { get(_target, tag) {
  if (!components.has(tag)) components.set(tag, forwardRef(function MockMotion({ children, ...props }, ref) {
    for (const key of ['initial', 'animate', 'exit', 'transition']) delete props[key];
    return React.createElement(tag, { ...props, ref }, children);
  }));
  return components.get(tag);
} });
const moduleStub = { exports: {} };
vm.runInNewContext(ts.transpileModule(source, {
  fileName: 'landing-header.tsx',
  compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
}).outputText, {
  module: moduleStub, exports: moduleStub.exports,
  require: name => name === 'react' ? React : name === 'motion/react' ? {
    AnimatePresence: ({ children }) => children, motion, useReducedMotion: () => false,
  } : name === 'next/link' ? { __esModule: true, default: ({ children, ...props }) => { delete props.prefetch; return React.createElement('a', props, children); } }
    : name === 'react/jsx-runtime' ? require('react/jsx-runtime') : assert.fail(name),
  document, window, Map,
});
const { createRoot } = require('react-dom/client');
const root = createRoot(document.getElementById('root'));
const click = async element => act(async () => element.dispatchEvent(new window.MouseEvent('click', { bubbles: true })));
(async () => {
  await act(async () => root.render(React.createElement(moduleStub.exports.LandingHeader, { isAuthenticated: false })));
  const trigger = document.querySelector('.nova-menu-trigger');
  assert.equal(trigger.getAttribute('aria-expanded'), 'false');
  assert.equal(document.querySelector('.nova-menu-panel'), null);
  await click(trigger);
  const panel = document.querySelector('.nova-menu-panel');
  assert.equal(trigger.getAttribute('aria-expanded'), 'true');
  assert.equal(panel.getAttribute('aria-modal'), 'true');
  assert.equal(document.body.style.overflow, 'hidden');
  assert.equal(document.activeElement.getAttribute('aria-label'), 'بستن منو');
  assert.equal(panel.querySelectorAll('nav a').length, 5);
  assert.match(panel.querySelector('nav a').href, /auth\?mode=signin/);
  const last = [...panel.querySelectorAll('nav a')].at(-1);
  last.focus();
  await act(async () => document.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Tab', bubbles: true })));
  assert.equal(document.activeElement, panel.querySelector('button'), 'Tab wraps to first menu control.');
  await act(async () => document.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Escape', bubbles: true })));
  assert.equal(document.querySelector('.nova-menu-panel'), null);
  assert.equal(document.body.style.overflow, '');
  assert.equal(document.activeElement, trigger);
  await click(trigger);
  await click(document.querySelector('.nova-menu-scrim'));
  assert.equal(document.querySelector('.nova-menu-panel'), null, 'Backdrop closes the menu.');
  window.scrollY = 30;
  await act(async () => window.dispatchEvent(new window.Event('scroll')));
  assert.ok(document.querySelector('.nova-site-header--scrolled'));
  await act(async () => root.unmount());
  dom.window.close();
  console.log('Menu controls, scroll chrome, backdrop, Escape, focus trap and reduced-motion hook passed.');
})().catch(error => { console.error(error); process.exitCode = 1; dom.window.close(); });

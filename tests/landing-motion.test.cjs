// Mocked DOM regression for scroll reveal; no real browser, accounts or network.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { act } = React;
const { JSDOM } = require('jsdom');

const css = fs.readFileSync('app/landing-motion.css', 'utf8');
const page = fs.readFileSync('app/page.tsx', 'utf8');
assert.match(page, /<LandingMotion \/>/);
assert.match(page, /import "\.\/landing-motion\.css"/);
assert.match(css, /@media \(prefers-reduced-motion: no-preference\)/);
assert.doesNotMatch(css, /\bheight:|\bwidth:|position:\s*fixed/);

const dom = new JSDOM('<main class="landing-v2d"><div id="root"></div><div class="proof-item" id="visible"></div><div class="nova-why-item" id="below"></div><div class="social-card" id="later"></div></main>');
global.window = dom.window;
global.document = dom.window.document;
global.IS_REACT_ACT_ENVIRONMENT = true;
Object.defineProperty(window, 'innerHeight', { value: 600, configurable: true });
window.HTMLElement.prototype.getBoundingClientRect = function () { return { top: this.id === 'visible' ? 50 : 900 }; };
let reduced = false;
const listeners = new Set();
window.matchMedia = () => ({ get matches() { return reduced; }, addEventListener: (_type, fn) => listeners.add(fn), removeEventListener: (_type, fn) => listeners.delete(fn) });
const observers = [];
window.IntersectionObserver = class {
  observed = new Set();
  disconnected = false;
  constructor(callback) { this.callback = callback; observers.push(this); }
  observe(element) { this.observed.add(element); }
  unobserve(element) { this.observed.delete(element); }
  disconnect() { this.disconnected = true; this.observed.clear(); }
  notify(element) { this.callback([{ target: element, isIntersecting: true }]); }
};
const motions = [];
window.HTMLElement.prototype.animate = function (frames, options) {
  const motion = { element: this, frames, options, cancelled: false, cancel() { this.cancelled = true; }, addEventListener() {} };
  motions.push(motion);
  return motion;
};
const moduleStub = { exports: {} };
vm.runInNewContext(ts.transpileModule(fs.readFileSync('components/landing-motion.tsx', 'utf8'), {
  fileName: 'landing-motion.tsx',
  compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
}).outputText, {
  module: moduleStub, exports: moduleStub.exports,
  require: name => name === 'react' ? React : name === 'react/jsx-runtime' ? require('react/jsx-runtime') : assert.fail(name),
  document, window, IntersectionObserver: window.IntersectionObserver, Set,
});
const { createRoot } = require('react-dom/client');
const root = createRoot(document.getElementById('root'));
(async () => {
  await act(async () => root.render(React.createElement(moduleStub.exports.LandingMotion)));
  assert.deepEqual([...observers[0].observed].map(el => el.id), ['below', 'later'], 'Above-fold content stays as-is.');
  assert.equal(document.getElementById('below').style.opacity, '', 'Waiting content is never hidden by JS.');
  observers[0].notify(document.getElementById('below'));
  assert.equal(motions.length, 1);
  assert.equal(motions[0].options.duration, 480);
  assert.equal(observers[0].observed.has(document.getElementById('below')), false, 'Animate once.');
  reduced = true;
  for (const listener of listeners) listener({ matches: true });
  assert.equal(observers[0].disconnected, true);
  assert.equal(motions[0].cancelled, true);
  await act(async () => root.unmount());
  const count = observers.length;
  const reducedRoot = createRoot(document.getElementById('root'));
  await act(async () => reducedRoot.render(React.createElement(moduleStub.exports.LandingMotion)));
  assert.equal(observers.length, count, 'Reduced motion must not install an observer.');
  await act(async () => reducedRoot.unmount());
  dom.window.close();
  console.log('Landing entrance, opt-in scroll reveal and reduced-motion fallback passed.');
})().catch(error => { console.error(error); process.exitCode = 1; dom.window.close(); });

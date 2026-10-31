// Mocked DOM regression: motion accents must not slide entire sections or hide content.
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
assert.match(css, /@media \(prefers-reduced-motion: reduce\)/);
for (const effect of ['nova-timeline-draw', 'nova-icon-spring', 'nova-panel-beacon', 'nova-cover-wipe', 'nova-play-ring', 'nova-news-scan', 'nova-social-flip']) {
  assert.match(css, new RegExp(effect), `${effect} has its own animation`);
}
assert.doesNotMatch(css, /(?:^|[;{])\s*(?:height|width):|position:\s*fixed/m);

const dom = new JSDOM(`<main class="landing-v2d"><div id="root"></div>
  <div class="proof-grid"><div class="proof-item" id="visible"></div><div class="proof-item" id="proof"></div></div>
  <div class="nova-why-item" id="why"><div class="nova-why-icon"></div></div>
  <section id="find-path"><div class="nova-path-panel"></div></section>
  <section id="mag"><article class="nova-mag-article" id="mag-card"></article></section>
  <section id="podcasts"><article class="nova-mag-article" id="podcast-card"></article></section>
  <section id="konkur-news"><article class="nova-mag-article" id="news-card"></article></section>
  <section id="social"><a class="social-card" id="social-card"><span class="icon-box"></span></a></section>
</main>`);
global.window = dom.window;
global.document = dom.window.document;
global.IS_REACT_ACT_ENVIRONMENT = true;
Object.defineProperty(window, 'innerHeight', { value: 600, configurable: true });
window.HTMLElement.prototype.getBoundingClientRect = function () {
  return { top: this.id === 'visible' ? 50 : 900, bottom: this.id === 'visible' ? 100 : 1000, left: 0, width: 200, height: 100 };
};
let reduced = false;
const listeners = new Set();
window.matchMedia = query => query.includes('prefers-reduced-motion')
  ? { get matches() { return reduced; }, addEventListener: (_type, fn) => listeners.add(fn), removeEventListener: (_type, fn) => listeners.delete(fn) }
  : { matches: true };
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
let animateCalls = 0;
window.HTMLElement.prototype.animate = () => { animateCalls++; };
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
  const observer = observers[0];
  assert.equal(observer.observed.has(document.getElementById('visible')), false, 'Already-visible text is not masked on hydration.');
  const expected = ['proof', 'why', 'find-path', 'mag-card', 'podcast-card', 'news-card', 'social-card'];
  assert.deepEqual([...observer.observed].map(el => el.id), expected, 'Only section-specific accents are observed.');
  assert.equal(document.getElementById('mag-card').style.opacity, '', 'Waiting cards are never hidden.');
  for (const id of expected) {
    const element = document.getElementById(id);
    observer.notify(element);
    assert.equal(element.dataset.landingMotion, 'played');
    assert.equal(observer.observed.has(element), false, 'Each accent runs only once.');
  }
  assert.equal(animateCalls, 0, 'No generic element-level scroll translate/reveal.');
  const social = document.getElementById('social-card');
  social.dispatchEvent(new window.MouseEvent('pointermove', { bubbles: true, clientX: 50, clientY: 925 }));
  assert.equal(social.style.getPropertyValue('--motion-x'), '25%');
  assert.equal(social.style.getPropertyValue('--motion-y'), '25%');
  reduced = true;
  for (const listener of listeners) listener({ matches: true });
  assert.equal(observer.disconnected, true);
  social.dispatchEvent(new window.MouseEvent('pointermove', { bubbles: true, clientX: 100, clientY: 50 }));
  assert.equal(social.style.getPropertyValue('--motion-x'), '25%', 'Reduced motion removes pointer tracking.');
  await act(async () => root.unmount());
  const count = observers.length;
  const reducedRoot = createRoot(document.getElementById('root'));
  await act(async () => reducedRoot.render(React.createElement(moduleStub.exports.LandingMotion)));
  assert.equal(observers.length, count, 'Reduced motion does not install an observer.');
  await act(async () => reducedRoot.unmount());
  reduced = false;
  window.IntersectionObserver = undefined;
  const fallbackRoot = createRoot(document.getElementById('root'));
  await act(async () => fallbackRoot.render(React.createElement(moduleStub.exports.LandingMotion)));
  assert.equal(observers.length, count, 'Without IntersectionObserver content stays static.');
  await act(async () => fallbackRoot.unmount());
  dom.window.close();
  console.log('Seven distinct accent targets, pointer response and motion fallbacks passed.');
})().catch(error => { console.error(error); process.exitCode = 1; dom.window.close(); });

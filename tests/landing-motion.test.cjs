// Mocked DOM regression: distinct scroll reveals start only after meaningful visibility.
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
for (const effect of ['nova-proof-enter', 'nova-why-enter', 'nova-path-enter', 'nova-mag-enter', 'nova-podcast-enter', 'nova-news-enter', 'nova-social-enter', 'nova-timeline-draw', 'nova-icon-spring', 'nova-panel-beacon', 'nova-cover-wipe', 'nova-play-ring', 'nova-news-scan', 'nova-social-flip']) {
  assert.match(css, new RegExp(effect), `${effect} has its own animation`);
}
assert.doesNotMatch(css, /(?:^|[;{])\s*(?:height|width):|position:\s*fixed/m);
assert.match(css, /data-landing-motion=\"pending\"/);

const dom = new JSDOM(`<main class="landing-v2d"><div id="root"></div>
  <div class="proof-grid"><div class="proof-item" id="visible"></div><div class="proof-item" id="proof"></div></div>
  <div class="nova-why-item" id="why"><div class="nova-why-icon"></div></div>
  <section id="find-path"><div class="nova-path-panel"></div></section>
  <section id="mag" class="nova-magazine"><header class="nova-mag-header" id="mag-head"></header><article class="nova-mag-article" id="mag-card"></article></section>
  <section id="podcasts" class="nova-magazine"><header class="nova-mag-header" id="podcast-head"></header><article class="nova-mag-article" id="podcast-card"></article></section>
  <section id="konkur-news" class="nova-magazine"><header class="nova-mag-header" id="news-head"></header><article class="nova-mag-article" id="news-card"></article></section>
  <section id="social"><div class="social-head" id="social-head"></div><a class="social-card" id="social-card"><span class="icon-box"></span></a></section>
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
  constructor(callback, options) { this.callback = callback; this.options = options; observers.push(this); }
  observe(element) { this.observed.add(element); }
  unobserve(element) { this.observed.delete(element); }
  disconnect() { this.disconnected = true; this.observed.clear(); }
  notify(element, ratio = 0.15) { this.callback([{ target: element, isIntersecting: true, intersectionRatio: ratio }]); }
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
  assert.equal(observer.options.rootMargin, '0px 0px -30% 0px', 'Do not start at the bottom edge of the screen.');
  assert.deepEqual(Array.from(observer.options.threshold), [0, 0.12]);
  assert.equal(observer.observed.has(document.getElementById('visible')), false, 'Visible at hydration stays visible.');
  assert.equal(document.getElementById('visible').dataset.landingMotion, undefined);
  const expected = ['proof', 'why', 'find-path', 'mag-head', 'mag-card', 'podcast-head', 'podcast-card', 'news-head', 'news-card', 'social-head', 'social-card'];
  assert.deepEqual([...observer.observed].map(el => el.id), expected);
  assert.ok(expected.every(id => document.getElementById(id).dataset.landingMotion === 'pending'), 'Offscreen elements are explicitly armed.');
  assert.equal(document.getElementById('mag-card').style.opacity, '', 'Only CSS hides pending content; no inline styles persist.');
  const magazine = document.getElementById('mag-card');
  observer.notify(magazine, 0.02);
  assert.equal(magazine.dataset.landingMotion, 'pending', 'Do not reveal when only a sliver touches the trigger area.');
  for (const id of expected.filter(id => id !== 'social-card' && id !== 'news-card')) {
    const element = document.getElementById(id);
    observer.notify(element);
    assert.equal(element.dataset.landingMotion, 'played');
    assert.equal(observer.observed.has(element), false, 'Each reveal runs only once.');
  }
  const focusCard = document.getElementById('social-card');
  focusCard.dispatchEvent(new window.FocusEvent('focusin', { bubbles: true }));
  assert.equal(focusCard.dataset.landingMotion, 'played', 'Keyboard focus must expose an offscreen link.');
  assert.equal(observer.observed.has(focusCard), false);
  assert.equal(document.getElementById('news-card').dataset.landingMotion, 'pending');
  assert.equal(animateCalls, 0, 'No one-size-fits-all JS reveal.');
  const social = document.getElementById('social-card');
  social.dispatchEvent(new window.MouseEvent('pointermove', { bubbles: true, clientX: 50, clientY: 925 }));
  assert.equal(social.style.getPropertyValue('--motion-x'), '25%');
  assert.equal(social.style.getPropertyValue('--motion-y'), '25%');
  reduced = true;
  for (const listener of listeners) listener({ matches: true });
  assert.equal(observer.disconnected, true);
  assert.equal(document.getElementById('news-card').dataset.landingMotion, undefined, 'Preference change exposes pending content.');
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
  console.log('Distinct delayed reveals, focus access, pointer response and reduced-motion fallback passed.');
})().catch(error => { console.error(error); process.exitCode = 1; dom.window.close(); });

// Regression: the deployed reference's one-shot, no-bounce spring reveal.
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
assert.match(css, /@media \(prefers-reduced-motion: no-preference\)/);
assert.match(css, /@media \(prefers-reduced-motion: reduce\)/);
assert.match(css, /@media print/);
assert.match(css, /translateY\(22px\)/);
assert.match(css, /translateY\(-24px\)/);
assert.doesNotMatch(css, /nova-(proof-enter|cover-wipe|social-flip|news-scan|panel-beacon)/);

const dom = new JSDOM(`<main class="landing-v2d"><div id="root"></div>
  <div class="proof-grid"><div class="proof-item" id="visible" data-landing-motion="initial"></div><div class="proof-item" id="proof" data-landing-motion="initial"></div></div>
  <header class="nova-why-heading" id="why-head"></header>
  <div class="nova-why-item" id="why"><a href="#">link</a></div>
  <section id="find-path"><div class="nova-path-inner" id="path"></div></section>
  <section id="mag" class="nova-magazine"><header class="nova-mag-header" id="mag-head"></header><article class="nova-mag-article" id="mag-card"></article></section>
  <section id="podcasts" class="nova-magazine"><header class="nova-mag-header" id="podcast-head"></header><article class="nova-mag-article" id="podcast-card"></article></section>
  <section id="konkur-news" class="nova-magazine"><header class="nova-mag-header" id="news-head"></header><article class="nova-mag-article" id="news-card"></article></section>
  <section id="social"><div class="social-head" id="social-head"></div><a class="social-card" id="social-card" href="#"></a></section>
  <footer class="site-footer"><div class="footer-grid"><nav class="footer-col" id="footer-links"></nav></div><div class="footer-bottom" id="footer-bottom"></div></footer>
</main>`);
global.window = dom.window;
global.document = dom.window.document;
global.IS_REACT_ACT_ENVIRONMENT = true;
Object.defineProperty(window, 'innerHeight', { value: 600, configurable: true });
window.HTMLElement.prototype.getBoundingClientRect = function () {
  return { top: this.id === 'visible' ? 50 : 900, bottom: 1000, left: 0, width: 200, height: 100 };
};
let reduced = false;
const listeners = new Set();
window.matchMedia = () => ({ get matches() { return reduced; },
  addEventListener: (_type, fn) => listeners.add(fn), removeEventListener: (_type, fn) => listeners.delete(fn) });
const observers = [];
window.IntersectionObserver = class {
  observed = new Set();
  disconnected = false;
  constructor(callback, options) { this.callback = callback; this.options = options; observers.push(this); }
  observe(element) { this.observed.add(element); }
  unobserve(element) { this.observed.delete(element); }
  disconnect() { this.disconnected = true; this.observed.clear(); }
  notify(element, isIntersecting = true) { this.callback([{ target: element, isIntersecting }]); }
};
const animations = [];
const moduleStub = { exports: {} };
vm.runInNewContext(ts.transpileModule(fs.readFileSync('components/landing-motion.tsx', 'utf8'), {
  fileName: 'landing-motion.tsx',
  compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
}).outputText, {
  module: moduleStub, exports: moduleStub.exports,
  require: name => name === 'react' ? React : name === 'motion' ? { animate: (el, keyframes, options) => {
    const controls = { stopped: false, stop() { this.stopped = true; }, then() { return new Promise(() => {}); } };
    animations.push({ el, keyframes, options, controls });
    return controls;
  } } : assert.fail(name),
  document, window, IntersectionObserver: window.IntersectionObserver, Map,
});
const { createRoot } = require('react-dom/client');
const root = createRoot(document.getElementById('root'));
(async () => {
  await act(async () => root.render(React.createElement(moduleStub.exports.LandingMotion)));
  const observer = observers[0];
  assert.equal(observer.options.rootMargin, '0px 0px -80px 0px');
  assert.equal(observer.options.threshold, 0);
  assert.equal(observer.observed.has(document.getElementById('visible')), false, 'Visible content keeps its initial CSS entrance.');
  assert.equal(document.getElementById('visible').dataset.landingMotion, 'initial');
  const expected = ['proof', 'why-head', 'why', 'path', 'mag-head', 'mag-card', 'podcast-head', 'podcast-card', 'news-head', 'news-card', 'social-head', 'social-card', 'footer-links', 'footer-bottom'];
  assert.deepEqual([...observer.observed].map(el => el.id), expected);
  assert.ok(expected.every(id => document.getElementById(id).dataset.landingMotion === 'pending'));
  observer.notify(document.getElementById('mag-card'), false);
  assert.equal(animations.length, 0, 'Ignore non-intersections.');
  observer.notify(document.getElementById('mag-card'));
  assert.equal(animations.length, 1);
  assert.deepEqual(Array.from(animations[0].keyframes.opacity), [0, 1]);
  assert.deepEqual(Array.from(animations[0].keyframes.y), [22, 0]);
  assert.equal(animations[0].options.type, 'spring');
  assert.equal(animations[0].options.bounce, 0);
  assert.equal(animations[0].options.duration, .6);
  assert.equal(animations[0].el.dataset.landingMotion, 'animating');
  assert.equal(observer.observed.has(animations[0].el), false, 'Reveal is one-shot.');
  assert.equal(document.getElementById('podcast-card').dataset.landingDelay, '0.08');
  document.querySelector('#why a').dispatchEvent(new window.FocusEvent('focusin', { bubbles: true }));
  assert.equal(document.getElementById('why').dataset.landingMotion, 'played', 'Focus exposes a pending item.');
  reduced = true;
  for (const listener of listeners) listener({ matches: true });
  assert.equal(document.getElementById('proof').dataset.landingMotion, 'played', 'Preference change exposes pending content.');
  assert.equal(animations[0].controls.stopped, true, 'Preference change cancels running motion.');
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
  console.log('Reference reveal, stagger, focus, reduced motion and no-IO fallbacks passed.');
})().catch(error => { console.error(error); process.exitCode = 1; dom.window.close(); });

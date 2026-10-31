// Mocked DOM regression for landing motion; no real browser, accounts or network.
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
assert.match(css, /nova-star-glimmer/);
assert.doesNotMatch(css, /(?:^|[;{])\s*(?:height|width):|position:\s*fixed/m);

const dom = new JSDOM(`<main class="landing-v2d"><div id="root"></div>
  <div class="proof-grid"><div class="proof-item" id="visible"></div><div class="proof-item" id="proof-a"></div><div class="proof-item" id="proof-b"></div></div>
  <div class="nova-why-grid"><div class="nova-why-item" id="why-a"></div><div class="nova-why-item" id="why-b"></div></div>
  <section id="find-path"><div class="nova-path-panel" id="path"></div></section>
  <section class="nova-magazine"><article class="nova-mag-article" id="mag"></article></section>
  <section class="nova-magazine nova-podcasts"><article class="nova-mag-article" id="podcast"></article></section>
  <section class="nova-magazine nova-konkur-news"><article class="nova-mag-article" id="news"></article></section>
  <div class="social-grid"><a class="social-card" id="social-a"></a><a class="social-card" id="social-b"></a></div>
</main>`);
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
  const observer = observers[0];
  assert.equal(observer.observed.has(document.getElementById('visible')), false, 'Above-fold content stays as-is.');
  assert.equal(document.getElementById('why-a').style.opacity, '', 'Waiting content is never hidden by JS.');
  const play = id => {
    const element = document.getElementById(id);
    assert.equal(observer.observed.has(element), true, `${id} must be observed`);
    observer.notify(element);
    assert.equal(observer.observed.has(element), false, 'Animate once.');
    return motions.find(motion => motion.element === element);
  };
  const proofA = play('proof-a');
  const proofB = play('proof-b');
  const whyA = play('why-a');
  const whyB = play('why-b');
  const path = play('path');
  const mag = play('mag');
  const podcast = play('podcast');
  const news = play('news');
  const socialA = play('social-a');
  const socialB = play('social-b');
  assert.equal(proofA.options.duration, 460);
  assert.equal(proofB.options.delay - proofA.options.delay, 65, 'Sibling cards are staggered.');
  assert.equal(whyA.options.duration, 480);
  assert.notEqual(whyA.frames[0].transform, whyB.frames[0].transform, 'Benefits alternate directions.');
  assert.match(path.frames[0].transform, /scale/);
  assert.notEqual(mag.frames[0].transform, podcast.frames[0].transform);
  assert.notEqual(news.frames[0].transform, mag.frames[0].transform);
  assert.match(socialA.frames[0].transform, /rotate/);
  assert.notEqual(socialA.frames[0].transform, socialB.frames[0].transform);
  for (const motion of motions) {
    assert.ok(motion.frames[0].opacity >= 0.6, 'Entrance must remain partially visible.');
    assert.equal(motion.options.fill, 'backwards');
  }
  reduced = true;
  for (const listener of listeners) listener({ matches: true });
  assert.equal(observer.disconnected, true);
  assert.ok(motions.every(motion => motion.cancelled), 'Switching to reduced motion cancels every active animation.');
  await act(async () => root.unmount());
  const count = observers.length;
  const reducedRoot = createRoot(document.getElementById('root'));
  await act(async () => reducedRoot.render(React.createElement(moduleStub.exports.LandingMotion)));
  assert.equal(observers.length, count, 'Reduced motion must not install an observer.');
  await act(async () => reducedRoot.unmount());
  reduced = false;
  window.IntersectionObserver = undefined;
  const fallbackRoot = createRoot(document.getElementById('root'));
  await act(async () => fallbackRoot.render(React.createElement(moduleStub.exports.LandingMotion)));
  assert.equal(observers.length, count, 'Without IntersectionObserver content stays visible.');
  await act(async () => fallbackRoot.unmount());
  dom.window.close();
  console.log('Varied landing entrances, stagger, fallbacks and reduced-motion cleanup passed.');
})().catch(error => { console.error(error); process.exitCode = 1; dom.window.close(); });

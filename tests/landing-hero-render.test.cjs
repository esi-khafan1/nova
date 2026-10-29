// Render the real hero component to catch fallback URLs in SSR HTML, not just source text.
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { renderToString } = require('react-dom/server');

const moduleStub = { exports: {} };
vm.runInNewContext(ts.transpileModule(readFileSync('components/landing-hero.tsx', 'utf8'), {
  fileName: 'landing-hero.tsx',
  compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS },
}).outputText, {
  module: moduleStub,
  exports: moduleStub.exports,
  require(name) {
    if (name === 'react/jsx-runtime') return require('react/jsx-runtime');
    if (name === 'next/link') return { __esModule: true, default: ({ href, children }) => React.createElement('a', { href }, children) };
    throw Error(`Unexpected dependency: ${name}`);
  },
});

const html = renderToString(React.createElement(moduleStub.exports.LandingHero));
assert.match(html, /<source media="\(max-width: 700px\)" srcSet="\/nova\/hero-mobile-outpaint\.webp"/);
assert.match(html, /<img[^>]*src="\/nova\/hero-desktop\.webp"/);
assert.doesNotMatch(html, /hero-(?:desktop|mobile-outpaint)\.png/);
assert.match(html, /fetchPriority="high"/);
console.log('Landing hero SSR advertises only lightweight WebP artwork at desktop and mobile widths.');

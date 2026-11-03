const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const mod = { exports: {} };
vm.runInNewContext(ts.transpileModule(fs.readFileSync('lib/pdf-canvas.ts', 'utf8'), {
 compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
}).outputText, { module: mod, exports: mod.exports, Math, Number });
const { fitPdfScale, boundedPdfPixelRatio } = mod.exports;
assert.equal(fitPdfScale(595, 327), 295 / 595);
assert.equal(fitPdfScale(842, 327), 295 / 842, 'Landscape PDFs fit their actual page width.');
assert.equal(fitPdfScale(595, 0), 1, 'A hidden viewport never yields NaN.');
assert.ok(boundedPdfPixelRatio(1200, 2000, 4) < 2);
assert.ok(1200 * 2000 * boundedPdfPixelRatio(1200, 2000, 4) ** 2 <= 3_000_001);
const source = fs.readFileSync('components/dashboard/pdf-viewer.tsx', 'utf8');
assert.match(source, /useState<"native" \| "canvas">\("native"\)/, 'SSR/hydration must match.');
assert.match(source, /Android\|iPhone\|iPad\|iPod/);
assert.match(source, /rootMargin: "600px 0px"/);
assert.match(source, /canvas\.width = 0/);
assert.match(source, /generation !== renderGenerationRef\.current/);
assert.doesNotMatch(source, /containerWidth \/ 595/);
const css = fs.readFileSync('app/globals.css', 'utf8');
assert.match(css, /\.exam-pdf-page-canvas\{max-width:none\}/);
console.log('PDF page-size fit, bounded mobile bitmaps, lazy rendering and stable hydration passed.');

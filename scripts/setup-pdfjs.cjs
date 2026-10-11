// Keep engine, worker, CMaps and standard fonts on the same pinned PDF.js version.
const fs = require('node:fs');
const path = require('node:path');
const root = path.dirname(require.resolve('pdfjs-dist/package.json'));
const target = path.join(__dirname, '..', 'public', 'pdfjs');
fs.mkdirSync(target, { recursive: true });
for (const file of ['pdf.min.js', 'pdf.worker.min.js']) fs.copyFileSync(path.join(root, 'build', file), path.join(target, file));
for (const dir of ['cmaps', 'standard_fonts']) fs.cpSync(path.join(root, dir), path.join(target, dir), { recursive: true });

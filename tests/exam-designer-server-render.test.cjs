// Regression: the exam-designer index is a Server Component. It used to call
// `boxLabel` imported from the "use client" box-picker module. In a Next.js
// production build that import becomes a client reference which throws
// "Attempted to call boxLabel() from the server ..." -> generic 500 / digest.
process.env.TZ = "UTC";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const esbuild = require("esbuild");
const { renderToStaticMarkup } = require("react-dom/server");

const root = process.cwd();
const read = (file) => fs.readFileSync(path.join(root, file), "utf8");

// ---------------------------------------------------------------------------
// 1. Static guard: no Server Component may import a callable value from a
//    "use client" module. Components (used as <Name />) are fine, functions are
//    not, because Next.js replaces them with throwing client references.
// ---------------------------------------------------------------------------
function walk(dir, out = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (["node_modules", ".next", ".git", "public"].includes(entry.name)) continue;
    const file = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(file, out);
    else if (/\.tsx?$/.test(entry.name)) out.push(file);
  }
  return out;
}
const sourceFiles = walk(path.join(root, "app")).concat(walk(path.join(root, "components"))).concat(walk(path.join(root, "lib")));
const clientModules = new Set(
  sourceFiles
    .filter((file) => /^["']use client["']/.test(read(path.relative(root, file)).trimStart()))
    .map((file) => path.resolve(file)),
);
for (const file of sourceFiles) {
  const relative = path.relative(root, file);
  const source = read(relative);
  if (/^["']use client["']/.test(source.trimStart())) continue;
  const importRe = /import\s+([\s\S]*?)\s+from\s+["']([^"']+)["']/g;
  let match;
  while ((match = importRe.exec(source))) {
    const clause = match[1].trim();
    const spec = match[2];
    if (!spec.startsWith("@/") || /^type\b/.test(clause)) continue;
    const target = path.resolve(root, spec.slice(2));
    const candidates = [target + ".tsx", target + ".ts", target + "/index.tsx", target + "/index.ts"].map((p) => path.resolve(p));
    if (!candidates.some((candidate) => clientModules.has(candidate))) continue;
    const braces = clause.match(/\{([\s\S]*)\}/);
    const names = (braces ? braces[1] : clause).split(",")
      .map((part) => part.trim())
      .filter((part) => part && !/^type\b/.test(part))
      .map((part) => part.split(/\s+as\s+/)[0].trim());
    for (const name of names) {
      assert.ok(
        new RegExp(`<${name}\\b`).test(source),
        `${relative}: ${name} is imported from client module ${spec} but is not rendered as a component; move callable helpers to a server-safe module`,
      );
    }
  }
}

const shared = read("lib/exam-boxes.ts");
assert.doesNotMatch(shared.trimStart(), /^["']use client["']/, "exam-box helpers must stay server-safe");
assert.match(shared, /export function boxLabel/);
assert.match(shared, /export type ExamBox/);
const designerPage = read("app/dashboard/exam_designer/page.tsx");
assert.match(designerPage, /import \{ boxLabel, type ExamBox \} from "@\/lib\/exam-boxes"/);
assert.doesNotMatch(designerPage, /boxLabel[^\n]*exam-box-picker/);
const picker = read("components/dashboard/exam-box-picker.tsx");
assert.match(picker, /^"use client"/);
assert.match(picker, /from "@\/lib\/exam-boxes"/);
assert.match(designerPage, /Array\.isArray\(boxesData\)/, "boxes RPC result is guarded");
const editPage = read("app/dashboard/exam_designer/[id]/page.tsx");
assert.doesNotMatch(editPage, /throw new Error\("Exam details unavailable"\)/, "an RPC failure must not become a generic 500");
assert.match(editPage, /اطلاعات آزمون در دسترس نیست/);
assert.match(editPage, /Array\.isArray\(payload\.booklets\)/, "details payload is guarded");

// ---------------------------------------------------------------------------
// 2. Render the real Server Component with a client-reference stub for the
//    picker. If boxLabel ever comes back from the client module, rendering the
//    pending-box list throws exactly like production does.
// ---------------------------------------------------------------------------
const box = {
  item_id: "11111111-1111-4111-8111-111111111111",
  plan_id: "22222222-2222-4222-8222-222222222222",
  student_id: "33333333-3333-4333-8333-333333333333",
  student_name: "دانشآموز نمونه",
  box_date: "2026-10-27",
  day_of_week: 0,
  week_start: "2026-10-27",
  subject: "هندسه ۲",
  chapter: "فصل ۱: دایره",
  duration_minutes: 90,
  linked_exam_id: null,
  linked_exam_title: null,
  linked_exam_owned: false,
};

const stubs = {
  "next/link": `const React=require('react');function Link({href,children,...rest}){return React.createElement('a',{href,...rest},children);}module.exports=Link;module.exports.default=Link;`,
  "@/components/dashboard/dashboard-shell": `const React=require('react');function DashboardShell({children}){return React.createElement('div',{className:'shell'},children);}module.exports={DashboardShell};`,
  "@/components/dashboard/exam-builder": `function ExamBuilder(){return null;}module.exports={ExamBuilder};`,
  "@/components/dashboard/exam-box-picker": `function boxLabel(){throw new Error('Attempted to call boxLabel() from the server but boxLabel is on the client.');}function ExamBoxPicker(){return null;}module.exports={boxLabel,ExamBoxPicker};`,
  "@/lib/exams": `function formatExamSchedule(value){return String(value);}module.exports={formatExamSchedule};`,
  "@/lib/exam-save-errors": `function examSaveErrorMessage(value){return String(value);}module.exports={examSaveErrorMessage};`,
  "@/lib/auth": `const box=${JSON.stringify(box)};const supabase={from(){return {select(){return {eq(){return {order:async()=>({data:[{id:'exam-1',title:'آزمون نمونه',status:'draft',starts_at:'2026-11-01T09:00:00Z',duration_minutes:90}],error:null})};}}}};},rpc:async()=>({data:[box],error:null})};module.exports={requireProfile:async()=>({supabase,profile:{id:'designer-1',full_name:'طراح آزمون',role:'exam_designer'}})};`,
};

(async () => {
  const bundle = await esbuild.build({
    absWorkingDir: root,
    tsconfig: "tsconfig.json",
    stdin: {
      contents: `export { default as ExamDesignerPage } from './app/dashboard/exam_designer/page';`,
      resolveDir: root,
      loader: "ts",
    },
    bundle: true,
    write: false,
    outfile: "/tmp/nova-exam-designer-page.cjs",
    platform: "node",
    format: "cjs",
    target: "node22",
    jsx: "automatic",
    external: ["react", "react-dom", "react-dom/server", "react/jsx-runtime"],
    plugins: [
      {
        name: "server-render-stubs",
        setup(build) {
          build.onResolve({ filter: /^(@\/|next\/link)/ }, (args) => {
            if (!Object.hasOwn(stubs, args.path)) return undefined;
            return { path: args.path, namespace: "nova-stub" };
          });
          build.onLoad({ filter: /.*/, namespace: "nova-stub" }, (args) => ({
            contents: stubs[args.path],
            loader: "js",
            resolveDir: root,
          }));
        },
      },
    ],
  });
  const compiled = { exports: {} };
  new Function("module", "exports", "require", bundle.outputFiles[0].text)(compiled, compiled.exports, require);

  const element = await compiled.exports.ExamDesignerPage({ searchParams: Promise.resolve({}) });
  const html = renderToStaticMarkup(element);
  assert.ok(html.includes("پنل طراح آزمون"), "designer heading rendered");
  assert.ok(html.includes(box.student_name), "pending exam box rendered");
  assert.ok(html.includes(box.subject), "box subject rendered");
  assert.ok(html.includes("آبان"), "server-side boxLabel formatted the Persian date");
  assert.ok(!html.includes(box.box_date), "raw ISO date was not printed instead of the label");
  assert.ok(html.includes("آزمون نمونه"), "designer's own exams rendered");
  console.log("PASS: exam designer Server Component renders without client-reference calls");
})().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

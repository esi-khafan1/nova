const {buildSync}=require('esbuild'),fs=require('node:fs'),assert=require('node:assert/strict');
const built=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text;
const moduleObject={exports:{}};new Function('module','exports','require',built)(moduleObject,moduleObject.exports,require);const {curriculumBooks}=moduleObject.exports;
const contexts=new Set();
for(const n of ['193_planner_biology_1405_pages','194_planner_physics_1405_pages']){
 const rows=JSON.parse(fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8').split('$topics$')[1]);
 for(const row of rows)for(const track of ['konkur','final_exam']){
  const field=row.field||'experimental_sciences';const book=curriculumBooks(field,Number(row.grade),track).find(x=>x.subject===row.subject);
  assert.ok(book,`${field} ${row.grade} ${track} ${row.subject}`);assert.ok(book.chapters.includes(row.chapter),`${row.subject}: ${row.chapter}`);contexts.add(JSON.stringify([field,row.grade,track,row.subject]));
 }
}
assert.equal(contexts.size,18);console.log('PASS: all rows are selectable in 18 actual catalog contexts');

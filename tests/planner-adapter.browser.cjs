// Isolated integration of real plan-to-grid and snapshot bridge with the grid UI.
// Requires playwright-core and CHROMIUM_PATH; no database or real account.
const assert=require('node:assert/strict'),fs=require('node:fs'),esbuild=require('esbuild'),{chromium}=require('playwright-core');
(async()=>{
 const css=fs.readFileSync('components/dashboard/planner-week-grid.module.css','utf8');
 const names=[...new Set([...css.matchAll(/\.([A-Za-z][A-Za-z0-9]*)/g)].map(m=>m[1]))];
 const font=fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const code=(await esbuild.build({stdin:{contents:`import React,{useState} from 'react';import {createRoot} from 'react-dom/client';import {PlannerWeekGrid} from './components/dashboard/planner-week-grid';import {plannerGridFromPlan,plannerSnapshotFromEditor} from './lib/planner-plan-adapter';
 const item=(id,day,subject)=>({id,day_of_week:day,sort_order:0,duration_minutes:90,subject,chapter:'فصل یک',activity_type:'lesson',target_test_count:null,details:'',source_grade:10,preparation_track:'konkur',recommended_publisher:null,exam_year:null,linked_exam_id:null});
 const plan={id:'plan',student_id:'student',week_start:'2026-11-03',title:'هفته',notes:'',status:'published',weekly_plan_items:[item('today',0,'زیست'),item('future',1,'شیمی')]};
 const extras={week:{goal:'هدف'},items:{future:{topics:[{title:'گفتار یک'}],other:{keep:true}}}};const saved=JSON.stringify({plan,extras});
 function App(){const [grid,setGrid]=useState(()=>plannerGridFromPlan(plan,new Set(['today']),extras,'2026-11-03'));window.snapshot=plannerSnapshotFromEditor({title:plan.title,notes:plan.notes,weekStart:plan.week_start,today:'2026-11-03',planStatus:'published',grid,routines:Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:''})),weekExtra:extras.week});window.sourceIntact=JSON.stringify({plan,extras})===saved;return <PlannerWeekGrid weekStart={plan.week_start} grid={grid} lockedDays={Array(7).fill(false)} onChange={setGrid} onEdit={()=>{}} onAdd={()=>{}}/>};createRoot(document.getElementById('root')).render(<App/>);`,loader:'tsx',resolveDir:process.cwd()},bundle:true,format:'iife',platform:'browser',jsx:'automatic',write:false,plugins:[{name:'css',setup(b){b.onResolve({filter:/planner-week-grid\.module\.css$/},()=>({path:'css',namespace:'fake'}));b.onLoad({filter:/.*/,namespace:'fake'},()=>({loader:'js',contents:`export default ${JSON.stringify(Object.fromEntries(names.map(n=>[n,n])))};`}));}}]})).outputFiles[0].text;
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox']});
 try{for(const width of [320,390,768,1440]){
  const page=await browser.newPage({viewport:{width,height:900}});const errors=[];page.on('pageerror',e=>errors.push(e.message));
  await page.setContent(`<html lang="fa" dir="rtl"><style>@font-face{font-family:Estedad;src:url(data:font/woff2;base64,${font})}*{box-sizing:border-box}body{margin:0;padding:16px;background:#f4f8fc;font-family:Estedad,Tahoma,sans-serif}${css}</style><main id="root"></main></html>`);
  await page.addScriptTag({content:code});await page.evaluate(()=>document.fonts.ready);
  assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),true);
  const protectedBlock=page.locator('.block').filter({hasText:'زیست'});await protectedBlock.focus();await page.keyboard.press('Delete');
  assert.equal(await page.evaluate(()=>window.snapshot.items[0].sourceItemId),'today');
  const future=page.locator('.block').filter({hasText:'شیمی'});await future.focus();await page.keyboard.press('Control+d');
  await page.waitForFunction(()=>window.snapshot.items.length===3);const snapshot=await page.evaluate(()=>window.snapshot);
  assert.equal(snapshot.items[0].id,'today');assert.equal(snapshot.items[1].id,null);assert.equal(snapshot.items[1].sourceItemId,'future');
  assert.equal(snapshot.items[2].id,null);assert.equal(snapshot.items[2].sourceItemId,null);
  assert.deepEqual(snapshot.extras.items[1],{topics:[{title:'گفتار یک'}],other:{keep:true}});assert.deepEqual(snapshot.extras.items[2],snapshot.extras.items[1]);
  assert.equal(await page.evaluate(()=>window.sourceIntact),true,'published fixture remains untouched');
  await page.getByRole('button',{name:'بازگرداندن تغییر'}).click();assert.equal(await page.evaluate(()=>window.snapshot.items.length),2);
  assert.deepEqual(errors,[]);if(process.env.TEST_SCREENSHOT&&width===390)await page.screenshot({path:process.env.TEST_SCREENSHOT,fullPage:true});await page.close();
 }}finally{await browser.close()}console.log('PASS: protected published plan through grid and draft snapshot at four widths');
})().catch(error=>{console.error(error);process.exitCode=1});

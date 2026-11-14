// Browser regression using the actual isolated components and synthetic data.
// Install playwright-core separately and set CHROMIUM_PATH to Chromium.
const assert=require('node:assert/strict'),fs=require('node:fs'),esbuild=require('esbuild'),{chromium}=require('playwright-core');
(async()=>{
 const css=fs.readFileSync('components/dashboard/planner-insights.module.css','utf8');
 const names=[...new Set([...css.matchAll(/\.([A-Za-z][A-Za-z0-9]*)/g)].map(m=>m[1]))];
 const font=fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const js=(await esbuild.build({stdin:{contents:`import React,{useState} from 'react';import {createRoot} from 'react-dom/client';import {PlannerAnalysis,PlannerReviews} from './components/dashboard/planner-insights';
 const box=(key,day,subject,duration,topics=[])=>({key,dayOfWeek:day,subject,chapter:'فصل اول',activityType:'lesson',durationMinutes:duration,targetTestCount:20,details:'',topics});
 function App(){const [completed,setCompleted]=useState(new Set());const [grid,setGrid]=useState([[box('a',0,'زیست',90,[{title:'گفتار اول'}])],[box('b',1,'شیمی',60)],[],[],[],[],[]]);return <><button id="change" onClick={()=>setGrid(g=>g.map(day=>day.map(b=>({...b,durationMinutes:120}))))}>تغییر آزمایشی</button><PlannerAnalysis weekStart="2026-11-03" grid={grid}/><PlannerReviews weekStart="2026-11-03" sources={[{weekStart:'2026-11-03',blocks:grid.flat()},{weekStart:'2026-10-27',blocks:[box('old',6,'ریاضی',90)]}]} completed={completed} onToggle={(key,checked)=>setCompleted(old=>{let next=new Set(old);checked?next.add(key):next.delete(key);return next})}/></>};createRoot(document.getElementById('root')).render(<App/>);`,loader:'tsx',resolveDir:process.cwd()},bundle:true,format:'iife',platform:'browser',jsx:'automatic',write:false,plugins:[{name:'css',setup(b){b.onResolve({filter:/planner-insights\.module\.css$/},()=>({path:'css',namespace:'fake'}));b.onLoad({filter:/.*/,namespace:'fake'},()=>({loader:'js',contents:`export default ${JSON.stringify(Object.fromEntries(names.map(n=>[n,n])))};`}));}}]})).outputFiles[0].text;
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox']});
 try {for(const width of [320,390,768,1440]){const page=await browser.newPage({viewport:{width,height:1100},timezoneId:'Asia/Tehran'});let errors=[];page.on('pageerror',error=>errors.push(error.message));
 await page.setContent(`<html lang="fa" dir="rtl"><style>@font-face{font-family:Estedad;src:url(data:font/woff2;base64,${font})}*{box-sizing:border-box}body{margin:0;padding:16px;background:#f4f8fc;font-family:Estedad,Tahoma,sans-serif}main{display:grid;gap:16px}${css}</style><main id="root"></main></html>`);
 await page.addScriptTag({content:js});await page.evaluate(()=>document.fonts.ready);
 assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),true,`overflow ${width}`);
 assert.ok(await page.getByText('۲:۳۰ ساعت',{exact:true}).isVisible());assert.ok(await page.getByText('۴۰',{exact:true}).first().isVisible());
 assert.equal(await page.locator('.review input').count(),7);assert.ok(await page.getByText(/گفتار اول/).first().isVisible());
 const first=page.locator('.review input').first();await first.check();assert.equal(await first.isChecked(),true);await first.uncheck();assert.equal(await first.isChecked(),false);
 await page.locator('#change').click();assert.ok(await page.getByText('۴:۰۰ ساعت',{exact:true}).isVisible());assert.deepEqual(errors,[]);
 if(process.env.TEST_SCREENSHOT)await page.screenshot({path:`${process.env.TEST_SCREENSHOT}-${width}.png`,fullPage:true});await page.close();
 }}finally{await browser.close()}console.log('PASS: live analysis and review controls at mobile and desktop sizes');
})().catch(e=>{console.error(e);process.exitCode=1});

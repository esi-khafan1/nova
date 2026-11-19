// Real grid component with local fixture data, no database or real account.
const assert=require('node:assert/strict'),fs=require('node:fs'),esbuild=require('esbuild'),{chromium}=require('playwright-core');
(async()=>{
 const css=fs.readFileSync('components/dashboard/planner-week-grid.module.css','utf8');
 const names=[...new Set([...css.matchAll(/\.([A-Za-z][A-Za-z0-9]*)/g)].map(m=>m[1]))];
 const font=fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const code=(await esbuild.build({stdin:{contents:`import React,{useState} from 'react';import {createRoot} from 'react-dom/client';import {PlannerWeekGrid} from './components/dashboard/planner-week-grid';
 const box=(key,day,extra={})=>({key,dayOfWeek:day,id:'db-'+key,sourceItemId:'db-'+key,sourceDayOfWeek:day,extra:{topics:[{title:'گفتار یک'}]},subject:key==='b'?'شیمی':'زیست',chapter:'فصل یک',activityType:'lesson',durationMinutes:90,targetTestCount:20,details:'',...extra});
 function App(){const [grid,setGrid]=useState([[box('a',0),box('locked',0,{completed:true})],[box('b',1)],[],[],[],[],[]]);window.current=grid;window.setGrid=setGrid;return <PlannerWeekGrid weekStart="2026-11-03" grid={grid} lockedDays={[false,false,false,false,false,false,true]} onChange={setGrid} onEdit={b=>window.edited.push(b.key)} onAdd={d=>window.added.push(d)}/>};createRoot(document.getElementById('root')).render(<App/>);`,loader:'tsx',resolveDir:process.cwd()},bundle:true,format:'iife',platform:'browser',jsx:'automatic',write:false,plugins:[{name:'css-module',setup(b){b.onResolve({filter:/planner-week-grid\.module\.css$/},()=>({path:'css',namespace:'fake'}));b.onLoad({filter:/.*/,namespace:'fake'},()=>({loader:'js',contents:`export default ${JSON.stringify(Object.fromEntries(names.map(n=>[n,n])))};`}));}}]})).outputFiles[0].text;
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox']});
 try{for(const width of [320,390,768,1440]){
  const page=await browser.newPage({viewport:{width,height:900}});page.on('pageerror',e=>console.error('PAGE ERROR',e));
  await page.setContent(`<html lang="fa" dir="rtl"><head><style>@font-face{font-family:Estedad;src:url(data:font/woff2;base64,${font})}*{box-sizing:border-box}body{margin:0;font-family:Estedad,Tahoma,sans-serif;background:#f4f8fc;padding:16px}${css}</style></head><body><main id="root"></main><script>window.edited=[];window.added=[]</script></body></html>`);
  await page.addScriptTag({content:code});await page.evaluate(()=>document.fonts.ready);
  assert.equal(await page.locator('.day').count(),7);assert.ok(await page.locator('.day').first().getByText('سه‌شنبه').isVisible());
  assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`no page overflow ${width}`);
  const scroll=page.locator('.scroll');assert.equal(await scroll.evaluate(e=>e.scrollWidth>e.clientWidth),false);
  if(width>700){
   const original=await page.evaluate(()=>structuredClone(window.current));
   await page.evaluate(()=>window.setGrid(Array.from({length:7},()=>[])));
   await page.waitForFunction(()=>window.current.every(day=>day.length===0));
   const emptyHeight=await page.locator('.items').first().evaluate(e=>e.getBoundingClientRect().height);
   const emptyTableHeight=(await page.locator('.wrap').boundingBox()).height;
   assert.ok(emptyTableHeight>=660,`the entire empty desktop planner starts full height: ${emptyTableHeight}`);
   assert.ok(emptyHeight>=285,`empty desktop activity area remains tall: ${emptyHeight}`);
   await page.evaluate(initial=>window.setGrid([[initial[0][0]],[],[],[],[],[],[]]),original);
   await page.waitForFunction(()=>window.current[0].length===1);
   assert.ok(Math.abs((await page.locator('.wrap').boundingBox()).height-emptyTableHeight)<1,'adding a single activity does not change initial height');
   await page.evaluate(initial=>window.setGrid([Array.from({length:10},(_,i)=>({...initial[0][0],key:'many-'+i,subject:'درس طولانی'})),...initial.slice(1)]),original);
   await page.waitForFunction(()=>window.current[0].length===10);
   const grown=await page.locator('.items').first().evaluate(e=>({height:e.getBoundingClientRect().height,scroll:e.scrollHeight}));
   assert.ok(grown.height>emptyHeight&&grown.scroll<=grown.height+1,'content grows without clipping');
   assert.ok((await page.locator('.wrap').boundingBox()).height>emptyTableHeight,'the whole planner grows for many activities');
   assert.equal(await scroll.evaluate(e=>e.scrollHeight<=e.clientHeight+1),true,'the table does not hide activities behind a vertical scrollbar');
   await page.evaluate(initial=>window.setGrid(initial),original);await page.waitForFunction(()=>window.current[0][0].key==='a');
  }
  const a=page.locator('.block').filter({hasText:'زیست'}).first();await a.click();assert.deepEqual(await page.evaluate(()=>window.edited),['a']);
  await a.focus();await page.keyboard.press('Control+c');await page.keyboard.press('Control+d');
  await page.waitForFunction(()=>window.current[1].length===2);assert.equal((await page.evaluate(()=>window.current[1][1])).id,null);
  assert.equal((await page.evaluate(()=>window.current[1][1])).linkedExamId,null);
  assert.equal((await page.evaluate(()=>window.current[1][1])).sourceItemId,null);
  assert.equal((await page.evaluate(()=>window.current[1][1])).sourceDayOfWeek,null);
  assert.equal(await page.evaluate(()=>window.current[1][1].extra.topics[0].title),'گفتار یک');
  await page.getByRole('button',{name:'بازگرداندن تغییر'}).click();assert.equal(await page.evaluate(()=>window.current[1].length),1);
  await a.focus();await page.keyboard.press('Alt+ArrowLeft');await page.waitForFunction(()=>window.current[1].some(b=>b&&b.key==='a'));
  assert.equal(await page.evaluate(()=>window.current[1][0].id),'db-a');assert.equal(await page.evaluate(()=>window.current[1][0].sourceItemId),'db-a');assert.equal(await page.evaluate(()=>window.current[1][0].sourceDayOfWeek),0);
  await page.getByRole('button',{name:'بازگرداندن تغییر'}).click();assert.equal(await page.evaluate(()=>window.current[0][0].key),'a');
  const protectedBlock=page.locator('.block').filter({hasText:'محافظت‌شده'});await protectedBlock.focus();await page.keyboard.press('Delete');assert.equal(await page.evaluate(()=>window.current[0][1].key),'locked');
  await page.locator('.day').first().getByRole('button',{name:/گزینه‌های روز/}).click();await page.locator('.day').first().getByRole('button',{name:'کپی روز'}).click();if(width<=700)await page.getByRole('group',{name:'انتخاب روز'}).locator('button').nth(2).click();await page.locator('.day').nth(2).getByRole('button',{name:/گزینه‌های روز/}).click();await page.locator('.day').nth(2).getByRole('button',{name:'چسباندن روز'}).click();
  assert.equal(await page.evaluate(()=>window.current[2].length),2);assert.ok(await page.evaluate(()=>window.current[2].every(x=>!x.id&&!x.completed)));
  await page.getByRole('button',{name:'بازگرداندن تغییر'}).click();
  if(width>=1200){const source=page.locator('.day').nth(0).locator('.block').first(),target=page.locator('.day').nth(1).locator('.block').first();
  await source.dragTo(target);await page.waitForFunction(()=>window.current[1].some(b=>b&&b.key==='a'));assert.equal(await page.evaluate(()=>window.current[1][0].key),'a');
  await page.getByRole('button',{name:'بازگرداندن تغییر'}).click();}
  if(width<=700)await page.getByRole('group',{name:'انتخاب روز'}).locator('button').nth(0).click();if(process.env.TEST_SCREENSHOT)await page.screenshot({path:`${process.env.TEST_SCREENSHOT}-pre-${width}.png`});await page.locator('.day').nth(0).getByRole('button',{name:'گزینه‌های زیست'}).first().click();
  assert.ok(await page.getByRole('button',{name:'انتقال به روز بعد'}).isVisible());
  await page.getByRole('button',{name:'انتقال به روز بعد'}).click();assert.ok(await page.evaluate(()=>window.current[1].some(b=>b&&b.key==='a')));
  if(width<=700)await page.getByRole('group',{name:'انتخاب روز'}).locator('button').nth(6).click();assert.equal(await page.locator('.day').last().getByRole('button',{name:'+ افزودن'}).isDisabled(),true);
  if(process.env.TEST_SCREENSHOT)await page.screenshot({path:`${process.env.TEST_SCREENSHOT}-${width}.png`});
  await page.close();
 }}finally{await browser.close()}console.log('PASS: real grid visual layout, keyboard, drag, touch-accessible menu, copy, undo and locked days across viewport sizes');
})().catch(e=>{console.error(e);process.exitCode=1});

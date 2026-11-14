// Isolated rendering of the existing designer alert and real conflict copy.
// Requires playwright-core and CHROMIUM_PATH; no account or real data is used.
const assert=require('node:assert/strict'),fs=require('node:fs'),esbuild=require('esbuild'),{chromium}=require('playwright-core');
(async()=>{
 const compiled=await esbuild.build({entryPoints:['lib/exam-save-errors.ts'],bundle:true,platform:'node',format:'cjs',write:false});
 const mod={exports:{}};new Function('module','exports',compiled.outputFiles[0].text)(mod,mod.exports);
 const message=mod.exports.examSaveErrorMessage(mod.exports.examSaveErrorCode({message:'Exam boxes are being updated; try again',code:'40001'}));
 const css=fs.readFileSync('app/globals.css','utf8'),font=fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox','--disable-dev-shm-usage']});
 try{for(const width of [320,390,768,1440]){
  const page=await browser.newPage({viewport:{width,height:800}});
  await page.setContent(`<html lang="fa" dir="rtl"><style>@font-face{font-family:Estedad;src:url(data:font/woff2;base64,${font})}*{box-sizing:border-box}body{margin:0;font-family:Estedad,sans-serif}main{max-width:1000px;margin:auto;padding:16px}${css}</style><main><div class="portal-alert error"></div></main></html>`);
  await page.locator('.portal-alert').evaluate((el,text)=>el.textContent=text,message);await page.evaluate(()=>document.fonts.ready);
  const result=await page.locator('.portal-alert').evaluate(el=>({client:el.clientHeight,scroll:el.scrollHeight,width:el.getBoundingClientRect().width,color:getComputedStyle(el).color,bg:getComputedStyle(el).backgroundColor}));
  assert.ok(await page.getByText('هم‌زمان در حال تغییر است',{exact:false}).isVisible());
  assert.ok(await page.getByText('صفحه را تازه کن',{exact:false}).isVisible());
  assert.ok(result.scroll<=result.client+1,`clipped message at ${width}`);
  assert.ok(result.width<=width,`alert overflow at ${width}`);
  assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),true,`page overflow at ${width}`);
  assert.notEqual(result.color,result.bg,'message must contrast with background');
  if(process.env.TEST_SCREENSHOT&&width===320)await page.screenshot({path:process.env.TEST_SCREENSHOT});
  await page.close();
 }}finally{await browser.close()}console.log('PASS: conflict alert is visible and unclipped on four screen widths');
})().catch(error=>{console.error(error);process.exitCode=1});

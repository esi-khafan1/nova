// Requires playwright-core and a Chromium executable; no production account/data needed.
// BASE_URL=http://localhost:3000 CHROMIUM_PATH=/path/to/chromium node tests/course-card-layout.browser.cjs
const assert=require('node:assert/strict'),{chromium}=require('playwright-core');
const baseline=require('./fixtures/course-card-dimensions.json');
(async()=>{
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox','--disable-dev-shm-usage'],headless:true});
 try{for(const [section,rows] of Object.entries(baseline))for(const row of rows){
  const page=await browser.newPage({viewport:row.viewport});
  await page.goto(`${process.env.BASE_URL||'http://localhost:3000'}${section==='course'?'/courses':'/'}?grade=12&field=experimental_sciences`,{waitUntil:'networkidle'});
  await page.evaluate(()=>document.fonts.ready);
  const cards=page.getByRole('listitem').filter({has:page.locator('.course-price')});
  assert.equal(await cards.count(),8);
  for(const card of await cards.all()){
   const r=await card.boundingBox();assert.ok(Math.abs(r.width-row.width)<0.5);assert.ok(Math.abs(r.height-row.height)<0.5);
   const label=await card.locator('h2').textContent();assert.ok(['پلن پایه','پلن پیشرفت'].includes(label));
   const price=await card.locator('.course-plan-footer .course-price').boundingBox();
   const details=await card.getByRole('link',{name:'جزئیات بیشتر'}).boundingBox();
   assert.ok(price.x>=details.x+details.width,'price must be right of details link');
   const image=await card.locator('.course-plan-cover').boundingBox();
   assert.ok(price.y>=image.y+image.height,'price must be below artwork');
   const fit=await card.locator('.course-price strong').evaluate(el=>el.scrollWidth<=el.clientWidth);assert.ok(fit,'price text must fit');assert.ok(price.x>=r.x&&price.x+price.width<=r.x+r.width+0.5);
   assert.ok(price.y>=r.y&&price.y+price.height<=r.y+r.height);
  }
  assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth),false);
  await page.close();
 }}finally{await browser.close();}
 console.log('Catalog and landing: eight visible base/progress cards, unchanged pre-change dimensions, contained prices and no document overflow across eight viewports.');
})().catch(e=>{console.error(e);process.exitCode=1;});

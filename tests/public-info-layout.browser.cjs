const assert=require('node:assert/strict'),{chromium}=require('playwright-core');
(async()=>{const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH||'/tmp/chromium',args:['--no-sandbox','--disable-dev-shm-usage']});try{for(const width of [320,390,708,1440]){
 const page=await browser.newPage({viewport:{width,height:1000}});
 for(const route of ['/contact','/faq','/about']){
  const response=await page.goto((process.env.BASE_URL||'http://localhost:3002')+route);assert.equal(response.status(),200);
  await page.locator('.nova-header-brand img').waitFor();assert.equal(await page.locator('.nova-site-header').count(),1);assert.equal(await page.locator('h1').count(),1);
  assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth),false,`${route}/${width} overflow`);
  assert.equal(await page.locator('.legal-card').evaluate(n=>getComputedStyle(n).backgroundColor),'rgb(255, 255, 255)');
  assert.equal(await page.locator('.nova-info-page').evaluate(n=>getComputedStyle(n).backgroundColor),'rgb(245, 250, 255)');
  await page.getByRole('button',{name:'باز کردن منو',exact:true}).click();await page.getByRole('dialog',{name:'نوا، همراه مسیر تو'}).waitFor();await page.keyboard.press('Escape');
 }
 await page.close();
}console.log('Contact/FAQ/About: real production pages, current header/menu + white/ice theme, no horizontal overflow at 320/390/708/1440px.');}finally{await browser.close();}})().catch(e=>{console.error(e);process.exitCode=1;});

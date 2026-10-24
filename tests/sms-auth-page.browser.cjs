const assert=require('node:assert/strict');
const {chromium}=require('playwright-core');
(async()=>{const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox','--disable-dev-shm-usage']});try{
const page=await browser.newPage();let sends=0,checks=0;
await page.route('**/auth/v1/**',async route=>{const body=route.request().postDataJSON();assert.equal(body.phone,'989120000000');if(route.request().url().endsWith('/otp')){sends++;assert.equal(body.create_user,true);await route.fulfill({json:{}});}else{checks++;assert.equal(body.type,'sms');assert.equal(body.token,'123456');await route.fulfill({json:{user:{phone_confirmed_at:'2026-01-01'},access_token:'mock-never-persisted'}});}});
await page.goto('file://'+require('node:path').resolve('tools/sms-auth-test.html'));assert.equal(sends,0);
page.on('dialog',d=>d.accept());await page.locator('#phone').fill('09120000000');await page.locator('#send').click();await page.locator('#otp:not([disabled])').waitFor();assert.equal(sends,1);assert.equal(await page.locator('#send').isDisabled(),true);
await page.locator('#otp').fill('123456');await page.locator('#check').click();await page.getByText('تأیید واقعی شماره در Supabase موفق بود',{exact:false}).waitFor();assert.equal(checks,1);assert.equal(await page.locator('#otp').inputValue(),'');
console.log('SMS page mocked browser: zero automatic sends, explicit single request, code verification and OTP clearing passed.');
}finally{await browser.close();}})().catch(e=>{console.error(e);process.exitCode=1;});

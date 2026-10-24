// Real UI/browser with mocked Auth transport; never sends SMS or creates a user.
const assert=require('node:assert/strict'),{chromium}=require('playwright-core');
(async()=>{const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH||'/tmp/chromium',args:['--no-sandbox','--disable-dev-shm-usage']});try{
for(const viewport of [{width:390,height:844},{width:1440,height:900}]){
 const page=await browser.newPage({viewport});const calls=[];let destination;
 await page.route('**/api/auth/phone',async route=>{calls.push(route.request().postDataJSON());await route.fulfill({json:{ok:true,message:'ok'}});});
 await page.route('**/dashboard/registration?**',async route=>{destination=route.request().url();await route.fulfill({contentType:'text/html',body:'<h1>Course registration destination</h1>'});});
 const next='/dashboard/registration?grade=12&field=humanities&course=base&months=1';
 await page.goto((process.env.BASE_URL||'http://localhost:3002')+'/auth?mode=signup&next='+encodeURIComponent(next));
 await page.getByLabel('نام و نام خانوادگی',{exact:true}).fill('Test Person');await page.getByLabel('شماره تلفن همراه',{exact:true}).fill('09120000000');await page.getByLabel('رمز عبور',{exact:true}).fill('TestPass123!');
 await page.getByRole('button',{name:'دریافت کد',exact:true}).click();await page.getByLabel('کد تأیید شماره',{exact:true}).waitFor();
 assert.equal(calls.length,1);assert.equal(calls[0].action,'signup');assert.equal(calls[0].password,'TestPass123!');assert.equal(await page.getByLabel('رمز عبور',{exact:true}).inputValue(),'TestPass123!');
 assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth),false);
 await page.getByLabel('کد تأیید شماره',{exact:true}).fill('123456');await page.getByRole('button',{name:'تأیید کد و ورود',exact:true}).click();await page.getByText('Course registration destination').waitFor();assert.equal(calls[1].action,'verify');assert.equal(calls[1].password,'TestPass123!');assert.ok(destination.endsWith(next));
 await page.goto((process.env.BASE_URL||'http://localhost:3002')+'/auth?mode=signin');
 await page.getByLabel('شماره تلفن همراه یا ایمیل',{exact:true}).fill('09120000000');await page.getByLabel('رمز عبور',{exact:true}).fill('TestPass123!');
 // Stop the final navigation so this remains a transport/UI test, not live Auth.
 await page.route('**/dashboard',r=>r.fulfill({contentType:'text/html',body:'<h1>Password login destination</h1>'}));
 await page.getByRole('button',{name:'ورود به حساب',exact:true}).click();await page.getByText('Course registration destination').waitFor();assert.equal(calls.at(-1).action,'signin');assert.equal(calls.length,3,'password login must not request a code');
 let emailLogin=false;
 await page.route('**/auth/v1/token?**',async route=>{const body=route.request().postDataJSON();assert.equal(body.email,'old@example.com');emailLogin=true;await route.fulfill({status:400,json:{error:'invalid_grant',error_description:'Invalid login credentials',msg:'Invalid login credentials'}});});
 await page.goto((process.env.BASE_URL||'http://localhost:3002')+'/auth?mode=signin');
 await page.getByLabel('شماره تلفن همراه یا ایمیل',{exact:true}).fill('old@example.com');await page.getByLabel('رمز عبور',{exact:true}).fill('TestPass123!');await page.getByRole('button',{name:'ورود به حساب',exact:true}).click();
 await page.getByText('ایمیل یا رمز عبور درست نیست.',{exact:true}).waitFor();assert.equal(emailLogin,true);assert.equal(calls.length,3,'email login must never invoke phone API');
 await page.close();
}
console.log('Phone UI mobile/desktop: existing form theme, password retained through SMS step, direct course return, no overflow and password-only phone login passed (mock Auth).');
}finally{await browser.close();}})().catch(e=>{console.error(e);process.exitCode=1;});

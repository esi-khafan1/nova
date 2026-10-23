// Local UI/SDK test with mocked HTTP and Phoenix WebSocket transport, no production messages.
const assert=require('node:assert/strict'),{chromium}=require('playwright-core');
(async()=>{const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox','--disable-dev-shm-usage'],headless:true});
try{for(const viewport of [{width:390,height:844},{width:1440,height:900}]){
const page=await browser.newPage({viewport});let messages=[],socket=null,topic=null,array=false,joins=0,closed=0,reads=0;
await page.route('**/api/support?**',async route=>{if(route.request().method()==='POST')messages.push({id:1,sender:'visitor',body:route.request().postDataJSON().message,created_at:new Date().toISOString()});else reads++;await route.fulfill({json:{realtime_topic:'nova-support:11111111-1111-4111-a111-111111111111',messages}});});
await page.routeWebSocket(/supabase.co\/realtime\//,ws=>{socket=ws;ws.onClose(()=>closed++);ws.onMessage(raw=>{const m=JSON.parse(raw);array=Array.isArray(m);const event=array?m[3]:m.event,ref=array?m[1]:m.ref,t=array?m[2]:m.topic,j=array?m[0]:m.join_ref;if(event==='phx_join'){topic=t;joins++;}if(['phx_join','phx_leave','heartbeat'].includes(event)){const payload={status:'ok',response:{}};ws.send(JSON.stringify(array?[j,ref,t,'phx_reply',payload]:{join_ref:j,ref,topic:t,event:'phx_reply',payload}));}});});
await page.goto((process.env.BASE_URL||'http://localhost:3000')+'/courses?grade=12&field=experimental_sciences',{waitUntil:'networkidle'});
assert.equal(joins,0,'closed widget must not create realtime subscriptions');
await page.getByRole('button',{name:'گفت‌وگو با پشتیبانی',exact:true}).click();await page.getByText('ارتباط زنده برقرار است.',{exact:true}).waitFor();assert.equal(joins,1);
const box=await page.getByRole('dialog').boundingBox();assert.ok(box.x>=0&&box.x+box.width<=viewport.width);
await page.getByLabel('پیام شما',{exact:true}).fill('پیام آزمایشی مهمان');await page.getByRole('button',{name:'ارسال پیام',exact:true}).click();await page.getByText('پیام آزمایشی مهمان',{exact:true}).waitFor();
messages.push({id:2,sender:'support',body:'پاسخ زنده پشتیبانی',created_at:new Date().toISOString()});const payload={type:'broadcast',event:'changed',payload:{changed:true}};socket.send(JSON.stringify(array?[null,null,topic,'broadcast',payload]:{topic,event:'broadcast',payload,ref:null}));
await page.getByText('پاسخ زنده پشتیبانی',{exact:true}).waitFor({timeout:5000});assert.ok(await page.getByRole('log').getByText('پشتیبانی نووا',{exact:true}).count());
const current=reads;await page.waitForTimeout(3500);assert.equal(reads,current,'no three-second polling when connected');
await page.getByRole('button',{name:'بستن پشتیبانی',exact:true}).click();await page.waitForTimeout(1000);assert.ok(closed>0,'closing last chat should release its websocket');assert.equal(await page.getByRole('dialog').count(),0);
await page.close();
}}finally{await browser.close();}console.log('Actual browser/SDK: no idle subscription, live Broadcast delivery without polling/refresh, responsive popup, anonymous support label and socket cleanup passed.');})().catch(e=>{console.error(e);process.exitCode=1;});

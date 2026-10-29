import assert from 'node:assert/strict';
import {createHandler} from '../supabase/functions/send-sms/handler.mjs';
let sends=0,claims=0;const used=new Set();
const values={SMS_TEST_ENABLED:'true',SMS_TEST_PHONE:'09120000000',SEND_SMS_HOOK_SECRET:'test',MELIPAYAMAK_USERNAME:'test',MELIPAYAMAK_API_KEY:'test'};
let payload={user:{phone:'+989120000000'},sms:{otp:'123456'}};
const handler=createHandler({env:n=>values[n],verify:async(raw,h)=>{if(h['webhook-signature']!=='valid')throw Error();return JSON.parse(raw);},claim:async id=>{claims++;if(used.has(id)||used.size>=5)return false;used.add(id);return true;},fetcher:async(url,options)=>{sends++;assert.equal(url,'https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber');assert.equal(options.body.get('bodyId'),'566954');assert.equal(options.body.get('password'),'test');assert.equal(options.body.get('to'),'09120000000');return new Response('{"Value":123456789012345678,"RetStatus":1}');}});
const req=(id='one',signature='valid')=>new Request('https://example.test',{method:'POST',headers:{'webhook-id':id,'webhook-signature':signature},body:JSON.stringify(payload)});
assert.equal((await handler(req('bad','invalid'))).status,401);assert.equal(claims,0);
payload.user.phone='+989130000000';assert.equal((await handler(req())).status,403);assert.equal(claims,0);
payload.user.phone='+989120000000';assert.equal((await handler(req())).status,200);assert.equal((await handler(req())).status,429);assert.equal(sends,1);
values.SMS_TEST_ENABLED='false';assert.equal((await handler(req('two'))).status,503);assert.equal(sends,1);
console.log('SMS hook: disabled by default, signature gate, allowlist, duplicate rejection, fixed template and HTTPS provider request passed (mock transport).');
const diagnostics=[];
for(const [response,expected,code] of [
 [()=>new Response('{"Value":0,"RetStatus":1}'),'provider_rejected',0],
 [()=>new Response('{"Value":"-111"}'),'provider_rejected',-111],
 [()=>new Response('private provider text'),'unrecognized_response',null],
 [()=>new Response('no',{status:503}),'http_error',503],
 [()=>{throw new DOMException('private URL or credential','TimeoutError');},'timeout',null],
 [()=>{throw new TypeError('private URL or credential');},'network_error',null],
 [()=>new Response('{"Value":"123456789012345678"}'),'accepted',null]
]){
 values.SMS_TEST_ENABLED='true';
 const isolated=createHandler({env:n=>values[n],verify:async()=>payload,claim:async()=>true,report:async(...args)=>diagnostics.push(args),fetcher:async()=>response()});
 const result=await isolated(req('safe-event'));assert.equal(result.status,expected==='accepted'?200:502);
 const last=diagnostics.at(-1);assert.equal(last[1],expected);assert.equal(last[2],code);assert.ok(last[3]>=0);assert.ok(!JSON.stringify(last).includes('123456'));
 assert.ok(!(await result.text()).includes('private URL'));
}
console.log('SMS safe diagnostics: auth/IP rejection codes, HTTP errors, unknown payloads, timeout/network ambiguity and accepted recId passed. No automatic retry.');
// Linked-account codes must target sms.phone/phone_change, not the old contact.
values.SMS_SIGNUP_ENABLED='true';values.SMS_TEST_ENABLED='false';
let claimedPhone;
const publicHook=createHandler({env:n=>values[n],verify:async()=>({user:{phone:'989130000000'},sms:{phone:'+989120000000',otp:'123456'}}),claim:async(id,phone)=>{claimedPhone=phone;return true;},fetcher:async(url,options)=>{assert.equal(options.body.get('to'),'09120000000');return new Response('{"Value":"123456789012345678"}');}});
assert.equal((await publicHook(req('new-public'))).status,200);assert.equal(claimedPhone,'989120000000');
console.log('Public hook: explicit release gate, shared claim budget and linked-account destination priority passed.');

// A provider can deliver an OTP and only acknowledge after GoTrue's hook
// deadline. Returning an early hook response preserves the unconfirmed user;
// the one claimed send continues in EdgeRuntime.waitUntil, without a retry.
let completeProvider, background, slowSends=0;
const slowOutcomes=[];
const slowHook=createHandler({env:n=>values[n],verify:async()=>payload,claim:async()=>true,
 ackWindowMs:1,waitUntil:promise=>{background=promise;},
 report:async(...args)=>slowOutcomes.push(args),
 fetcher:async()=>{slowSends++;return await new Promise(resolve=>{completeProvider=resolve;});}
});
const early=await slowHook(req('slow-public'));
assert.equal(early.status,200);
assert.equal(slowSends,1);
assert.ok(background,'in-flight provider request must stay alive after the hook response');
completeProvider(new Response('{"Value":"123456789012345678"}'));
assert.equal((await background).status,200);
assert.equal(slowOutcomes.at(-1)[1],'accepted');
assert.equal(slowSends,1,'never send twice after an ambiguous response');

let rejectProvider, rejectedBackground;
const lateRejectOutcomes=[];
const lateReject=createHandler({env:n=>values[n],verify:async()=>payload,claim:async()=>true,
 ackWindowMs:1,waitUntil:promise=>{rejectedBackground=promise;},
 report:async(...args)=>lateRejectOutcomes.push(args),
 fetcher:async()=>await new Promise(resolve=>{rejectProvider=resolve;})});
assert.equal((await lateReject(req('late-reject'))).status,200);
rejectProvider(new Response('{"Value":0}'));
assert.equal((await rejectedBackground).status,502);
assert.equal(lateRejectOutcomes.at(-1)[1],'provider_rejected');

const quickOutcomes=[];
let quickBackground=false;
const quickReject=createHandler({env:n=>values[n],verify:async()=>payload,claim:async()=>true,
 ackWindowMs:100,waitUntil:()=>{quickBackground=true;},
 report:async(...args)=>quickOutcomes.push(args),fetcher:async()=>new Response('{"Value":0}')});
assert.equal((await quickReject(req('reject-public'))).status,502);
assert.equal(quickBackground,false,'known rejections must still fail closed');
assert.equal(quickOutcomes.at(-1)[1],'provider_rejected');
console.log('Slow provider acknowledgments preserve signup and record the eventual outcome; fast rejections still fail closed.');

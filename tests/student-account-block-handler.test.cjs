const assert = require('node:assert/strict');
const target = '00000000-0000-4000-8000-000000000001';
const operation = '00000000-0000-4000-8000-000000000002';
(async () => {
  const {makeStudentAccountBlockHandler} = await import('../supabase/experimental/student-account-block-handler.mjs');
  const requests = [];
  const deps = {
    verifyUser: async auth => { requests.push(['verify', auth]); return {id: target}; },
    begin: async (...args) => { requests.push(['begin', ...args]); return true; },
    setAuthBan: async (...args) => { requests.push(['auth', ...args]); },
    finish: async (...args) => { requests.push(['finish', ...args]); },
    randomUUID: () => operation,
  };
  const request = (body = {target_id: target, blocked: true}, authorization = 'Bearer valid') =>
    new Request('https://example.test/', {method:'POST',headers:{authorization},body:JSON.stringify(body)});
  const call = overrides => makeStudentAccountBlockHandler({...deps,...overrides});
  let result = await call()(request());
  assert.equal(result.status, 200);
  assert.deepEqual(requests.map(x=>x[0]), ['verify','begin','auth','finish']);
  assert.deepEqual(requests[1], ['begin','Bearer valid',target,true,operation]);
  assert.deepEqual(requests[3], ['finish',operation,true]);
  requests.length = 0;
  assert.equal((await call()(request({target_id:target,blocked:'true'}))).status, 400);
  assert.equal((await call()(request({target_id:'bad',blocked:true}))).status, 400);
  assert.equal((await call()(request(undefined, ''))).status, 401);
  assert.equal((await call()(request({target_id:target,blocked:true,extra:'x'.repeat(3000)}))).status, 413);
  assert.deepEqual(requests, []);
  result = await call({verifyUser:async()=>null})(request());
  assert.equal(result.status,401);
  result = await call({begin:async()=>false})(request());
  assert.equal(result.status,409);
  assert.equal(requests.some(x=>x[0]==='auth'),false);
  requests.length = 0;
  result = await call({setAuthBan:async()=>{throw Error('timeout')}})(request({target_id:target,blocked:false}));
  assert.equal(result.status,503);
  assert.deepEqual(requests.at(-1), ['finish',operation,false]);
  requests.length = 0;
  result = await call({finish:async()=>{throw Error('db failure')}})(request());
  assert.equal(result.status,503);
  assert.deepEqual(await result.json(),{error:'uncertain'});
  console.log('PASS: experimental block handler: auth, validation, operation ordering and fail-closed errors');
})().catch(error=>{console.error(error);process.exitCode=1});

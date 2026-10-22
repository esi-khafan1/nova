const assert = require('node:assert/strict'), fs = require('node:fs'), vm = require('node:vm'), ts = require('typescript');
let scenario, signatures = 0;
const m = { exports: {} };
vm.runInNewContext(ts.transpileModule(fs.readFileSync('app/api/imagekit-auth/route.ts', 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 } }).outputText, { module: m, exports: m.exports, Response, process: { env: { IMAGEKIT_PUBLIC_KEY: 'test-public', IMAGEKIT_PRIVATE_KEY: 'test-private' } }, require(name) {
        if (name === '@imagekit/next/server')
            return { getUploadAuthParams: () => { signatures++; return { token: 'test-token' }; } };
        if (name === '@/lib/supabase/server')
            return { createClient: async () => ({
                    auth: { getUser: async () => { scenario.started.add('auth'); scenario.notify(); await scenario.gate; return { data: { user: scenario.user } }; } },
                    rpc: name => { assert.equal(name, 'own_dashboard_profile'); return { maybeSingle: async () => { scenario.started.add('profile'); scenario.notify(); await scenario.gate; return { data: scenario.profile }; } }; },
                    from: table => ({ select() { return this; }, eq() { return this; }, single: async () => { assert.equal(table, 'counselor_profiles'); return { data: { approval_status: scenario.approved ? 'approved' : 'pending' } }; }, then(resolve, reject) { assert.equal(table, 'counselor_students'); return Promise.resolve({ count: scenario.assigned ? 1 : 0 }).then(resolve, reject); } }),
                }) };
        throw Error(name);
    } });
async function check({ role, purpose, status, anonymous = false, mismatch = false, approved = false, assigned = false }) {
    let release;
    scenario = { user: anonymous ? null : { id: 'own' }, profile: { id: mismatch ? 'other' : 'own', role }, approved, assigned, started: new Set(), gate: new Promise(resolve => { release = resolve; }) };
    scenario.notify = () => { if (scenario.started.size === 2)
        release(); };
    let timer;
    const before = signatures;
    try {
        const response = await Promise.race([m.exports.GET({ nextUrl: new URL('https://nova-academy.ir/api/imagekit-auth?purpose=' + purpose) }), new Promise((_, reject) => { timer = setTimeout(() => reject(Error('Upload auth/profile must run concurrently')), 1000); })]);
        assert.equal(response.status, status);
        assert.equal(signatures - before, status === 200 ? 1 : 0);
    }
    finally {
        clearTimeout(timer);
    }
}
(async () => {
    await check({ role: 'content_manager', purpose: 'content', status: 200 });
    await check({ role: 'content_manager', purpose: 'podcast-audio', status: 200 });
    await check({ role: 'content_manager', purpose: 'exam-answer', status: 403 });
    await check({ role: 'admin', purpose: 'content', status: 403 });
    await check({ role: 'content_manager', purpose: 'content', status: 401, anonymous: true });
    await check({ role: 'content_manager', purpose: 'content', status: 403, mismatch: true });
    await check({ role: 'counselor', purpose: 'content', status: 403 });
    await check({ role: 'counselor', purpose: 'content', status: 200, approved: true });
    await check({ role: 'exam_designer', purpose: 'exam-question', status: 200 });
    await check({ role: 'exam_designer', purpose: 'content', status: 403 });
    await check({ role: 'student', purpose: 'exam-answer', status: 403 });
    await check({ role: 'student', purpose: 'exam-answer', status: 200, assigned: true });
    console.log('Upload authorization: actual route parallel reads, verified identity match, role/purpose/approval/assignment guards and no signature on denial passed.');
})().catch(e => { console.error(e); process.exitCode = 1; });

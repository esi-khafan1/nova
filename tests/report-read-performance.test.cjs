const assert = require('node:assert/strict'), fs = require('node:fs'), vm = require('node:vm'), ts = require('typescript');
function load(path, deps) { const m = { exports: {} }; vm.runInNewContext(ts.transpileModule(fs.readFileSync(path, 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 } }).outputText, { module: m, exports: m.exports, require(name) { if (!(name in deps))
        throw Error(name); return deps[name]; } }); return m.exports; }
const pagination = load('lib/collect-query-pages.ts', {});
const counselor = load('lib/load-counselor-plans.ts', { '@/lib/collect-query-pages': pagination });
const reports = load('lib/load-study-report.ts', { '@/lib/collect-query-pages': pagination });
(async () => {
    let release;
    const started = new Set();
    const both = new Promise(resolve => { release = resolve; });
    let fail = false;
    const client = { from(table) {
            return { select() { return this; }, eq(key, value) { if (key === 'student_id')
                    assert.equal(value, 'own-student'); if (key === 'status')
                    assert.equal(value, 'published'); return this; }, order() { return this; }, range: async (from, to) => {
                    started.add(table);
                    if (started.size === 2)
                        release();
                    await both;
                    if (fail && table === 'weekly_plan_item_completions' && from >= 500)
                        return { data: null, error: { message: 'unavailable' } };
                    const total = table === 'weekly_plans' ? 201 : 501;
                    return { data: Array.from({ length: Math.max(0, Math.min(to + 1, total) - from) }, (_, i) => ({ id: from + i })), error: null };
                } };
        } };
    let timer;
    try {
        const data = await Promise.race([reports.loadStudyReport(client, 'own-student'), new Promise((_, reject) => { timer = setTimeout(() => reject(Error('Plan and completion reads must overlap')), 1000); })]);
        assert.equal(data.plans.length, 201);
        assert.equal(data.completions.length, 501);
    }
    finally {
        clearTimeout(timer);
    }
    fail = true;
    await assert.rejects(() => reports.loadStudyReport(client, 'own-student'), /Study reports unavailable/);
    const invalid = await pagination.collectQueryPages(200, async () => ({ data: [], error: null }), 'unavailable');
    assert.equal(invalid.length, 0);
    let failCounselor = false;
    const counselorClient = { from(table) {
        assert.equal(table, 'weekly_plans');
        return { select() { return this; }, order() { return this; },
            eq(key, value) { assert.equal(key, 'counselor_id'); assert.equal(value, 'own-counselor'); return this; },
            range: async (from, to) => failCounselor && from >= 200
                ? {data:null,error:{message:'unavailable'}}
                : {data:Array.from({length:Math.max(0,Math.min(to+1,201)-from)},(_,i)=>({id:from+i})),error:null},
        };
    }};
    assert.equal((await counselor.loadCounselorPlans(counselorClient,'own-counselor')).length,201);
    failCounselor = true;
    await assert.rejects(()=>counselor.loadCounselorPlans(counselorClient,'own-counselor'),/Counselor plans unavailable/);
    console.log('Report reads overlap, retain every plan/completion page and fail closed on incomplete history.');
})().catch(e => { console.error(e); process.exitCode = 1; });

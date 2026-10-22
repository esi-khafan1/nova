// node --conditions=react-server tests/shared-read-performance.test.cjs
const assert = require('node:assert/strict'), fs = require('node:fs'), vm = require('node:vm'), ts = require('typescript'), React = require('react');
const { AsyncLocalStorage } = require('node:async_hooks');
const requests = new AsyncLocalStorage();
const internals = React.__SERVER_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE;
assert.ok(internals, 'Run with --conditions=react-server');
const previous = internals.A;
internals.A = { getCacheForType(factory) { const req = requests.getStore(); if (!req.roots.has(factory))
        req.roots.set(factory, factory()); return req.roots.get(factory); } };
function load(path, deps, tail = "") { const m = { exports: {} }; vm.runInNewContext(ts.transpileModule(fs.readFileSync(path, 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, jsx: ts.JsxEmit.ReactJSX }, fileName: path }).outputText + tail, { module: m, exports: m.exports, process: { env: { NEXT_PUBLIC_SUPABASE_URL: 'https://test.supabase.co', NEXT_PUBLIC_SUPABASE_ANON_KEY: 'test' } }, require(name) { if (!(name in deps))
        throw Error(name); return deps[name]; } }); return m.exports; }
const server = load('lib/supabase/server.ts', {
    react: React, 'next/headers': { cookies: async () => { const req = requests.getStore(); req.cookieReads++; return { getAll: () => [{ name: 'test', value: req.actor }], set: () => { } }; } },
    '@supabase/ssr': { createServerClient: (_url, _key, options) => {
            const req = requests.getStore();
            req.clients++;
            return { actor: options.cookies.getAll()[0].value, from(table) {
                    const query = { select() { return this; }, eq(field, value) { (this.filters ??= {})[field] = value; return this; }, order() { return this; }, limit(n) { this.max = n; return this; }, single() { return this.maybeSingle(); }, maybeSingle: async () => { req.reads++; assert.equal(query.filters.status, 'published'); if (req.articleGate) {
                            req.operations.add('article');
                            req.notify();
                            await req.articleGate;
                        } return { data: req.visible ? { id: query.filters.id, title: table } : null }; }, then(resolve, reject) { req.reads++; assert.equal(query.filters.status, 'published'); return Promise.resolve({ data: req.visible ? [{ id: table }] : [], error: null }).then(resolve, reject); } };
                    return query;
                }, rpc: async (name, args) => { assert.equal(name, 'published_article_author'); assert.ok(args.target_resource_id); req.reads++; req.operations.add('author'); req.notify(); await req.articleGate; return { data: req.visible ? [{ full_name: 'Actual Author' }] : [] }; } };
        } },
});
const news = load('lib/news.ts', { react: React, '@/lib/supabase/server': server });
const podcasts = load('lib/podcasts.ts', { react: React, '@/lib/supabase/server': server });
const article = load('app/mag/[id]/page.tsx', {
    react: React, 'react/jsx-runtime': require('react/jsx-runtime'), 'next/link': {}, 'next/navigation': { notFound() { throw Error('not found'); } },
    '@/components/content/rich-content': {}, '@/lib/content': {}, '@/lib/supabase/server': server,
}, '\nmodule.exports.readArticle=getArticle;');
const fixture = (actor, visible = true) => ({ actor, visible, roots: new Map(), clients: 0, cookieReads: 0, reads: 0 });
(async () => {
    const id = '11111111-1111-1111-1111-111111111111';
    const a = fixture('alice'), b = fixture('bob');
    await Promise.all([a, b].map(req => requests.run(req, async () => {
        const clients = await Promise.all([server.createClient(), server.createClient()]);
        assert.equal(clients[0], clients[1]);
        assert.equal(clients[0].actor, req.actor);
        const results = await Promise.all([news.getPublishedNewsItem(id), news.getPublishedNewsItem(id), podcasts.getPublishedPodcast(id), podcasts.getPublishedPodcast(id), news.getPublishedNews(3), news.getPublishedNews(3), podcasts.getPublishedPodcasts(3), podcasts.getPublishedPodcasts(3)]);
        assert.equal(results[0], results[1]);
        assert.equal(results[2], results[3]);
        assert.equal(req.reads, 4);
        assert.equal(req.clients, 1);
        assert.equal(req.cookieReads, 1);
        await news.getPublishedNews();
        assert.equal(req.reads, 5, 'full archive must not reuse the 3-item listing');
        assert.equal(await news.getPublishedNewsItem('invalid'), null);
        assert.equal(await podcasts.getPublishedPodcast('invalid'), null);
        assert.equal(req.reads, 5);
    })));
    const next = fixture('alice', false);
    await requests.run(next, async () => {
        assert.equal(await news.getPublishedNewsItem(id), null);
        assert.equal(await podcasts.getPublishedPodcast(id), null);
        assert.equal(next.reads, 2, 'archived content must be re-read in the next request');
    });
    const mag = fixture('reader');
    mag.operations = new Set();
    let release;
    mag.articleGate = new Promise(resolve => { release = resolve; });
    mag.notify = () => { if (mag.operations.size === 2)
        release(); };
    await requests.run(mag, async () => {
        let timer;
        try {
            const [one, two] = await Promise.race([Promise.all([article.readArticle(id), article.readArticle(id)]), new Promise((_, reject) => { timer = setTimeout(() => reject(Error('Article and author must start concurrently')), 1000); })]);
            assert.equal(one, two);
            assert.equal(one.author.full_name, 'Actual Author');
            assert.equal(mag.reads, 2);
            assert.equal(await article.readArticle('invalid'), null);
            assert.equal(mag.reads, 2);
        }
        finally {
            clearTimeout(timer);
        }
    });
    assert.notEqual(a.roots, b.roots);
    console.log('Shared read tests passed: request-scoped clients, same-render metadata/detail dedupe, distinct limits, cross-user isolation and fresh archive visibility.');
})().catch(e => { console.error(e); process.exitCode = 1; }).finally(() => { internals.A = previous; });

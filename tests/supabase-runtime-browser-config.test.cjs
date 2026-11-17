const assert = require('node:assert/strict');
const esbuild = require('esbuild');
const { JSDOM } = require('jsdom');
const React = require('react');
const { renderToStaticMarkup } = require('react-dom/server');

async function load(entry, options = {}) {
  const result = await esbuild.build({
    entryPoints: [entry], platform: 'node', format: 'cjs', bundle: true, write: false, jsx: 'automatic',
    tsconfig: 'tsconfig.json', external: ['react', 'react-dom'], ...options,
  });
  const loaded = { exports: {} };
  new Function('require', 'module', 'exports', result.outputFiles[0].text)(require, loaded, loaded.exports);
  return loaded.exports;
}

(async () => {
  const config = await load('lib/supabase/public-browser-config.ts');
  const jwt = role => `header.${Buffer.from(JSON.stringify({ role })).toString('base64url')}.signature`;
  const env = { NEXT_PUBLIC_SUPABASE_URL: 'https://example.supabase.co', NEXT_PUBLIC_SUPABASE_ANON_KEY: jwt('anon') };
  assert.deepEqual(config.getPublicBrowserConfig(env), { url: env.NEXT_PUBLIC_SUPABASE_URL, key: env.NEXT_PUBLIC_SUPABASE_ANON_KEY });
  assert.equal(config.getPublicBrowserConfig({ ...env, NEXT_PUBLIC_SUPABASE_ANON_KEY: jwt('service_role') }), null);
  assert.equal(config.getPublicBrowserConfig({ ...env, NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: 'sb_secret_not_public' }), null);
  assert.deepEqual(config.getPublicBrowserConfig({ ...env, NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: 'sb_publishable_public' }), { url: env.NEXT_PUBLIC_SUPABASE_URL, key: 'sb_publishable_public' });
  const dangerous = { url: 'https://example.test/</script><script>alert(1)</script>', key: 'sb_publishable_public' };
  const serialized = config.serializePublicBrowserConfig(dangerous);
  assert.ok(!serialized.includes('</script>'));
  assert.deepEqual(config.parsePublicBrowserConfig(serialized), dangerous);
  assert.equal(config.parsePublicBrowserConfig('{invalid'), null);
  assert.equal(config.parsePublicBrowserConfig(JSON.stringify({url: env.NEXT_PUBLIC_SUPABASE_URL, key: jwt('service_role')})), null);

  // Build the dashboard with no public variables baked in, then inject them as
  // request-time worker environment variables, just as in a runtime deployment.
  const layout = await load('app/dashboard/layout.tsx', {
    define: { 'process.env.NEXT_PUBLIC_SUPABASE_URL': 'undefined', 'process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY': 'undefined', 'process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY': 'undefined' },
    plugins: [{ name: 'headers', setup(build) {
      build.onResolve({ filter: /^next\/headers$/ }, () => ({ path: 'next/headers', namespace: 'mock' }));
      build.onLoad({ filter: /.*/, namespace: 'mock' }, () => ({ contents: 'exports.cookies = async () => ({});', loader: 'js' }));
    } }],
  });
  const old = { ...process.env };
  Object.assign(process.env, env);
  delete process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  try {
    const html = renderToStaticMarkup(await layout.default({ children: React.createElement('div', null, 'planner') }));
    const dom = new JSDOM(html, { url: 'https://nova.example' });
    const script = dom.window.document.getElementById(config.PUBLIC_SUPABASE_CONFIG_ID);
    assert.equal(script.type, 'application/json');
    assert.deepEqual(config.parsePublicBrowserConfig(script.textContent), {url: env.NEXT_PUBLIC_SUPABASE_URL, key: env.NEXT_PUBLIC_SUPABASE_ANON_KEY});
    global.document = dom.window.document;
    global.__novaTestCalls = [];
    const browser = await load('lib/supabase/client.ts', {
      define: { 'process.env.NEXT_PUBLIC_SUPABASE_URL': 'undefined', 'process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY': 'undefined', 'process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY': 'undefined' },
      plugins: [{ name: 'supabase', setup(build) {
        build.onResolve({ filter: /^@supabase\/ssr$/ }, () => ({ path: '@supabase/ssr', namespace: 'mock' }));
        build.onLoad({ filter: /.*/, namespace: 'mock' }, () => ({ contents: 'exports.createBrowserClient = (url, key) => { globalThis.__novaTestCalls.push({url,key}); return {url,key}; };', loader: 'js' }));
      } }],
    });
    assert.deepEqual(browser.createClient(), {url: env.NEXT_PUBLIC_SUPABASE_URL, key: env.NEXT_PUBLIC_SUPABASE_ANON_KEY});
    script.remove();
    assert.throws(() => browser.createClient(), /Supabase/);
    dom.window.close();
  } finally {
    for (const key of ['NEXT_PUBLIC_SUPABASE_URL','NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY','NEXT_PUBLIC_SUPABASE_ANON_KEY']) {
      if (old[key] === undefined) delete process.env[key]; else process.env[key] = old[key];
    }
    delete global.document;
    delete global.__novaTestCalls;
  }
  console.log('PASS: runtime dashboard Supabase config, public-key safety, escaping and absent build variables');
})().catch(error => { console.error(error); process.exitCode = 1; });

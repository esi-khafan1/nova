const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const {renderToStaticMarkup} = require('react-dom/server');
const {JSDOM} = require('jsdom');

function loadTs(path, deps) {
  const code = ts.transpileModule(fs.readFileSync(path, 'utf8'), {
    fileName: path,
    compilerOptions: {jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022},
  }).outputText;
  const mod = {exports: {}};
  vm.runInThisContext('(function(require,module,exports){' + code + '\n})', {filename: path})(
    name => Object.hasOwn(deps, name) ? deps[name] : require(name), mod, mod.exports,
  );
  return mod.exports;
}

const Link = ({href, children, ...props}) => React.createElement('a', {...props, href}, children);
const Shell = loadTs('components/dashboard/dashboard-shell.tsx', {
  'next/link': {__esModule: true, default: Link},
  '@/components/logo': {Logo: () => null},
  '@/components/landing-header': {LandingHeader: () => null},
  '@/app/landing-approved.css': {}, '@/app/student-panel.css': {}, '@/app/courses.css': {},
  '@/app/counselor-panel.css': {}, '@/app/exam-panel-refresh.css': {},
  '@/app/dashboard/actions': {signOut: async () => {}},
}).DashboardShell;
const nav = html => new JSDOM(html).window.document;
const countLinks = doc => doc.querySelectorAll('a[href="/dashboard/admin/courses"]').length;

(async () => {
  let doc = nav(renderToStaticMarkup(React.createElement(Shell, {role:'admin', name:'مدیر', isSuperAdmin:true}, 'content')));
  assert.equal(doc.querySelectorAll('.portal-sidebar a[href="/dashboard/admin/courses"]').length, 1);
  assert.equal(doc.querySelectorAll('.portal-mobile-nav a[href="/dashboard/admin/courses"]').length, 1);
  assert.equal(doc.querySelectorAll('.portal-sidebar a[href="/dashboard/admin/student-login"]').length, 1);
  assert.equal(doc.querySelectorAll('.portal-mobile-nav a[href="/dashboard/admin/student-login"]').length, 1);
  assert.equal(doc.querySelector('.portal-sidebar a[href="/dashboard/admin/courses"]').textContent, 'دوره‌ها');
  for (const props of [{role:'admin'}, {role:'admin',isSuperAdmin:false}, {role:'student',isSuperAdmin:true}, {role:'counselor',isSuperAdmin:true}]) {
    doc = nav(renderToStaticMarkup(React.createElement(Shell, {...props, name:'نام'}, 'content')));
    assert.equal(countLinks(doc), 0, `unexpected course link for ${JSON.stringify(props)}`);
    assert.equal(doc.querySelectorAll('a[href="/dashboard/admin/student-login"]').length,0);
  }

  let context;
  const superAdminLib = loadTs('lib/super-admin.ts', {
    '@/lib/auth': {requireProfile: async () => context},
    'next/navigation': {redirect: path => {throw new Error(`redirect:${path}`);}},
  });
  const makeContext = (role, data, error = null) => ({
    profile:{id:'me',full_name:'مدیر',role}, user:{},
    supabase:{rpc: async name => {assert.equal(name,'admin_list_super_admins');return {data,error};}},
  });
  assert.equal(await superAdminLib.hasSuperAdminAccess(makeContext('admin',[{user_id:'me'}])), true);
  assert.equal(await superAdminLib.hasSuperAdminAccess(makeContext('admin',[{user_id:'other'}])), false);
  assert.equal(await superAdminLib.hasSuperAdminAccess(makeContext('admin',[{user_id:'me'}],{message:'failed'})), false);
  assert.equal(await superAdminLib.hasSuperAdminAccess(makeContext('admin',null)), false);
  assert.equal(await superAdminLib.hasSuperAdminAccess({profile:{id:'me',role:'admin'},supabase:{rpc:async()=>{throw new Error('network');}}}), false);
  assert.equal(await superAdminLib.hasSuperAdminAccess(makeContext('student',[{user_id:'me'}])), false);
  context = makeContext('admin',[{user_id:'me'}]);
  assert.equal(await superAdminLib.requireSuperAdmin(), context);
  context = makeContext('admin',[]);
  await assert.rejects(superAdminLib.requireSuperAdmin(), /redirect:\/dashboard\/admin/);

  function overviewContext(superUser) {
    return {profile:{id:'me',full_name:'مدیر',role:'admin'}, supabase:{rpc(name) {
      if(name==='admin_dashboard_counts') return {single:async()=>({data:{users:1,students:1,counselors:0},error:null})};
      assert.equal(name,'admin_list_super_admins');
      return Promise.resolve({data:superUser?[{user_id:'me'}]:[],error:null});
    }}};
  }
  for (const superUser of [true,false]) {
    const overview = loadTs('app/dashboard/admin/page.tsx', {
      'next/link':{__esModule:true,default:Link},
      '@/components/dashboard/dashboard-shell':{DashboardShell:Shell},
      '@/lib/auth':{requireProfile:async()=>overviewContext(superUser)},
    }).default;
    doc = nav(renderToStaticMarkup(await overview()));
    assert.equal(countLinks(doc), superUser ? 2 : 0);
    assert.equal([...doc.querySelectorAll('section h2')].some(h=>h.textContent==='دوره‌ها'),false);
  }

  const stubShell = () => null;
  for (const superUser of [true,false]) {
    const ctx = {profile:{id:'me',full_name:'مدیر',role:'admin'},user:{phone:null},supabase:{rpc:async name => {
      if(name==='admin_list_super_admins') return {data:superUser?[{user_id:'me'}]:[],error:null};
      if(name==='admin_list_users') return {data:[],error:null};
      throw new Error(name);
    }}};
    const shellDep = {'@/components/dashboard/dashboard-shell':{DashboardShell:stubShell}};
    const registration = loadTs('app/dashboard/admin/registrations/page.tsx', {
      ...shellDep,'@/lib/auth':{requireProfile:async()=>ctx},
      '@/lib/super-admin':{hasSuperAdminAccess:async()=>superUser},
      '@/components/dashboard/registration-directory':{RegistrationDirectory:()=>null},
      '@/lib/registration':{provinces:[]},
    }).default;
    assert.equal((await registration({searchParams:Promise.resolve({})})).props.isSuperAdmin, superUser);
    const account = loadTs('app/dashboard/account/page.tsx', {
      ...shellDep,'@/lib/auth':{requireProfile:async()=>ctx},
      '@/lib/super-admin':{hasSuperAdminAccess:async()=>superUser},
      '@/components/dashboard/phone-link':{PhoneLink:()=>null},
    }).default;
    assert.equal((await account()).props.isSuperAdmin, superUser);
    const users = loadTs('app/dashboard/admin/users/page.tsx', {
      ...shellDep,'@/lib/auth':{requireProfile:async()=>ctx},
      '@/components/dashboard/user-role-form':{UserRoleForm:()=>null},'./users.css':{},
    }).default;
    assert.equal((await users({searchParams:Promise.resolve({})})).props.isSuperAdmin, superUser);
    const recovery = loadTs('app/dashboard/admin/password-recovery/page.tsx', {
      ...shellDep,'@/lib/auth':{requireProfile:async()=>ctx},
      '@/components/dashboard/recovery-send-button':{RecoverySendButton:()=>null},
      './actions':{sendRecoveryEmail:async()=>{}},'./recovery.css':{},
    }).default;
    assert.equal((await recovery({searchParams:Promise.resolve({})})).props.isSuperAdmin, superUser);
  }
  const course = loadTs('app/dashboard/admin/courses/page.tsx', {
    'next/link':{__esModule:true,default:Link},
    '@/components/dashboard/dashboard-shell':{DashboardShell:stubShell},
    '@/components/dashboard/course-offer-form':{CourseOfferForm:()=>null},
    '@/components/dashboard/course-status-picker':{CourseStatusPicker:()=>null},
    '@/lib/load-course-offers':{loadCourseOffers:async()=>null},
    '@/lib/super-admin':{requireSuperAdmin:async()=>({profile:{full_name:'مدیر'}})},
    './actions':{saveCourseReservation:async()=>{}},'./settings.css':{},
  }).default;
  assert.equal((await course({searchParams:Promise.resolve({})})).props.isSuperAdmin,true);
  console.log('PASS: super-admin-only course navigation on all admin pages and mobile, overview card removed, server guard fails closed');
})().catch(error => {console.error(error);process.exitCode=1;});

const assert=require('node:assert/strict');
const fs=require('node:fs');
const {PGlite}=require('@electric-sql/pglite');
const esbuild=require('esbuild');
const Module=require('module');
(async()=>{
 const db=new PGlite();
 await db.exec(`create role anon; create role authenticated; create schema private;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super',true)='yes'$$;`);
 await db.exec(fs.readFileSync('supabase/migrations/110_super_admin_course_settings.sql','utf8'));
 let offers=(await db.query('select * from public.get_course_offer_settings()')).rows;
 assert.equal(offers.length,8);
 for(const row of offers){assert.equal(row.discount_percent,row.grade===12?15:17);assert.equal(row.monthly_price,row.grade===12?(row.plan==='base'?2700000:3000000):(row.plan==='base'?2490000:2790000));assert.equal(row.reservation,false);}
 await db.exec("set role anon");
 assert.equal((await db.query('select count(*)::int as n from public.get_course_offer_settings()')).rows[0].n,8);
 await assert.rejects(db.query("select public.super_admin_set_course_reservation(true)"),/permission denied/i);
 await assert.rejects(db.query("select * from private.course_offer_settings"),/permission denied/i);
 await db.exec("reset role; set role authenticated; select set_config('test.super','no',false)");
 await assert.rejects(db.query("select public.super_admin_set_course_reservation(true)"),/Super admin only/);
 await assert.rejects(db.query("select public.super_admin_set_course_offer(12::smallint,'base',20::smallint,2560000)"),/Super admin only/);
 await db.exec("select set_config('test.super','yes',false)");
 await db.query("select public.super_admin_set_course_reservation(true)");
 assert.ok((await db.query('select reservation from public.get_course_offer_settings()')).rows.every(r=>r.reservation));
 await db.query("select public.super_admin_set_course_offer(12::smallint,'base',20::smallint,2570000)");
 offers=(await db.query('select * from public.get_course_offer_settings()')).rows;
 assert.equal(offers.find(r=>r.grade===12&&r.plan==='base').monthly_price,2570000);
 assert.equal(offers.find(r=>r.grade===12&&r.plan==='progress').monthly_price,3000000);
 for(const q of ["select public.super_admin_set_course_offer(12::smallint,'base',101::smallint,10000)","select public.super_admin_set_course_offer(12::smallint,'base',1::smallint,12345)","select public.super_admin_set_course_offer(8::smallint,'base',1::smallint,10000)","select public.super_admin_set_course_reservation(null)"]){await assert.rejects(db.query(q),/Invalid/);}
 await db.close();
 const compiled=esbuild.buildSync({entryPoints:['lib/courses.ts'],bundle:true,platform:'node',format:'cjs',write:false,tsconfig:'tsconfig.json'}).outputFiles[0].text;
 const mod=new Module('courses');mod.filename='courses.cjs';mod.paths=module.paths;mod._compile(compiled,'courses.cjs');
 for(const grade of [9,10,11,12]) for(const c of mod.exports.coursesFor(grade,grade===9?null:'humanities')) {const month=grade===12?(c.course==='base'?2700000:3000000):(c.course==='base'?2490000:2790000);assert.equal(mod.exports.coursePrice(c),month*c.months);}
 const changed=offers.map(o=>({...o,grade:Number(o.grade)}));
 assert.equal(mod.exports.coursePrice({grade:12,field:'humanities',course:'base',months:6},changed),2570000*6);
 console.log('PASS: price matrix, dynamic duration prices, global reservation, public reads and super-admin-only writes');
})().catch(e=>{console.error(e);process.exitCode=1});

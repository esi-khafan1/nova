const assert = require('node:assert/strict');
const fs = require('node:fs');
const { PGlite } = require('@electric-sql/pglite');

(async () => {
  const db = new PGlite();
  try {
    await db.exec(`
      create role anon; create role authenticated;
      create schema private;
      create type public.app_role as enum ('student', 'counselor', 'admin');
      create table public.profiles (id uuid primary key, role public.app_role not null, registration_status text not null);
      create table public.student_history (student_id uuid references public.profiles(id), note text);
      insert into public.profiles values
        ('00000000-0000-4000-8000-000000000001', 'student', 'active'),
        ('00000000-0000-4000-8000-000000000002', 'counselor', 'active');
      insert into public.student_history values ('00000000-0000-4000-8000-000000000001','preserved');
    `);
    await db.exec(fs.readFileSync('supabase/experimental/student_account_blocks_foundation.sql', 'utf8'));
    const student = '00000000-0000-4000-8000-000000000001';
    const counselor = '00000000-0000-4000-8000-000000000002';
    const insert = id => db.query('insert into private.student_account_blocks(student_id,blocked_by) values ($1,$2)', [id, counselor]);
    await assert.rejects(insert(counselor), /Only student accounts/);
    await assert.rejects(insert('00000000-0000-4000-8000-000000000003'), /Only student accounts/);
    await insert(student);
    await assert.rejects(db.query("update public.profiles set role='admin' where id=$1", [student]), /Unblock this student/);
    await assert.rejects(db.query('update private.student_account_blocks set student_id=$1 where student_id=$2', [counselor,student]), /Only student accounts/);
    assert.equal((await db.query('select registration_status from public.profiles where id=$1', [student])).rows[0].registration_status, 'active');
    assert.equal((await db.query('select note from public.student_history where student_id=$1', [student])).rows[0].note, 'preserved');
    for (const table of ['student_account_blocks', 'student_account_block_events']) {
      const result = await db.query(`select has_table_privilege('authenticated', $1, 'select') as can_select, has_table_privilege('authenticated', $1, 'insert') as can_insert`, [`private.${table}`]);
      assert.deepEqual(result.rows[0], {can_select:false,can_insert:false});
    }
    await db.query('delete from private.student_account_blocks where student_id=$1', [student]);
    await db.query("update public.profiles set role='admin' where id=$1", [student]);
    assert.equal((await db.query('select note from public.student_history where student_id=$1', [student])).rows[0].note, 'preserved');
    console.log('PASS: experimental block foundation: role guard, restricted tables, preserved history');
  } finally { await db.close(); }
})().catch(error => {console.error(error);process.exitCode = 1});

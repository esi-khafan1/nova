-- EXPERIMENTAL FOUNDATION ONLY. Not a migration and not a complete ban.
-- Do not deploy or expose controls until Auth, existing JWTs, PostgREST,
-- Storage, Realtime and all privileged Edge Functions have been guarded and
-- integration-tested together. Registration/service status is independent.

create table private.student_account_blocks (
  student_id uuid primary key references public.profiles(id) on delete cascade,
  blocked_at timestamptz not null default now(),
  blocked_by uuid not null
);
alter table private.student_account_blocks enable row level security;
revoke all on private.student_account_blocks from public, anon, authenticated;

-- This is separate from the current state so unblock does not erase history.
-- No authenticated client gets direct read or write access.
create table private.student_account_block_events (
  id bigint generated always as identity primary key,
  student_id uuid not null,
  actor_id uuid not null,
  event text not null check (event in ('block', 'unblock')),
  occurred_at timestamptz not null default now()
);
alter table private.student_account_block_events enable row level security;
revoke all on private.student_account_block_events from public, anon, authenticated;

-- Serialize creation of a block against role changes on the same profile.
-- Never allow the state to be attached to a non-student account.
create function private.guard_student_account_block_insert() returns trigger
language plpgsql security definer set search_path = '' as $$
declare target_role public.app_role;
begin
  select role into target_role from public.profiles where id = new.student_id for update;
  if not found or target_role is distinct from 'student'::public.app_role then
    raise exception 'Only student accounts may be blocked' using errcode = '23514';
  end if;
  return new;
end; $$;
revoke all on function private.guard_student_account_block_insert() from public, anon, authenticated;
create trigger guard_student_account_block_insert before insert or update of student_id
on private.student_account_blocks for each row execute function private.guard_student_account_block_insert();

-- A blocked student must be unblocked before a role change. The profile row
-- lock held by UPDATE serializes this test against the insert trigger above.
create function private.guard_blocked_student_role_change() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if new.role is distinct from old.role and exists (
    select 1 from private.student_account_blocks where student_id = old.id
  ) then
    raise exception 'Unblock this student before changing their role' using errcode = '23514';
  end if;
  return new;
end; $$;
revoke all on function private.guard_blocked_student_role_change() from public, anon, authenticated;
create trigger guard_blocked_student_role_change before update of role on public.profiles
for each row execute function private.guard_blocked_student_role_change();

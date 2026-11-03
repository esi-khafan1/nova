-- One student-authored note per calendar day, independent of weekly plans.
-- RLS grants read access only to the active student and the currently assigned counselor.
create table public.student_daily_notes (
 student_id uuid not null references public.profiles(id) on delete cascade,
 day date not null,
 note text not null check(char_length(note) between 1 and 2000),
 updated_at timestamptz not null default now(),
 primary key(student_id,day)
);
alter table public.student_daily_notes enable row level security;
revoke all on public.student_daily_notes from public,anon,authenticated;
grant select on public.student_daily_notes to authenticated;
create policy daily_notes_read_current_participants on public.student_daily_notes
 for select to authenticated using (
  (student_id=(select auth.uid()) and private.student_services_active(student_id))
  or private.counselor_currently_assigned(student_id)
 );

create function public.save_student_daily_note(target_day date,target_note text)
returns void language plpgsql security definer set search_path='' as $$
declare me uuid := (select auth.uid()); cleaned text := pg_catalog.btrim(target_note);
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
    or not private.student_services_active(me) then
   raise exception 'Active student required';
 end if;
 if target_day is null or target_day < date '2020-01-01'
    or target_day > timezone('Asia/Tehran',now())::date then
   raise exception 'Only past and current days can be edited';
 end if;
 if cleaned is null or pg_catalog.char_length(cleaned)>2000 then
   raise exception 'Invalid daily note';
 end if;
 if cleaned='' then
   delete from public.student_daily_notes where student_id=me and day=target_day;
 else
   insert into public.student_daily_notes(student_id,day,note) values(me,target_day,cleaned)
   on conflict (student_id,day) do update set note=excluded.note,updated_at=now();
 end if;
end;$$;
revoke all on function public.save_student_daily_note(date,text) from public,anon;
grant execute on function public.save_student_daily_note(date,text) to authenticated;
notify pgrst,'reload schema';

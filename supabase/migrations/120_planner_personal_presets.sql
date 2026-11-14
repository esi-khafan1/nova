-- Counselor-owned ready blocks, personal patterns and week templates.
-- These are snapshots only; they cannot write or publish any student's plan.
create table private.planner_personal_presets (
  id uuid primary key default gen_random_uuid(),
  counselor_id uuid not null references public.profiles(id) on delete cascade,
  kind text not null check (kind in ('block','pattern','week')),
  name text not null check (char_length(name) between 1 and 120 and name=btrim(name)),
  payload jsonb not null check (jsonb_typeof(payload)='object' and octet_length(payload::text)<=200000),
  pinned boolean not null default false,
  revision bigint not null default 1 check (revision>0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index planner_presets_owner_kind on private.planner_personal_presets(counselor_id,kind,pinned desc,updated_at desc,id);
revoke all on private.planner_personal_presets from public, anon, authenticated;

create function private.require_planner_preset_access()
returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
  or not exists(select 1 from public.counselor_profiles cp where cp.user_id=(select auth.uid()) and cp.approval_status='approved')
 then raise exception 'Approved counselor required' using errcode='42501'; end if;
end; $$;
revoke all on function private.require_planner_preset_access() from public,anon,authenticated;

create function public.planner_list_presets(target_kind text)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
 perform private.require_planner_preset_access();
 if target_kind is null or target_kind not in ('block','pattern','week') then raise exception 'Invalid preset kind' using errcode='22023'; end if;
 select coalesce(jsonb_agg(jsonb_build_object('id',p.id,'name',p.name,'payload',p.payload,'pinned',p.pinned,
  'revision',p.revision::text,'updated_at',p.updated_at) order by p.pinned desc,p.updated_at desc,p.id),'[]'::jsonb)
 into result from private.planner_personal_presets p where p.counselor_id=(select auth.uid()) and p.kind=target_kind;
 return result;
end; $$;
revoke all on function public.planner_list_presets(text) from public,anon;
grant execute on function public.planner_list_presets(text) to authenticated;

create function public.planner_save_preset(target_id uuid,target_kind text,target_name text,target_payload jsonb,target_pinned boolean,expected_revision text)
returns jsonb language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); saved private.planner_personal_presets%rowtype;
begin
 perform private.require_planner_preset_access();
 if target_kind is null or target_kind not in ('block','pattern','week') or target_name is null
  or char_length(btrim(target_name)) not between 1 and 120 or target_name ~ '[[:cntrl:]]'
  or target_payload is null or jsonb_typeof(target_payload)<>'object' or octet_length(target_payload::text)>200000
  or target_pinned is null or (expected_revision is not null and expected_revision !~ '^[1-9][0-9]{0,18}$')
 then raise exception 'Invalid preset' using errcode='22023'; end if;
 if target_id is null then
  if expected_revision is not null then raise exception 'Preset has changed' using errcode='40001'; end if;
  insert into private.planner_personal_presets(counselor_id,kind,name,payload,pinned)
   values(me,target_kind,btrim(target_name),target_payload,target_pinned) returning * into saved;
 else
  update private.planner_personal_presets p set name=btrim(target_name),payload=target_payload,pinned=target_pinned,
   revision=p.revision+1,updated_at=now()
  where p.id=target_id and p.counselor_id=me and p.kind=target_kind and p.revision::text=expected_revision returning * into saved;
  if not found then raise exception 'Preset not available or changed' using errcode='40001'; end if;
 end if;
 return jsonb_build_object('id',saved.id,'revision',saved.revision::text,'updated_at',saved.updated_at);
end; $$;
revoke all on function public.planner_save_preset(uuid,text,text,jsonb,boolean,text) from public,anon;
grant execute on function public.planner_save_preset(uuid,text,text,jsonb,boolean,text) to authenticated;

create function public.planner_delete_preset(target_id uuid,expected_revision text)
returns void language plpgsql security definer set search_path='' as $$
begin
 perform private.require_planner_preset_access();
 if target_id is null or expected_revision is null then raise exception 'Invalid preset' using errcode='22023'; end if;
 delete from private.planner_personal_presets p where p.id=target_id and p.counselor_id=(select auth.uid()) and p.revision::text=expected_revision;
 if not found then raise exception 'Preset not available or changed' using errcode='40001'; end if;
end; $$;
revoke all on function public.planner_delete_preset(uuid,text) from public,anon;
grant execute on function public.planner_delete_preset(uuid,text) to authenticated;
notify pgrst, 'reload schema';

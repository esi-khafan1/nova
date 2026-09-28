create type public.app_role as enum ('student', 'counselor', 'admin');
create type public.approval_status as enum ('pending', 'approved', 'rejected');
create type public.content_status as enum ('draft', 'published', 'archived');
create type public.resource_type as enum ('konkur', 'final_exam');
create type public.consultation_status as enum ('pending', 'accepted', 'completed', 'cancelled');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  phone text,
  grade smallint check (grade between 10 and 12),
  role public.app_role not null default 'student',
  avatar_url text,
  bio text check (char_length(bio) <= 1000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.counselor_profiles (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  headline text,
  specialty text,
  experience_years smallint not null default 0 check (experience_years >= 0),
  approval_status public.approval_status not null default 'pending',
  is_accepting boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.resources (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references public.profiles(id) on delete restrict,
  title text not null check (char_length(title) between 3 and 160),
  summary text,
  body text not null,
  resource_type public.resource_type not null,
  grade smallint check (grade between 10 and 12),
  subject text,
  status public.content_status not null default 'draft',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.consultation_requests (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  counselor_id uuid references public.profiles(id) on delete set null,
  topic text not null check (char_length(topic) between 3 and 160),
  description text not null check (char_length(description) between 10 and 3000),
  status public.consultation_status not null default 'pending',
  requested_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint counselor_differs_from_student check (counselor_id is null or counselor_id <> student_id)
);

create or replace function public.set_updated_at() returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end;
$$;

create trigger profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();
create trigger counselor_profiles_updated_at before update on public.counselor_profiles for each row execute function public.set_updated_at();
create trigger resources_updated_at before update on public.resources for each row execute function public.set_updated_at();
create trigger consultation_requests_updated_at before update on public.consultation_requests for each row execute function public.set_updated_at();

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''));
  return new;
end;
$$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

create or replace function public.current_user_role() returns public.app_role language sql stable security definer set search_path = '' as $$
  select role from public.profiles where id = auth.uid();
$$;
create or replace function public.is_approved_counselor() returns boolean language sql stable security definer set search_path = '' as $$
  select exists(select 1 from public.counselor_profiles where user_id = auth.uid() and approval_status = 'approved');
$$;

alter table public.profiles enable row level security;
alter table public.counselor_profiles enable row level security;
alter table public.resources enable row level security;
alter table public.consultation_requests enable row level security;

create policy "profiles_read_own_or_admin" on public.profiles for select to authenticated using (id = auth.uid() or public.current_user_role() = 'admin');
create policy "profiles_update_own_or_admin" on public.profiles for update to authenticated using (id = auth.uid() or public.current_user_role() = 'admin') with check (id = auth.uid() or public.current_user_role() = 'admin');
revoke update on public.profiles from authenticated;
grant update (full_name, phone, grade, avatar_url, bio) on public.profiles to authenticated;

create policy "approved_counselors_are_public" on public.counselor_profiles for select to anon, authenticated using (approval_status = 'approved' or user_id = auth.uid() or public.current_user_role() = 'admin');
create policy "counselor_profile_owner_insert" on public.counselor_profiles for insert to authenticated with check (user_id = auth.uid());
create policy "counselor_profile_owner_update" on public.counselor_profiles for update to authenticated using (user_id = auth.uid() or public.current_user_role() = 'admin') with check (user_id = auth.uid() or public.current_user_role() = 'admin');
revoke update on public.counselor_profiles from authenticated;
grant update (headline, specialty, experience_years, is_accepting) on public.counselor_profiles to authenticated;

create policy "published_resources_are_public" on public.resources for select to anon, authenticated using (status = 'published' or author_id = auth.uid() or public.current_user_role() = 'admin');
create policy "approved_counselors_create_resources" on public.resources for insert to authenticated with check (author_id = auth.uid() and public.is_approved_counselor());
create policy "authors_manage_resources" on public.resources for update to authenticated using (author_id = auth.uid() or public.current_user_role() = 'admin') with check (author_id = auth.uid() or public.current_user_role() = 'admin');
create policy "authors_delete_resources" on public.resources for delete to authenticated using (author_id = auth.uid() or public.current_user_role() = 'admin');

create policy "consultation_participants_read" on public.consultation_requests for select to authenticated using (student_id = auth.uid() or counselor_id = auth.uid() or public.current_user_role() = 'admin');
create policy "students_create_requests" on public.consultation_requests for insert to authenticated with check (student_id = auth.uid() and public.current_user_role() = 'student');
create policy "participants_update_requests" on public.consultation_requests for update to authenticated using (student_id = auth.uid() or counselor_id = auth.uid() or public.current_user_role() = 'admin') with check (student_id = auth.uid() or counselor_id = auth.uid() or public.current_user_role() = 'admin');

create index resources_status_published_idx on public.resources(status, published_at desc);
create index consultation_student_idx on public.consultation_requests(student_id, requested_at desc);
create index consultation_counselor_idx on public.consultation_requests(counselor_id, requested_at desc);

begin;

create extension if not exists pgcrypto;
create schema if not exists app_private;

do $$
begin
  create type public.app_role as enum (
    'alumno',
    'responsable_empresa',
    'tutor',
    'administrador',
    'superadministrador'
  );
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.account_status as enum ('pending', 'active', 'suspended', 'archived');
exception
  when duplicate_object then null;
end $$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null default '',
  last_name text not null default '',
  phone text,
  status public.account_status not null default 'pending',
  first_access_at timestamptz,
  last_access_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_first_name_length check (char_length(first_name) <= 120),
  constraint profiles_last_name_length check (char_length(last_name) <= 180),
  constraint profiles_phone_length check (phone is null or char_length(phone) <= 40)
);

create table if not exists public.user_roles (
  user_id uuid not null references auth.users(id) on delete cascade,
  role public.app_role not null,
  source text not null default 'registration',
  assigned_by uuid references auth.users(id) on delete set null,
  assigned_at timestamptz not null default now(),
  primary key (user_id, role),
  constraint user_roles_source_length check (char_length(source) between 1 and 80)
);

create table if not exists public.organizations (
  id uuid primary key default gen_random_uuid(),
  legal_name text not null,
  trade_name text,
  tax_id text not null,
  billing_email text,
  billing_address jsonb not null default '{}'::jsonb,
  status public.account_status not null default 'active',
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organizations_legal_name_length check (char_length(legal_name) between 1 and 200),
  constraint organizations_trade_name_length check (trade_name is null or char_length(trade_name) <= 200),
  constraint organizations_tax_id_length check (char_length(tax_id) between 3 and 40),
  constraint organizations_billing_address_object check (jsonb_typeof(billing_address) = 'object')
);

create unique index if not exists organizations_tax_id_unique_idx
  on public.organizations (upper(regexp_replace(tax_id, '[^A-Za-z0-9]', '', 'g')));

create table if not exists public.organization_members (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role public.app_role not null default 'alumno',
  status public.account_status not null default 'active',
  invited_by uuid references auth.users(id) on delete set null,
  joined_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (organization_id, user_id),
  constraint organization_members_allowed_role check (
    role in ('alumno', 'responsable_empresa', 'tutor')
  )
);

create index if not exists organization_members_user_id_idx
  on public.organization_members (user_id);
create index if not exists organization_members_org_status_idx
  on public.organization_members (organization_id, status);

create table if not exists public.consent_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  document_type text not null,
  document_version text not null,
  accepted boolean not null default true,
  accepted_at timestamptz not null default now(),
  source text not null default 'registration',
  evidence jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint consent_records_document_type_length check (char_length(document_type) between 1 and 80),
  constraint consent_records_document_version_length check (char_length(document_version) between 1 and 40),
  constraint consent_records_evidence_object check (jsonb_typeof(evidence) = 'object')
);

create index if not exists consent_records_user_type_idx
  on public.consent_records (user_id, document_type, accepted_at desc);

create table if not exists public.audit_logs (
  id bigint generated always as identity primary key,
  actor_user_id uuid references auth.users(id) on delete set null,
  organization_id uuid references public.organizations(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id text,
  payload jsonb not null default '{}'::jsonb,
  occurred_at timestamptz not null default now(),
  constraint audit_logs_action_length check (char_length(action) between 1 and 120),
  constraint audit_logs_entity_type_length check (char_length(entity_type) between 1 and 120),
  constraint audit_logs_payload_object check (jsonb_typeof(payload) = 'object')
);

create index if not exists audit_logs_actor_occurred_idx
  on public.audit_logs (actor_user_id, occurred_at desc);
create index if not exists audit_logs_org_occurred_idx
  on public.audit_logs (organization_id, occurred_at desc);
create index if not exists audit_logs_entity_idx
  on public.audit_logs (entity_type, entity_id, occurred_at desc);

create or replace function app_private.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function app_private.set_updated_at();

drop trigger if exists organizations_set_updated_at on public.organizations;
create trigger organizations_set_updated_at
before update on public.organizations
for each row execute function app_private.set_updated_at();

drop trigger if exists organization_members_set_updated_at on public.organization_members;
create trigger organization_members_set_updated_at
before update on public.organization_members
for each row execute function app_private.set_updated_at();

create or replace function app_private.current_user_has_role(required_roles public.app_role[])
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select auth.uid()) is not null
    and exists (
      select 1
      from public.user_roles ur
      where ur.user_id = (select auth.uid())
        and ur.role = any(required_roles)
    );
$$;

create or replace function app_private.current_user_is_org_member(target_organization_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select auth.uid()) is not null
    and exists (
      select 1
      from public.organization_members om
      where om.organization_id = target_organization_id
        and om.user_id = (select auth.uid())
        and om.status = 'active'
    );
$$;

create or replace function app_private.current_user_manages_org(target_organization_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    (select auth.uid()) is not null
    and (
      app_private.current_user_has_role(
        array['administrador', 'superadministrador']::public.app_role[]
      )
      or exists (
        select 1
        from public.organization_members om
        where om.organization_id = target_organization_id
          and om.user_id = (select auth.uid())
          and om.role = 'responsable_empresa'
          and om.status = 'active'
      )
    );
$$;

create or replace function app_private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, first_name, last_name, status)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'first_name', ''),
    coalesce(new.raw_user_meta_data ->> 'last_name', ''),
    case when new.email_confirmed_at is null then 'pending' else 'active' end
  )
  on conflict (id) do nothing;

  insert into public.user_roles (user_id, role, source)
  values (new.id, 'alumno', 'registration')
  on conflict (user_id, role) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function app_private.handle_new_user();

revoke all on schema app_private from public;
grant usage on schema app_private to authenticated;

revoke execute on function app_private.set_updated_at() from public, anon, authenticated;
revoke execute on function app_private.handle_new_user() from public, anon, authenticated;
revoke execute on function app_private.current_user_has_role(public.app_role[]) from public, anon;
revoke execute on function app_private.current_user_is_org_member(uuid) from public, anon;
revoke execute on function app_private.current_user_manages_org(uuid) from public, anon;
grant execute on function app_private.current_user_has_role(public.app_role[]) to authenticated;
grant execute on function app_private.current_user_is_org_member(uuid) to authenticated;
grant execute on function app_private.current_user_manages_org(uuid) to authenticated;

alter table public.profiles enable row level security;
alter table public.user_roles enable row level security;
alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;
alter table public.consent_records enable row level security;
alter table public.audit_logs enable row level security;

drop policy if exists profiles_select_own_or_staff on public.profiles;
create policy profiles_select_own_or_staff
on public.profiles for select
to authenticated
using (
  id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own
on public.profiles for update
to authenticated
using (id = (select auth.uid()))
with check (id = (select auth.uid()));

drop policy if exists user_roles_select_own_or_admin on public.user_roles;
create policy user_roles_select_own_or_admin
on public.user_roles for select
to authenticated
using (
  user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists user_roles_manage_superadmin on public.user_roles;
create policy user_roles_manage_superadmin
on public.user_roles for all
to authenticated
using (
  (select app_private.current_user_has_role(
    array['superadministrador']::public.app_role[]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array['superadministrador']::public.app_role[]
  ))
);

drop policy if exists organizations_select_member_or_staff on public.organizations;
create policy organizations_select_member_or_staff
on public.organizations for select
to authenticated
using (
  (select app_private.current_user_is_org_member(id))
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists organizations_insert_admin on public.organizations;
create policy organizations_insert_admin
on public.organizations for insert
to authenticated
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists organizations_update_manager on public.organizations;
create policy organizations_update_manager
on public.organizations for update
to authenticated
using ((select app_private.current_user_manages_org(id)))
with check ((select app_private.current_user_manages_org(id)));

drop policy if exists organization_members_select_visible on public.organization_members;
create policy organization_members_select_visible
on public.organization_members for select
to authenticated
using (
  user_id = (select auth.uid())
  or (select app_private.current_user_manages_org(organization_id))
  or (select app_private.current_user_has_role(
    array['tutor', 'administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists organization_members_manage_manager on public.organization_members;
create policy organization_members_manage_manager
on public.organization_members for all
to authenticated
using ((select app_private.current_user_manages_org(organization_id)))
with check ((select app_private.current_user_manages_org(organization_id)));

drop policy if exists consent_records_select_own_or_admin on public.consent_records;
create policy consent_records_select_own_or_admin
on public.consent_records for select
to authenticated
using (
  user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists consent_records_insert_own on public.consent_records;
create policy consent_records_insert_own
on public.consent_records for insert
to authenticated
with check (user_id = (select auth.uid()));

drop policy if exists audit_logs_select_admin on public.audit_logs;
create policy audit_logs_select_admin
on public.audit_logs for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

revoke all on public.profiles, public.user_roles, public.organizations,
  public.organization_members, public.consent_records, public.audit_logs
from anon, authenticated;

grant select on public.profiles to authenticated;
grant update (first_name, last_name, phone)
  on public.profiles to authenticated;
grant select on public.user_roles to authenticated;
grant insert, update, delete on public.user_roles to authenticated;
grant select, insert, update on public.organizations to authenticated;
grant select, insert, update, delete on public.organization_members to authenticated;
grant select, insert on public.consent_records to authenticated;
grant select on public.audit_logs to authenticated;

commit;

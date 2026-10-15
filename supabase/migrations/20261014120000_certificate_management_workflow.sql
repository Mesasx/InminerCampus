begin;

-- Un certificado puede incluir varios documentos definitivos (por ejemplo,
-- diploma y acreditación complementaria) sin romper el certificado STVH que
-- ya se emite de forma automática por matrícula.
create table if not exists public.certificate_documents (
  id uuid primary key default gen_random_uuid(),
  certificate_id uuid not null references public.certificates(id) on delete cascade,
  enrollment_id uuid not null references public.enrollments(id) on delete restrict,
  user_id uuid not null references auth.users(id) on delete restrict,
  display_name text not null,
  original_file_name text not null,
  storage_path text not null,
  issued_at timestamptz not null default now(),
  uploaded_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  constraint certificate_documents_display_name_length
    check (char_length(btrim(display_name)) between 1 and 240),
  constraint certificate_documents_original_name_length
    check (char_length(btrim(original_file_name)) between 1 and 240),
  constraint certificate_documents_storage_path_length
    check (char_length(storage_path) between 10 and 500),
  unique (storage_path)
);

create index if not exists certificate_documents_certificate_issued_idx
  on public.certificate_documents (certificate_id, issued_at desc);
create index if not exists certificate_documents_enrollment_issued_idx
  on public.certificate_documents (enrollment_id, issued_at desc);
create index if not exists certificate_documents_user_issued_idx
  on public.certificate_documents (user_id, issued_at desc);

alter table public.certificate_documents enable row level security;

drop policy if exists certificate_documents_visible on public.certificate_documents;
create policy certificate_documents_visible
on public.certificate_documents for select
to authenticated
using (
  user_id = (select auth.uid())
  or (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists certificate_documents_admin_manage on public.certificate_documents;
create policy certificate_documents_admin_manage
on public.certificate_documents for all
to authenticated
using (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

revoke all on public.certificate_documents from public, anon, authenticated;
grant select on public.certificate_documents to authenticated;
grant insert, update, delete on public.certificate_documents to authenticated;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'certificates',
  'certificates',
  false,
  10485760,
  array['application/pdf']::text[]
)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

-- La API usa la clave de servicio, pero estas políticas mantienen el bucket
-- protegido también si más adelante se accede desde un cliente autenticado.
drop policy if exists certificate_owner_read on storage.objects;
drop policy if exists certificate_admin_write on storage.objects;

drop policy if exists certificate_files_owner_read on storage.objects;
create policy certificate_files_owner_read
on storage.objects for select
to authenticated
using (
  bucket_id = 'certificates'
  and (
    exists (
      select 1
      from public.certificate_documents cd
      where cd.storage_path = name
        and cd.user_id = (select auth.uid())
    )
    or exists (
      select 1
      from public.certificates c
      where c.pdf_storage_path = name
        and c.user_id = (select auth.uid())
        and c.status = 'valid'::public.certificate_status
    )
  )
);

drop policy if exists certificate_files_admin_read on storage.objects;
create policy certificate_files_admin_read
on storage.objects for select
to authenticated
using (
  bucket_id = 'certificates'
  and (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists certificate_files_admin_insert on storage.objects;
create policy certificate_files_admin_insert
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'certificates'
  and (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists certificate_files_admin_update on storage.objects;
create policy certificate_files_admin_update
on storage.objects for update
to authenticated
using (
  bucket_id = 'certificates'
  and (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
)
with check (
  bucket_id = 'certificates'
  and (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

drop policy if exists certificate_files_admin_delete on storage.objects;
create policy certificate_files_admin_delete
on storage.objects for delete
to authenticated
using (
  bucket_id = 'certificates'
  and (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  ))
);

commit;

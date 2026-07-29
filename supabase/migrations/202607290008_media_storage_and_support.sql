-- InmínerCampus
-- Private media metadata, storage authorization and atomic support threads.

create table if not exists public.lesson_videos (
  lesson_id uuid primary key references public.lessons(id) on delete cascade,
  provider text not null default 'supabase',
  provider_asset_id text,
  playback_id text,
  storage_path text,
  duration_seconds integer not null default 0,
  processing_status text not null default 'pending',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint lesson_videos_provider check (
    provider in ('supabase', 'mux', 'vimeo')
  ),
  constraint lesson_videos_duration_nonnegative check (duration_seconds >= 0),
  constraint lesson_videos_status check (
    processing_status in ('pending', 'processing', 'ready', 'failed')
  ),
  constraint lesson_videos_source check (
    provider_asset_id is not null or storage_path is not null
  )
);

drop trigger if exists lesson_videos_set_updated_at on public.lesson_videos;
create trigger lesson_videos_set_updated_at
before update on public.lesson_videos
for each row execute function app_private.set_updated_at();

alter table public.lesson_videos enable row level security;
alter table public.lesson_videos force row level security;

revoke all on public.lesson_videos from anon, authenticated;
grant select (
  lesson_id,
  duration_seconds,
  processing_status,
  published_at
) on public.lesson_videos to authenticated;
grant all on public.lesson_videos to service_role;

drop policy if exists lesson_videos_visible on public.lesson_videos;
create policy lesson_videos_visible
on public.lesson_videos
for select
to authenticated
using (
  exists (
    select 1
    from public.lessons l
    join public.course_modules m on m.id = l.module_id
    where l.id = lesson_id
      and (
        (select app_private.current_user_is_enrolled(m.course_version_id))
        or (select app_private.current_user_has_role(
          array[
            'tutor'::public.app_role,
            'administrador'::public.app_role,
            'superadministrador'::public.app_role
          ]
        ))
      )
  )
);

drop policy if exists lesson_videos_staff_all on public.lesson_videos;
create policy lesson_videos_staff_all
on public.lesson_videos
for all
to authenticated
using (
  (select app_private.current_user_has_role(
    array[
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
)
with check (
  (select app_private.current_user_has_role(
    array[
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
);

create or replace function public.create_support_thread(
  p_subject text,
  p_body text,
  p_enrollment_id uuid default null,
  p_lesson_id uuid default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  new_thread_id uuid;
begin
  if current_user_id is null then
    raise exception 'Authentication required';
  end if;

  if char_length(trim(p_subject)) not between 3 and 240 then
    raise exception 'Invalid subject';
  end if;

  if char_length(trim(p_body)) not between 1 and 10000 then
    raise exception 'Invalid message';
  end if;

  if p_enrollment_id is not null and not exists (
    select 1
    from public.enrollments e
    where e.id = p_enrollment_id
      and e.user_id = current_user_id
  ) then
    raise exception 'Enrollment is not available';
  end if;

  if p_lesson_id is not null and (
    p_enrollment_id is null
    or not exists (
      select 1
      from public.enrollments e
      join public.course_modules m
        on m.course_version_id = e.course_version_id
      join public.lessons l on l.module_id = m.id
      where e.id = p_enrollment_id
        and e.user_id = current_user_id
        and l.id = p_lesson_id
    )
  ) then
    raise exception 'Lesson is not part of enrollment';
  end if;

  insert into public.support_threads (
    user_id,
    enrollment_id,
    lesson_id,
    subject,
    status
  )
  values (
    current_user_id,
    p_enrollment_id,
    p_lesson_id,
    trim(p_subject),
    'new'
  )
  returning id into new_thread_id;

  insert into public.support_messages (
    thread_id,
    sender_user_id,
    body
  )
  values (
    new_thread_id,
    current_user_id,
    trim(p_body)
  );

  return new_thread_id;
end;
$$;

revoke all on function public.create_support_thread(text, text, uuid, uuid)
  from public, anon;
grant execute on function public.create_support_thread(text, text, uuid, uuid)
  to authenticated;

-- Storage paths use the first folder as the authorization scope:
-- course-materials/<course-version-id>/...
-- support-attachments/<thread-id>/...
-- practice-evidence/<enrollment-id>/...
-- certificates/<user-id>/...

drop policy if exists course_materials_enrolled_read on storage.objects;
create policy course_materials_enrolled_read
on storage.objects
for select
to authenticated
using (
  bucket_id = 'course-materials'
  and case
    when (storage.foldername(name))[1]
      ~ '^[0-9a-fA-F-]{36}$'
    then (
      select app_private.current_user_is_enrolled(
        ((storage.foldername(name))[1])::uuid
      )
    ) or (
      select app_private.current_user_has_role(
        array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]
      )
    )
    else false
  end
);

drop policy if exists course_materials_admin_write on storage.objects;
create policy course_materials_admin_write
on storage.objects
for all
to authenticated
using (
  bucket_id = 'course-materials'
  and (select app_private.current_user_has_role(
    array[
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
)
with check (
  bucket_id = 'course-materials'
  and (select app_private.current_user_has_role(
    array[
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
);

drop policy if exists support_attachments_participant_access on storage.objects;
create policy support_attachments_participant_access
on storage.objects
for all
to authenticated
using (
  bucket_id = 'support-attachments'
  and case
    when (storage.foldername(name))[1] ~ '^[0-9a-fA-F-]{36}$'
    then (
      select app_private.current_user_can_access_support_thread(
        ((storage.foldername(name))[1])::uuid
      )
    )
    else false
  end
)
with check (
  bucket_id = 'support-attachments'
  and case
    when (storage.foldername(name))[1] ~ '^[0-9a-fA-F-]{36}$'
    then (
      select app_private.current_user_can_access_support_thread(
        ((storage.foldername(name))[1])::uuid
      )
    )
    else false
  end
);

drop policy if exists certificate_owner_read on storage.objects;
create policy certificate_owner_read
on storage.objects
for select
to authenticated
using (
  bucket_id = 'certificates'
  and (
    (storage.foldername(name))[1] = (select auth.uid())::text
    or (select app_private.current_user_has_role(
      array[
        'administrador'::public.app_role,
        'superadministrador'::public.app_role
      ]
    ))
  )
);

drop policy if exists certificate_admin_write on storage.objects;
create policy certificate_admin_write
on storage.objects
for all
to authenticated
using (
  bucket_id = 'certificates'
  and (select app_private.current_user_has_role(
    array[
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
)
with check (
  bucket_id = 'certificates'
  and (select app_private.current_user_has_role(
    array[
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
);

drop policy if exists practice_evidence_authorized_access on storage.objects;
create policy practice_evidence_authorized_access
on storage.objects
for select
to authenticated
using (
  bucket_id = 'practice-evidence'
  and case
    when (storage.foldername(name))[1] ~ '^[0-9a-fA-F-]{36}$'
    then (
      select app_private.current_user_owns_enrollment(
        ((storage.foldername(name))[1])::uuid
      )
    ) or (
      select app_private.current_user_has_role(
        array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]
      )
    )
    else false
  end
);

drop policy if exists practice_evidence_staff_write on storage.objects;
create policy practice_evidence_staff_write
on storage.objects
for all
to authenticated
using (
  bucket_id = 'practice-evidence'
  and (select app_private.current_user_has_role(
    array[
      'tutor'::public.app_role,
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
)
with check (
  bucket_id = 'practice-evidence'
  and (select app_private.current_user_has_role(
    array[
      'tutor'::public.app_role,
      'administrador'::public.app_role,
      'superadministrador'::public.app_role
    ]
  ))
);

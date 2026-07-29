-- InmínerCampus
-- Complete the set of supporting indexes for foreign keys.

create index if not exists organization_members_invited_by_idx
  on public.organization_members (invited_by);

create index if not exists user_roles_assigned_by_idx
  on public.user_roles (assigned_by);

create index if not exists organizations_created_by_idx
  on public.organizations (created_by);

create index if not exists courses_created_by_idx
  on public.courses (created_by);

create index if not exists course_versions_created_by_idx
  on public.course_versions (created_by);

create index if not exists enrollments_created_by_idx
  on public.enrollments (created_by);

create index if not exists question_banks_created_by_idx
  on public.question_banks (created_by);

create index if not exists access_codes_course_version_id_idx
  on public.access_codes (course_version_id);

create index if not exists access_codes_used_by_idx
  on public.access_codes (used_by);

create index if not exists access_codes_revoked_by_idx
  on public.access_codes (revoked_by);

create index if not exists stripe_webhook_events_related_purchase_id_idx
  on public.stripe_webhook_events (related_purchase_id);

create index if not exists practice_sessions_created_by_idx
  on public.practice_sessions (created_by);

create index if not exists practice_attendance_validated_by_idx
  on public.practice_attendance (validated_by);

create index if not exists support_threads_enrollment_id_idx
  on public.support_threads (enrollment_id);

create index if not exists support_threads_lesson_id_idx
  on public.support_threads (lesson_id);

create index if not exists support_messages_sender_user_id_idx
  on public.support_messages (sender_user_id);

create index if not exists certificates_course_version_id_idx
  on public.certificates (course_version_id);

create index if not exists certificates_issued_by_idx
  on public.certificates (issued_by);

create index if not exists certificates_revoked_by_idx
  on public.certificates (revoked_by);

create index if not exists certificates_replaced_by_idx
  on public.certificates (replaced_by);

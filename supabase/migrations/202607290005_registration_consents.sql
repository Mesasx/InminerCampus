-- InmínerCampus
-- Capture the legal declarations made during account creation even when
-- email confirmation means there is not yet an authenticated browser session.

create or replace function app_private.capture_registration_consents()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  legal_version text;
begin
  legal_version := nullif(trim(new.raw_user_meta_data ->> 'legal_version'), '');

  if legal_version is not null
     and coalesce((new.raw_user_meta_data ->> 'accepted_legal')::boolean, false)
  then
    insert into public.consent_records (
      user_id,
      document_type,
      document_version,
      accepted,
      source,
      evidence
    )
    values
      (
        new.id,
        'privacy_policy',
        legal_version,
        true,
        'registration',
        jsonb_build_object('channel', 'web')
      ),
      (
        new.id,
        'terms_of_use',
        legal_version,
        true,
        'registration',
        jsonb_build_object('channel', 'web')
      );
  end if;

  return new;
end;
$$;

revoke all on function app_private.capture_registration_consents() from public;

drop trigger if exists on_auth_user_capture_registration_consents on auth.users;
create trigger on_auth_user_capture_registration_consents
  after insert on auth.users
  for each row execute function app_private.capture_registration_consents();

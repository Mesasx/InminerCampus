-- Bloquea nombre, apellidos y DNI/NIE en profiles una vez tienen un valor:
-- son datos que deben coincidir con el certificado emitido y no se pueden
-- corregir libremente desde el propio perfil. El teléfono sigue siendo
-- editable en todo momento.

begin;

create or replace function app_private.lock_profile_identity_fields()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if btrim(coalesce(old.first_name, '')) <> ''
    and new.first_name is distinct from old.first_name
  then
    raise exception 'El nombre no se puede modificar una vez guardado.';
  end if;

  if btrim(coalesce(old.last_name, '')) <> ''
    and new.last_name is distinct from old.last_name
  then
    raise exception 'Los apellidos no se pueden modificar una vez guardados.';
  end if;

  if old.dni is not null and new.dni is distinct from old.dni then
    raise exception 'El DNI/NIE no se puede modificar una vez guardado.';
  end if;

  return new;
end;
$$;

drop trigger if exists profiles_lock_identity_fields on public.profiles;
create trigger profiles_lock_identity_fields
before update on public.profiles
for each row execute function app_private.lock_profile_identity_fields();

commit;

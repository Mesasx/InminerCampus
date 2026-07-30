begin;

revoke update (status) on public.profiles from authenticated;

create or replace function public.admin_update_profile_status(
  p_profile_id uuid,
  p_status public.account_status
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not (select app_private.current_user_has_role(
    array['administrador', 'superadministrador']::public.app_role[]
  )) then
    raise exception 'Administrator access required';
  end if;

  update public.profiles
  set status = p_status
  where id = p_profile_id;
end;
$$;

revoke all on function public.admin_update_profile_status(
  uuid,
  public.account_status
) from public, anon;
grant execute on function public.admin_update_profile_status(
  uuid,
  public.account_status
) to authenticated;

commit;

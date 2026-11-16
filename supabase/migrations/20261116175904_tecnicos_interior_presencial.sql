-- La formación reglamentaria del grupo 5.3.a se imparte presencialmente.
-- El contenido digital del campus es material complementario.
begin;

update public.course_versions
set modality = 'in_person',
    accreditation_label = 'Programa preventivo presencial de 20 horas con apoyo digital',
    updated_at = now()
where id = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de'::uuid
  and course_id = (
    select id
    from public.courses
    where slug = 'tecnicos-titulados-actividades-extractivas-interior'
  );

do $$
begin
  if not exists (
    select 1
    from public.course_versions cv
    join public.courses c on c.id = cv.course_id
    where c.slug = 'tecnicos-titulados-actividades-extractivas-interior'
      and cv.id = '99de5e6c-318f-5bb9-91b4-c5b7a0b1f2de'::uuid
      and cv.modality = 'in_person'
  ) then
    raise exception 'El curso interior debe quedar registrado como presencial';
  end if;
end $$;

commit;

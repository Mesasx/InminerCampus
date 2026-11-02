begin;

-- Retira referencias editoriales que orientaban al alumno hacia una
-- diapositiva concreta. Los identificadores hacen la corrección idempotente y
-- evitan modificar preguntas distintas con textos parecidos.
do $$
declare
  v_affected integer;
begin
  update public.question_options
  set option_text = 'Memorizar literalmente todo el material'
  where id = 'e7447d7f-e76e-4375-9e9e-7e7c0d79bb26'::uuid;
  get diagnostics v_affected = row_count;
  if v_affected <> 1 then
    raise exception 'No se pudo sanear la opción ADM-20H-B6-Q15';
  end if;

  update public.questions
  set
    prompt = '¿Qué función preventiva tiene un manómetro?',
    explanation = 'El manómetro permite detectar condiciones de sobrepresión en los circuitos.'
  where id = 'e1125f27-a04a-43d7-8862-e12ed0a3d9ea'::uuid;
  get diagnostics v_affected = row_count;
  if v_affected <> 1 then
    raise exception 'No se pudo sanear la pregunta EB-20H-B4-Q02';
  end if;

  update public.questions
  set prompt = '¿Qué papel tienen los recursos digitales y las pruebas de InmínerCampus en esta formación reglada?'
  where id = '9aba220d-39b0-5ba7-a21c-cdcc05ae4fa2'::uuid;
  get diagnostics v_affected = row_count;
  if v_affected <> 1 then
    raise exception 'No se pudo sanear la pregunta del bloque 6 de técnicos de exterior';
  end if;
end
$$;

-- Separa la lectura del alumno y la del equipo interno. Esto permite que el
-- informe administrativo lea las explicaciones aun cuando la versión siga en
-- borrador, sin exponerlas a alumnos no matriculados.
drop policy if exists lesson_segment_notes_visible
  on public.lesson_segment_notes;
drop policy if exists lesson_segment_notes_enrolled_read
  on public.lesson_segment_notes;
drop policy if exists lesson_segment_notes_staff_read
  on public.lesson_segment_notes;

create policy lesson_segment_notes_enrolled_read
on public.lesson_segment_notes for select
to authenticated
using (
  approved
  and exists (
    select 1
    from public.lesson_audio_segments s
    join public.lessons l on l.id = s.lesson_id
    join public.course_modules m on m.id = l.module_id
    where s.id = segment_id
      and s.published
      and (select app_private.current_user_is_enrolled(m.course_version_id))
  )
);

create policy lesson_segment_notes_staff_read
on public.lesson_segment_notes for select
to authenticated
using (
  (select app_private.current_user_has_role(
    array[
      'tutor',
      'administrador',
      'superadministrador'
    ]::public.app_role[]
  ))
);

commit;

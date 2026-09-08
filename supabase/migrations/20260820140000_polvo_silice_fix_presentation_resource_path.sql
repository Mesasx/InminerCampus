-- InmínerCampus
-- Corrige el recurso "Presentación completa" del curso Polvo y Sílice
-- (versión superviviente cd155d2b): apuntaba al PDF antiguo de la
-- modalidad de 20 horas ya retirada. Ahora apunta al PDF definitivo
-- CursoSilice.pdf (50 páginas), subido bajo el prefijo propio de la
-- versión superviviente, ya cubierto por la política RLS estándar sin
-- necesidad de la excepción cruzada de prefijo.

update public.lesson_resources
set storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/resources/formacion-polvo-silice-presentacion-completa.pdf'
where kind = 'presentation'
  and lesson_id in (
    select l.id
    from public.lessons l
    join public.course_modules m on m.id = l.module_id
    where m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315'
  );

do $val$
declare
  wrong_count integer;
begin
  select count(*) into wrong_count
  from public.lesson_resources lr
  join public.lessons l on l.id = lr.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315'
    and lr.kind = 'presentation'
    and lr.storage_path <> 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/resources/formacion-polvo-silice-presentacion-completa.pdf';

  if wrong_count <> 0 then
    raise exception 'lesson_resources presentation path fix incomplete: % rows still wrong', wrong_count;
  end if;
end
$val$;

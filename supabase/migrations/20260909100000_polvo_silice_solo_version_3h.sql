-- InmínerCampus
-- El curso "Prevención frente al polvo y la sílice cristalina respirable" tenía
-- dos versiones: la 1 de 3 horas (publicada, 78 €, con sus seis cuestionarios) y
-- la 2 de 20 horas, retirada en agosto y nunca terminada —seis módulos con seis
-- lecciones sin cuestionarios, sin vídeos y sin materiales—.
--
-- Al estar en 'retired' no aparecía en el catálogo público (`fetchPublicCourses`
-- filtra por `course_versions.status = 'published'`), pero seguía saliendo en el
-- panel de administración y en el selector de duración del editor, así que se
-- elimina para que el curso tenga una sola oferta también puertas adentro.
--
-- La única matrícula que colgaba de ella era administrativa, de una cuenta
-- interna, sin empezar y con progreso cero. No había certificados, registros
-- internos de finalización, códigos de acceso, líneas de compra ni sesiones de
-- práctica apuntando a la versión, que son las referencias con `on delete
-- restrict`; el resto (módulos, lecciones, progreso) cae en cascada.
--
-- Idempotente: filtra por `duration_hours = 20` y `status = 'retired'`, de modo
-- que volver a aplicarla sobre una base ya corregida no borra nada y jamás puede
-- alcanzar a la versión de 3 horas.

begin;

delete from public.enrollments e
using public.course_versions cv
where cv.id = e.course_version_id
  and cv.course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7'
  and cv.duration_hours = 20
  and cv.status = 'retired'::public.course_version_status;

delete from public.course_versions
where course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7'
  and duration_hours = 20
  and status = 'retired'::public.course_version_status;

do $val$
declare
  versiones integer;
  publicadas integer;
begin
  select count(*) into versiones
  from public.course_versions
  where course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7';

  if versiones <> 1 then
    raise exception 'Polvo y Sílice debe quedar con una sola versión, hay %', versiones;
  end if;

  select count(*) into publicadas
  from public.course_versions
  where course_id = 'e1bc46f9-b878-4d86-94ee-75b744b0f8f7'
    and duration_hours = 3
    and status = 'published'::public.course_version_status;

  if publicadas <> 1 then
    raise exception 'La versión superviviente de Polvo y Sílice no es la de 3 h publicada';
  end if;
end;
$val$;

commit;

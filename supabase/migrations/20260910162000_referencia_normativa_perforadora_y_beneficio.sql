-- Perforadora y Establecimientos de beneficio quedaban clasificados en «Otros»
-- dentro del catálogo, no en «Minería».
--
-- `categoryOf` no dispone todavía de un campo de categoría real: aproxima por
-- la referencia normativa del campo `specialty`, y clasifica como minero todo
-- lo que cita una ITC 02.x. Estos dos cursos guardaban en `specialty` un rótulo
-- descriptivo («Formación preventiva del puesto», «Establecimientos de
-- beneficio») en vez de su referencia, así que caían al cajón de «Otros» pese a
-- ser formación ITC 02.1.02 como el resto.
--
-- Las referencias se toman de la portada de sus manuales maestros:
--   · Operador de perforadora / perforista → ITC 02.1.02 · ET 2003-1-10
--   · Operadores en establecimientos de beneficio → ITC 02.1.02 · ET 2004-1-10
--
-- Perforadora tenía además `accreditation_reference` a nulo en sus dos
-- versiones, de modo que su ficha no mostraba la norma aplicable ni generaba la
-- pregunta frecuente correspondiente.
begin;

update public.courses
set specialty = 'ITC 02.1.02 · ET 2003-1-10',
    updated_at = now()
where slug = 'operadores-perforacion-corte-exterior'
  and specialty is distinct from 'ITC 02.1.02 · ET 2003-1-10';

update public.courses
set specialty = 'ITC 02.1.02 · ET 2004-1-10',
    updated_at = now()
where slug = 'operadores-establecimientos-beneficio'
  and specialty is distinct from 'ITC 02.1.02 · ET 2004-1-10';

update public.course_versions cv
set accreditation_reference = 'ITC 02.1.02 · ET 2003-1-10',
    updated_at = now()
from public.courses c
where c.id = cv.course_id
  and c.slug = 'operadores-perforacion-corte-exterior'
  and cv.accreditation_reference is null;

commit;

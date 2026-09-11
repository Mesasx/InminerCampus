-- Modalidad del catálogo: ningún curso se imparte de forma presencial.
--
-- Todos los programas se cursan en el campus con prácticas asociadas, de modo
-- que la modalidad correcta es híbrida. Las dos excepciones son las formaciones
-- que se completan íntegramente en línea, sin prácticas: la de sílice y la de
-- STVH, que ya están declaradas como online y no se tocan.
--
-- Hoy sólo «Operadores en establecimientos de beneficio» figura como presencial,
-- en sus dos modalidades. Corregirlo es un cambio de etiqueta: la modalidad es
-- informativa y no gobierna ninguna lógica del campus. Las prácticas dependen
-- de `practice_required`, que se deja como está.
--
-- La modalidad que aparece en certificados y en líneas de compra es una
-- instantánea guardada aparte en el momento de emitirlas, así que ningún
-- documento ya entregado cambia por esto.
begin;

update public.course_versions cv
set modality = 'hybrid'
where cv.modality = 'in_person';

do $$
declare
  v_presenciales integer;
  v_silice text;
begin
  select count(*) into v_presenciales
  from public.course_versions
  where modality = 'in_person';

  if v_presenciales > 0 then
    raise exception 'Siguen quedando % versiones presenciales', v_presenciales;
  end if;

  -- La formación de sílice se queda en línea, que es como se imparte.
  select cv.modality into v_silice
  from public.course_versions cv
  join public.courses c on c.id = cv.course_id
  where c.slug = 'prevencion-polvo-silice-cristalina-respirable';

  if v_silice is distinct from 'online' then
    raise exception 'La formación de sílice debe seguir siendo online, y es %', v_silice;
  end if;
end $$;

commit;

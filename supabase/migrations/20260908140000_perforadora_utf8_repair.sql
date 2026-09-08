begin;

-- Los contenidos de perforadora se importaron con el texto ya codificado en
-- UTF-8 interpretado como Latin-1, de modo que sus acentos quedaron guardados
-- como «Ã³», «Ã¡», «Ã­», «Ã©» y «Ã±». Afecta a lo que ve el alumno: el nombre
-- de los bloques, el título de cada unidad y la ficha pública del curso.
--
-- Cada columna se repara solo si todavía arrastra la doble codificación, así
-- que volver a ejecutar la migración no altera nada y un texto ya correcto
-- —que Latin-1 no podría representar— nunca llega a convertirse.

create temporary view perforadora_version as
select cv.id
from public.course_versions cv
join public.courses c on c.id = cv.course_id
where c.slug = 'operadores-perforacion-corte-exterior';

update public.courses set
  title = case when title ~ '[ÃÂ]'
    then convert_from(convert_to(title, 'LATIN1'), 'UTF8') else title end,
  short_description = case when short_description ~ '[ÃÂ]'
    then convert_from(convert_to(short_description, 'LATIN1'), 'UTF8')
    else short_description end,
  description = case when description ~ '[ÃÂ]'
    then convert_from(convert_to(description, 'LATIN1'), 'UTF8')
    else description end
where slug = 'operadores-perforacion-corte-exterior';

update public.course_modules cm set
  title = convert_from(convert_to(cm.title, 'LATIN1'), 'UTF8')
where cm.course_version_id in (select id from perforadora_version)
  and cm.title ~ '[ÃÂ]';

update public.lessons l set
  title = convert_from(convert_to(l.title, 'LATIN1'), 'UTF8')
from public.course_modules cm
where cm.id = l.module_id
  and cm.course_version_id in (select id from perforadora_version)
  and l.title ~ '[ÃÂ]';

update public.lesson_audio_segments seg set
  title = case when seg.title ~ '[ÃÂ]'
    then convert_from(convert_to(seg.title, 'LATIN1'), 'UTF8') else seg.title end,
  narration_text = case when seg.narration_text ~ '[ÃÂ]'
    then convert_from(convert_to(seg.narration_text, 'LATIN1'), 'UTF8')
    else seg.narration_text end
from public.lessons l
join public.course_modules cm on cm.id = l.module_id
where l.id = seg.lesson_id
  and cm.course_version_id in (select id from perforadora_version)
  and (seg.title ~ '[ÃÂ]' or seg.narration_text ~ '[ÃÂ]');

update public.lesson_segment_slides sl set
  title = case when sl.title ~ '[ÃÂ]'
    then convert_from(convert_to(sl.title, 'LATIN1'), 'UTF8') else sl.title end,
  alt_text = case when sl.alt_text ~ '[ÃÂ]'
    then convert_from(convert_to(sl.alt_text, 'LATIN1'), 'UTF8') else sl.alt_text end,
  body = case when sl.body ~ '[ÃÂ]'
    then convert_from(convert_to(sl.body, 'LATIN1'), 'UTF8') else sl.body end
from public.lesson_audio_segments seg
join public.lessons l on l.id = seg.lesson_id
join public.course_modules cm on cm.id = l.module_id
where seg.id = sl.segment_id
  and cm.course_version_id in (select id from perforadora_version)
  and (sl.title ~ '[ÃÂ]' or sl.alt_text ~ '[ÃÂ]' or sl.body ~ '[ÃÂ]');

update public.lesson_segment_notes n set
  summary = case when n.summary ~ '[ÃÂ]'
    then convert_from(convert_to(n.summary, 'LATIN1'), 'UTF8') else n.summary end,
  stop_criterion = case when n.stop_criterion ~ '[ÃÂ]'
    then convert_from(convert_to(n.stop_criterion, 'LATIN1'), 'UTF8')
    else n.stop_criterion end
from public.lesson_audio_segments seg
join public.lessons l on l.id = seg.lesson_id
join public.course_modules cm on cm.id = l.module_id
where seg.id = n.segment_id
  and cm.course_version_id in (select id from perforadora_version)
  and (n.summary ~ '[ÃÂ]' or n.stop_criterion ~ '[ÃÂ]');

commit;

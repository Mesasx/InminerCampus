-- InmínerCampus
-- Corrige el material visual del curso Polvo y Sílice (versión superviviente
-- cd155d2b): las 50 diapositivas mostradas en cada parte todavía eran las
-- reutilizadas del deck antiguo de 20 horas, con "20 HORAS" grabado en el
-- pie de cada imagen. Se sustituyen por las 50 páginas renderizadas desde
-- CursoSilice.pdf (deck definitivo, sin esa referencia), subidas bajo el
-- propio prefijo de cd155d2b. El recurso "Presentación completa" (PDF) ya
-- se corrigió en la migración 20260820140000 y también vive ahora bajo el
-- propio prefijo.
--
-- Con las diapositivas, el PDF y los audios ya nativos de cd155d2b, la
-- excepción de RLS añadida en 20260820090000 para leer el prefijo antiguo
-- c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/% deja de ser necesaria. Se retira,
-- devolviendo la política a su forma anterior (base + excepción de
-- course-1/5h) para no dejar una concesión de acceso sin uso.

update public.lesson_segment_slides s
set image_storage_path = v.new_path
from (values
  ('9212a860-3fba-45cf-9418-0e25322d2930'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-01/slide-01.jpg'),
  ('1327fe65-5b4e-4af0-90e5-eef42b93bd80'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-02/slide-01.jpg'),
  ('775c6f23-3126-48a7-8efb-c5efa07cc799'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-03/slide-01.jpg'),
  ('6f2f2fe4-3884-4a2a-a208-2faa367c8d02'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-04/slide-01.jpg'),
  ('692226a1-ae39-4cd6-8b75-7a48676653a5'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-05/slide-01.jpg'),
  ('147b0a7a-edf7-46d5-89ef-6fca6bd745c4'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-06/slide-01.jpg'),
  ('07fa3a26-eb0a-40e5-b5fb-ed207859c117'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-07/slide-01.jpg'),
  ('ead51b6e-28be-47ff-b9b1-354d078e853c'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-08/slide-01.jpg'),
  ('960f2b08-1848-4540-98df-e8d1aa1f7f5d'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-09/slide-01.jpg'),
  ('68b7dc42-fc52-40d3-91cb-5a778497205b'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-1/audio-1-10/slide-01.jpg'),
  ('d843a759-41f5-449b-bdc8-078ca1bd1e66'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-01/slide-01.jpg'),
  ('05f813fd-38c2-4a22-a4b2-89003ff14e6d'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-02/slide-01.jpg'),
  ('d2b0cd4c-7fd4-4b19-b513-ab7313d847e6'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-03/slide-01.jpg'),
  ('075784de-2db2-444e-a7cb-f028fe9d1e8e'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-04/slide-01.jpg'),
  ('64af9e0b-cf2e-4e60-98d7-fcda1f9627ad'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-05/slide-01.jpg'),
  ('01e1ac20-500d-477e-adfc-c61397eb657c'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-06/slide-01.jpg'),
  ('7747a074-b020-472f-ad94-81853ca22a93'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-07/slide-01.jpg'),
  ('91ba067b-ccec-4ba1-bbcf-fd6286dd00da'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-08/slide-01.jpg'),
  ('99c8945f-9deb-4e15-9944-a7307c66a15d'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-09/slide-01.jpg'),
  ('58958a71-e777-44d1-9d67-8a335076a5ef'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-2/audio-2-10/slide-01.jpg'),
  ('fdc342e9-11c2-4b86-a3a1-5228de3bf479'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-01/slide-01.jpg'),
  ('c7b055cd-b5be-413c-8bf6-897cb4a2f546'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-02/slide-01.jpg'),
  ('3926cd59-a18b-46dd-9b1f-45760b322a6c'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-03/slide-01.jpg'),
  ('1ebe4dbc-79fd-4218-9a08-f6a194d44dcd'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-04/slide-01.jpg'),
  ('1eb0f936-df98-4065-9e91-69baeb399ae3'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-05/slide-01.jpg'),
  ('b1f44cfa-e948-4d21-8489-976e8ebd2c43'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-06/slide-01.jpg'),
  ('247a5ce5-aa96-41fe-ad4a-5a16eb79530f'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-07/slide-01.jpg'),
  ('46a818dd-0d43-49b9-9601-003a86306015'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-08/slide-01.jpg'),
  ('1e68fb8b-92a7-4919-94f3-42d5f051e7cb'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-09/slide-01.jpg'),
  ('722099b5-6e67-4f45-9179-34aed8584930'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-3/audio-3-10/slide-01.jpg'),
  ('61144895-75d9-4338-92ee-2e6a2bbdc3fd'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-01/slide-01.jpg'),
  ('b110bd41-663f-4aca-a417-163a517d2166'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-02/slide-01.jpg'),
  ('0682d8a5-3c07-460d-a2ae-390b2da66ba4'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-03/slide-01.jpg'),
  ('cbba34ce-f5a2-4859-8eb3-a9dde8729df3'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-04/slide-01.jpg'),
  ('9617add8-03d0-4f41-9358-7b2fbbf541b9'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-05/slide-01.jpg'),
  ('78bf4f11-e2fa-47d2-87db-79f020f00afb'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-06/slide-01.jpg'),
  ('9b80d683-a81b-4401-9858-b6c05f146cc0'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-07/slide-01.jpg'),
  ('7af3924f-18d6-46b5-9bdf-cc11409fe510'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-08/slide-01.jpg'),
  ('7f535354-e8b1-4c9a-b66f-73e6147d0476'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-09/slide-01.jpg'),
  ('a7af8b7c-3864-485a-843e-0965e8c291f7'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-4/audio-4-10/slide-01.jpg'),
  ('1bf30edd-740e-4f9f-8ed4-b926fce0670d'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-01/slide-01.jpg'),
  ('34fc1ea1-657f-4ffa-a839-edc8bfeb62f0'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-02/slide-01.jpg'),
  ('24c591fb-fbb5-4805-b0f3-3e12d07debfe'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-03/slide-01.jpg'),
  ('9e4992d8-b1d8-4581-84bc-0b176fc413c4'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-04/slide-01.jpg'),
  ('e09ad3ff-e66f-4c6a-b9d7-47a83b7a3aac'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-05/slide-01.jpg'),
  ('f649ca3b-4b87-4b11-9a47-30a2ebbff1d0'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-06/slide-01.jpg'),
  ('5aa67069-1796-4c65-9b48-bacccec1b5a8'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-07/slide-01.jpg'),
  ('32510752-56f6-4c60-8f5c-56ec028b1c87'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-08/slide-01.jpg'),
  ('81a87be6-80d8-4d8b-848a-468ca1feeee6'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-09/slide-01.jpg'),
  ('3c573ab6-5d5d-45c7-81e7-abd819c7d0ea'::uuid, 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/slides/course-deck-20260820-cursosilice/block-5/audio-5-10/slide-01.jpg')
) as v(segment_id, new_path)
where s.segment_id = v.segment_id;

drop policy if exists course_materials_enrolled_read on storage.objects;

create policy course_materials_enrolled_read
on storage.objects
for select
to authenticated
using (
  bucket_id = 'course-materials'
  and (
    (
      (storage.foldername(name))[1] ~ '^[0-9a-fA-F-]{36}$'
      and (
        (select app_private.current_user_is_enrolled(((storage.foldername(name))[1])::uuid))
        or (select app_private.current_user_has_role(array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]))
      )
    )
    or (
      (
        name like 'course-1/5h/%'
        or name like 'course-1/5h-v2/%'
      )
      and (
        exists (
          select 1
          from public.course_versions cv
          join public.courses c on c.id = cv.course_id
          where c.slug = 'operador-maquinaria-arranque-carga-viales'
            and cv.duration_hours = 5
            and cv.status = 'published'
            and (select app_private.current_user_is_enrolled(cv.id))
        )
        or (select app_private.current_user_has_role(array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]))
      )
    )
  )
);

do $val$
declare
  wrong_slides integer;
  wrong_audio integer;
  wrong_resources integer;
begin
  select count(*) into wrong_slides
  from public.lesson_segment_slides sl
  join public.lesson_audio_segments s on s.id = sl.segment_id
  join public.lessons l on l.id = s.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315'
    and l.active = true
    and sl.image_storage_path not like 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/%';

  select count(*) into wrong_audio
  from public.lesson_audio_segments s
  join public.lessons l on l.id = s.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315'
    and l.active = true
    and s.audio_storage_path not like 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/%';

  select count(*) into wrong_resources
  from public.lesson_resources lr
  join public.lessons l on l.id = lr.lesson_id
  join public.course_modules m on m.id = l.module_id
  where m.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315'
    and lr.storage_path not like 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/%';

  if wrong_slides <> 0 or wrong_audio <> 0 or wrong_resources <> 0 then
    raise exception 'polvo-silice own-prefix migration incomplete: slides=%, audio=%, resources=%', wrong_slides, wrong_audio, wrong_resources;
  end if;
end
$val$;

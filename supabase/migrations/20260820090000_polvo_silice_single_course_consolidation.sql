-- Consolidacion definitiva del curso Polvo y Silice: un unico course_version (antes "5h", id cd155d2b-1c6d-4cdd-8f40-84c830f75315)
-- pasa a ser la version activa (3h aprox, 78 EUR + IVA, 5 bloques x 10 partes, 50 preguntas definitivas).
-- La version "20h" (c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24) se marca retired, conservando integramente sus datos historicos.
-- Las diapositivas y explicaciones detalladas (ya integradas en la version 20h en una migracion anterior)
-- se copian a los 50 segmentos de audio de la version 5h; el audio se reasigna a los cortos (14-21s) ya
-- existentes en la propia version 5h, eligiendo por contenido el mas afin para cada una de las 50 partes.

alter table public.course_versions add column if not exists renewal_interval_months integer;

-- Permitir que los alumnos matriculados en la version superviviente (antes "5h") lean las diapositivas
-- y el PDF combinado que siguen almacenados fisicamente bajo el prefijo de la version "20h" (misma
-- explotacion de archivo, sin duplicar).
alter policy "course_materials_enrolled_read" on storage.objects using (
  ((bucket_id = 'course-materials'::text) AND ((((storage.foldername(name))[1] ~ '^[0-9a-fA-F-]{36}$'::text) AND (( SELECT app_private.current_user_is_enrolled(((storage.foldername(objects.name))[1])::uuid) AS current_user_is_enrolled) OR ( SELECT app_private.current_user_has_role(ARRAY['tutor'::app_role, 'administrador'::app_role, 'superadministrador'::app_role]) AS current_user_has_role))) OR (((name ~~ 'course-1/5h/%'::text) OR (name ~~ 'course-1/5h-v2/%'::text)) AND ((EXISTS ( SELECT 1
   FROM (course_versions cv
     JOIN courses c ON ((c.id = cv.course_id)))
  WHERE ((c.slug = 'operador-maquinaria-arranque-carga-viales'::text) AND (cv.duration_hours = 5) AND (cv.status = 'published'::course_version_status) AND ( SELECT app_private.current_user_is_enrolled(cv.id) AS current_user_is_enrolled)))) OR ( SELECT app_private.current_user_has_role(ARRAY['tutor'::app_role, 'administrador'::app_role, 'superadministrador'::app_role]) AS current_user_has_role))) OR ((name ~~ 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/%') AND ((( SELECT app_private.current_user_is_enrolled('cd155d2b-1c6d-4cdd-8f40-84c830f75315'::uuid))) OR ( SELECT app_private.current_user_has_role(ARRAY['tutor'::app_role, 'administrador'::app_role, 'superadministrador'::app_role]))))))
);

-- 1) Retitular y reasignar audio/diapositiva/explicacion en los 50 segmentos definitivos (bloques 1-5)
update public.lesson_audio_segments set title = 'Que es el polvo', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-01.mp3', duration_seconds = 14 where id = '9212a860-3fba-45cf-9418-0e25322d2930';
update public.lesson_audio_segments set title = 'Que es la silice cristalina', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-02.mp3', duration_seconds = 14 where id = '1327fe65-5b4e-4af0-90e5-eef42b93bd80';
update public.lesson_audio_segments set title = 'Cuando existe riesgo de exposicion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-04.mp3', duration_seconds = 14 where id = '775c6f23-3126-48a7-8efb-c5efa07cc799';
update public.lesson_audio_segments set title = 'Procesos que pueden generar polvo', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-01.mp3', duration_seconds = 21 where id = '6f2f2fe4-3884-4a2a-a208-2faa367c8d02';
update public.lesson_audio_segments set title = 'Fracciones inhalable toracica y respirable', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-03.mp3', duration_seconds = 14 where id = '692226a1-ae39-4cd6-8b75-7a48676653a5';
update public.lesson_audio_segments set title = 'Por que el polvo fino es mas peligroso', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-06.mp3', duration_seconds = 13 where id = '147b0a7a-edf7-46d5-89ef-6fca6bd745c4';
update public.lesson_audio_segments set title = 'Efectos iniciales y enfermedades', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-07.mp3', duration_seconds = 17 where id = '07fa3a26-eb0a-40e5-b5fb-ed207859c117';
update public.lesson_audio_segments set title = 'La silicosis', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-08.mp3', duration_seconds = 16 where id = 'ead51b6e-28be-47ff-b9b1-354d078e853c';
update public.lesson_audio_segments set title = 'Formas de evolucion de la silicosis', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-09.mp3', duration_seconds = 15 where id = '960f2b08-1848-4540-98df-e8d1aa1f7f5d';
update public.lesson_audio_segments set title = 'Factores que favorecen el polvo', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-1/audio/part-1-10.mp3', duration_seconds = 15 where id = '68b7dc42-fc52-40d3-91cb-5a778497205b';
update public.lesson_audio_segments set title = 'Normativa principal aplicable', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-03.mp3', duration_seconds = 16 where id = 'd843a759-41f5-449b-bdc8-078ca1bd1e66';
update public.lesson_audio_segments set title = 'La silice como agente cancerigeno', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-01.mp3', duration_seconds = 12 where id = '05f813fd-38c2-4a22-a4b2-89003ff14e6d';
update public.lesson_audio_segments set title = 'Valores limite de exposicion diaria', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-04.mp3', duration_seconds = 14 where id = 'd2b0cd4c-7fd4-4b19-b513-ab7313d847e6';
update public.lesson_audio_segments set title = 'El limite no es un objetivo', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-04.mp3', duration_seconds = 14 where id = '075784de-2db2-444e-a7cb-f028fe9d1e8e';
update public.lesson_audio_segments set title = 'Identificacion de materiales y tareas', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-01.mp3', duration_seconds = 16 where id = '64af9e0b-cf2e-4e60-98d7-fcda1f9627ad';
update public.lesson_audio_segments set title = 'Muestreo personal en la zona de respiracion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-06.mp3', duration_seconds = 17 where id = '01e1ac20-500d-477e-adfc-c61397eb657c';
update public.lesson_audio_segments set title = 'Duracion y representatividad de la muestra', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-07.mp3', duration_seconds = 14 where id = '7747a074-b020-472f-ad94-81853ca22a93';
update public.lesson_audio_segments set title = 'Frecuencia de las mediciones', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-08.mp3', duration_seconds = 14 where id = '91ba067b-ccec-4ba1-bbcf-fd6286dd00da';
update public.lesson_audio_segments set title = 'Revision de la evaluacion de riesgos', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-09.mp3', duration_seconds = 14 where id = '99c8945f-9deb-4e15-9944-a7307c66a15d';
update public.lesson_audio_segments set title = 'Informacion individual sobre la exposicion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-10.mp3', duration_seconds = 15 where id = '58958a71-e777-44d1-9d67-8a335076a5ef';
update public.lesson_audio_segments set title = 'Jerarquia de medidas preventivas', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-05.mp3', duration_seconds = 16 where id = 'fdc342e9-11c2-4b86-a3a1-5228de3bf479';
update public.lesson_audio_segments set title = 'Sustitucion y modificacion del proceso', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-01.mp3', duration_seconds = 14 where id = 'c7b055cd-b5be-413c-8bf6-897cb4a2f546';
update public.lesson_audio_segments set title = 'Confinamiento y cerramientos', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-02.mp3', duration_seconds = 15 where id = '3926cd59-a18b-46dd-9b1f-45760b322a6c';
update public.lesson_audio_segments set title = 'Cabinas cerradas y presurizadas', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-02.mp3', duration_seconds = 15 where id = '1ebe4dbc-79fd-4218-9a08-f6a194d44dcd';
update public.lesson_audio_segments set title = 'Control por via humeda', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-03.mp3', duration_seconds = 14 where id = '1eb0f936-df98-4065-9e91-69baeb399ae3';
update public.lesson_audio_segments set title = 'Captacion y aspiracion localizada', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-06.mp3', duration_seconds = 16 where id = 'b1f44cfa-e948-4d21-8489-976e8ebd2c43';
update public.lesson_audio_segments set title = 'Pistas transporte y acopios', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-07.mp3', duration_seconds = 15 where id = '247a5ce5-aa96-41fe-ad4a-5a16eb79530f';
update public.lesson_audio_segments set title = 'Limpieza segura', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-08.mp3', duration_seconds = 15 where id = '46a818dd-0d43-49b9-9601-003a86306015';
update public.lesson_audio_segments set title = 'Mantenimiento de las medidas de control', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-09.mp3', duration_seconds = 13 where id = '1e68fb8b-92a7-4919-94f3-42d5f051e7cb';
update public.lesson_audio_segments set title = 'Exposicion accidental o no regular', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-10.mp3', duration_seconds = 14 where id = '722099b5-6e67-4f45-9179-34aed8584930';
update public.lesson_audio_segments set title = 'Cuando utilizar proteccion respiratoria', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-05.mp3', duration_seconds = 14 where id = '61144895-75d9-4338-92ee-2e6a2bbdc3fd';
update public.lesson_audio_segments set title = 'Seleccion del equipo adecuado', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-05.mp3', duration_seconds = 14 where id = 'b110bd41-663f-4aca-a417-163a517d2166';
update public.lesson_audio_segments set title = 'Ajuste y estanqueidad facial', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-05.mp3', duration_seconds = 14 where id = '0682d8a5-3c07-460d-a2ae-390b2da66ba4';
update public.lesson_audio_segments set title = 'Colocacion retirada y conservacion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-05.mp3', duration_seconds = 14 where id = 'cbba34ce-f5a2-4859-8eb3-a9dde8729df3';
update public.lesson_audio_segments set title = 'Higiene personal', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-05.mp3', duration_seconds = 14 where id = '9617add8-03d0-4f41-9358-7b2fbbf541b9';
update public.lesson_audio_segments set title = 'Ropa de trabajo y descontaminacion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-06.mp3', duration_seconds = 14 where id = '78bf4f11-e2fa-47d2-87db-79f020f00afb';
update public.lesson_audio_segments set title = 'Vigilancia especifica de la salud', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-07.mp3', duration_seconds = 17 where id = '9b80d683-a81b-4401-9858-b6c05f146cc0';
update public.lesson_audio_segments set title = 'Historial de exposicion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-08.mp3', duration_seconds = 14 where id = '7af3924f-18d6-46b5-9bdf-cc11409fe510';
update public.lesson_audio_segments set title = 'Deteccion y comunicacion de fallos', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-09.mp3', duration_seconds = 14 where id = '7f535354-e8b1-4c9a-b66f-73e6147d0476';
update public.lesson_audio_segments set title = 'Actuacion ante sintomas o sospecha', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-10.mp3', duration_seconds = 17 where id = 'a7af8b7c-3864-485a-843e-0965e8c291f7';
update public.lesson_audio_segments set title = 'Documentacion preventiva', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-05.mp3', duration_seconds = 14 where id = '1bf30edd-740e-4f9f-8ed4-b926fce0670d';
update public.lesson_audio_segments set title = 'Fichas individualizadas de medicion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-03.mp3', duration_seconds = 15 where id = '34fc1ea1-657f-4ffa-a839-edc8bfeb62f0';
update public.lesson_audio_segments set title = 'Comunicacion de resultados', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-4/audio/part-4-04.mp3', duration_seconds = 15 where id = '24c591fb-fbb5-4805-b0f3-3e12d07debfe';
update public.lesson_audio_segments set title = 'Comunicacion de enfermedades', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-3/audio/part-3-02.mp3', duration_seconds = 15 where id = '9e4992d8-b1d8-4581-84bc-0b176fc413c4';
update public.lesson_audio_segments set title = 'Informacion que debe recibir el trabajador', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-2/audio/part-2-10.mp3', duration_seconds = 15 where id = 'e09ad3ff-e66f-4c6a-b9d7-47a83b7a3aac';
update public.lesson_audio_segments set title = 'Formacion teorica y practica', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-06.mp3', duration_seconds = 16 where id = 'f649ca3b-4b87-4b11-9a47-30a2ebbff1d0';
update public.lesson_audio_segments set title = 'Periodicidad anual obligatoria', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-07.mp3', duration_seconds = 13 where id = '5aa67069-1796-4c65-9b48-bacccec1b5a8';
update public.lesson_audio_segments set title = 'Consulta y participacion', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-08.mp3', duration_seconds = 15 where id = '32510752-56f6-4c60-8f5c-56ec028b1c87';
update public.lesson_audio_segments set title = 'Comprobacion antes de empezar', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-09.mp3', duration_seconds = 14 where id = '81a87be6-80d8-4d8b-848a-468ca1feeee6';
update public.lesson_audio_segments set title = 'Compromiso preventivo diario', audio_storage_path = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315/block-5/audio/part-5-10.mp3', duration_seconds = 17 where id = '3c573ab6-5d5d-45c7-81e7-abd819c7d0ea';

-- 2) Sustituir las diapositivas (limpiar filas placeholder sin imagen, insertar una diapositiva definitiva por parte)
delete from public.lesson_segment_slides where segment_id in ('9212a860-3fba-45cf-9418-0e25322d2930', '1327fe65-5b4e-4af0-90e5-eef42b93bd80', '775c6f23-3126-48a7-8efb-c5efa07cc799', '6f2f2fe4-3884-4a2a-a208-2faa367c8d02', '692226a1-ae39-4cd6-8b75-7a48676653a5', '147b0a7a-edf7-46d5-89ef-6fca6bd745c4', '07fa3a26-eb0a-40e5-b5fb-ed207859c117', 'ead51b6e-28be-47ff-b9b1-354d078e853c', '960f2b08-1848-4540-98df-e8d1aa1f7f5d', '68b7dc42-fc52-40d3-91cb-5a778497205b', 'd843a759-41f5-449b-bdc8-078ca1bd1e66', '05f813fd-38c2-4a22-a4b2-89003ff14e6d', 'd2b0cd4c-7fd4-4b19-b513-ab7313d847e6', '075784de-2db2-444e-a7cb-f028fe9d1e8e', '64af9e0b-cf2e-4e60-98d7-fcda1f9627ad', '01e1ac20-500d-477e-adfc-c61397eb657c', '7747a074-b020-472f-ad94-81853ca22a93', '91ba067b-ccec-4ba1-bbcf-fd6286dd00da', '99c8945f-9deb-4e15-9944-a7307c66a15d', '58958a71-e777-44d1-9d67-8a335076a5ef', 'fdc342e9-11c2-4b86-a3a1-5228de3bf479', 'c7b055cd-b5be-413c-8bf6-897cb4a2f546', '3926cd59-a18b-46dd-9b1f-45760b322a6c', '1ebe4dbc-79fd-4218-9a08-f6a194d44dcd', '1eb0f936-df98-4065-9e91-69baeb399ae3', 'b1f44cfa-e948-4d21-8489-976e8ebd2c43', '247a5ce5-aa96-41fe-ad4a-5a16eb79530f', '46a818dd-0d43-49b9-9601-003a86306015', '1e68fb8b-92a7-4919-94f3-42d5f051e7cb', '722099b5-6e67-4f45-9179-34aed8584930', '61144895-75d9-4338-92ee-2e6a2bbdc3fd', 'b110bd41-663f-4aca-a417-163a517d2166', '0682d8a5-3c07-460d-a2ae-390b2da66ba4', 'cbba34ce-f5a2-4859-8eb3-a9dde8729df3', '9617add8-03d0-4f41-9358-7b2fbbf541b9', '78bf4f11-e2fa-47d2-87db-79f020f00afb', '9b80d683-a81b-4401-9858-b6c05f146cc0', '7af3924f-18d6-46b5-9bdf-cc11409fe510', '7f535354-e8b1-4c9a-b66f-73e6147d0476', 'a7af8b7c-3864-485a-843e-0965e8c291f7', '1bf30edd-740e-4f9f-8ed4-b926fce0670d', '34fc1ea1-657f-4ffa-a839-edc8bfeb62f0', '24c591fb-fbb5-4805-b0f3-3e12d07debfe', '9e4992d8-b1d8-4581-84bc-0b176fc413c4', 'e09ad3ff-e66f-4c6a-b9d7-47a83b7a3aac', 'f649ca3b-4b87-4b11-9a47-30a2ebbff1d0', '5aa67069-1796-4c65-9b48-bacccec1b5a8', '32510752-56f6-4c60-8f5c-56ec028b1c87', '81a87be6-80d8-4d8b-848a-468ca1feeee6', '3c573ab6-5d5d-45c7-81e7-abd819c7d0ea');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('9212a860-3fba-45cf-9418-0e25322d2930', 1, 'Que es el polvo', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-01/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('1327fe65-5b4e-4af0-90e5-eef42b93bd80', 1, 'Que es la silice cristalina', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-02/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('775c6f23-3126-48a7-8efb-c5efa07cc799', 1, 'Cuando existe riesgo de exposicion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-03/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('6f2f2fe4-3884-4a2a-a208-2faa367c8d02', 1, 'Procesos que pueden generar polvo', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-04/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('692226a1-ae39-4cd6-8b75-7a48676653a5', 1, 'Fracciones inhalable toracica y respirable', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-05/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('147b0a7a-edf7-46d5-89ef-6fca6bd745c4', 1, 'Por que el polvo fino es mas peligroso', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-06/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('07fa3a26-eb0a-40e5-b5fb-ed207859c117', 1, 'Efectos iniciales y enfermedades', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-07/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('ead51b6e-28be-47ff-b9b1-354d078e853c', 1, 'La silicosis', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-08/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('960f2b08-1848-4540-98df-e8d1aa1f7f5d', 1, 'Formas de evolucion de la silicosis', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-09/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('68b7dc42-fc52-40d3-91cb-5a778497205b', 1, 'Factores que favorecen el polvo', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-1/audio-1-10/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('d843a759-41f5-449b-bdc8-078ca1bd1e66', 1, 'Normativa principal aplicable', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-01/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('05f813fd-38c2-4a22-a4b2-89003ff14e6d', 1, 'La silice como agente cancerigeno', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-02/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('d2b0cd4c-7fd4-4b19-b513-ab7313d847e6', 1, 'Valores limite de exposicion diaria', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-03/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('075784de-2db2-444e-a7cb-f028fe9d1e8e', 1, 'El limite no es un objetivo', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-04/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('64af9e0b-cf2e-4e60-98d7-fcda1f9627ad', 1, 'Identificacion de materiales y tareas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-05/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('01e1ac20-500d-477e-adfc-c61397eb657c', 1, 'Muestreo personal en la zona de respiracion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-06/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('7747a074-b020-472f-ad94-81853ca22a93', 1, 'Duracion y representatividad de la muestra', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-07/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('91ba067b-ccec-4ba1-bbcf-fd6286dd00da', 1, 'Frecuencia de las mediciones', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-08/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('99c8945f-9deb-4e15-9944-a7307c66a15d', 1, 'Revision de la evaluacion de riesgos', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-09/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('58958a71-e777-44d1-9d67-8a335076a5ef', 1, 'Informacion individual sobre la exposicion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-2/audio-2-10/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('fdc342e9-11c2-4b86-a3a1-5228de3bf479', 1, 'Jerarquia de medidas preventivas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-01/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('c7b055cd-b5be-413c-8bf6-897cb4a2f546', 1, 'Sustitucion y modificacion del proceso', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-02/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('3926cd59-a18b-46dd-9b1f-45760b322a6c', 1, 'Confinamiento y cerramientos', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-03/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('1ebe4dbc-79fd-4218-9a08-f6a194d44dcd', 1, 'Cabinas cerradas y presurizadas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-04/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('1eb0f936-df98-4065-9e91-69baeb399ae3', 1, 'Control por via humeda', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-05/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('b1f44cfa-e948-4d21-8489-976e8ebd2c43', 1, 'Captacion y aspiracion localizada', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-06/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('247a5ce5-aa96-41fe-ad4a-5a16eb79530f', 1, 'Pistas transporte y acopios', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-07/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('46a818dd-0d43-49b9-9601-003a86306015', 1, 'Limpieza segura', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-08/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('1e68fb8b-92a7-4919-94f3-42d5f051e7cb', 1, 'Mantenimiento de las medidas de control', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-09/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('722099b5-6e67-4f45-9179-34aed8584930', 1, 'Exposicion accidental o no regular', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-3/audio-3-10/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('61144895-75d9-4338-92ee-2e6a2bbdc3fd', 1, 'Cuando utilizar proteccion respiratoria', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-01/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('b110bd41-663f-4aca-a417-163a517d2166', 1, 'Seleccion del equipo adecuado', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-02/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('0682d8a5-3c07-460d-a2ae-390b2da66ba4', 1, 'Ajuste y estanqueidad facial', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-03/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('cbba34ce-f5a2-4859-8eb3-a9dde8729df3', 1, 'Colocacion retirada y conservacion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-04/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('9617add8-03d0-4f41-9358-7b2fbbf541b9', 1, 'Higiene personal', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-05/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('78bf4f11-e2fa-47d2-87db-79f020f00afb', 1, 'Ropa de trabajo y descontaminacion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-06/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('9b80d683-a81b-4401-9858-b6c05f146cc0', 1, 'Vigilancia especifica de la salud', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-07/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('7af3924f-18d6-46b5-9bdf-cc11409fe510', 1, 'Historial de exposicion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-08/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('7f535354-e8b1-4c9a-b66f-73e6147d0476', 1, 'Deteccion y comunicacion de fallos', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-09/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('a7af8b7c-3864-485a-843e-0965e8c291f7', 1, 'Actuacion ante sintomas o sospecha', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-4/audio-4-10/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('1bf30edd-740e-4f9f-8ed4-b926fce0670d', 1, 'Documentacion preventiva', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-01/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('34fc1ea1-657f-4ffa-a839-edc8bfeb62f0', 1, 'Fichas individualizadas de medicion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-02/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('24c591fb-fbb5-4805-b0f3-3e12d07debfe', 1, 'Comunicacion de resultados', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-03/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('9e4992d8-b1d8-4581-84bc-0b176fc413c4', 1, 'Comunicacion de enfermedades', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-04/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('e09ad3ff-e66f-4c6a-b9d7-47a83b7a3aac', 1, 'Informacion que debe recibir el trabajador', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-05/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('f649ca3b-4b87-4b11-9a47-30a2ebbff1d0', 1, 'Formacion teorica y practica', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-06/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('5aa67069-1796-4c65-9b48-bacccec1b5a8', 1, 'Periodicidad anual obligatoria', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-07/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('32510752-56f6-4c60-8f5c-56ec028b1c87', 1, 'Consulta y participacion', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-08/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('81a87be6-80d8-4d8b-848a-468ca1feeee6', 1, 'Comprobacion antes de empezar', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-09/slide-01.jpg', 'course-deck-20260819-definitiva');
insert into public.lesson_segment_slides (segment_id, position, title, image_storage_path, source_label) values ('3c573ab6-5d5d-45c7-81e7-abd819c7d0ea', 1, 'Compromiso preventivo diario', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/slides/course-deck-20260819-definitiva/block-5/audio-5-10/slide-01.jpg', 'course-deck-20260819-definitiva');

-- 3) Sustituir las explicaciones detalladas (lesson_segment_notes.summary) por el contenido definitivo
update public.lesson_segment_notes set summary = $q1$Objetivo

Definir el polvo como aerosol sólido y distinguir peligro, emisión y exposición.

Explicación detallada

El polvo es materia sólida particulada y dispersa en la atmósfera, generada por procesos mecánicos o por el movimiento del aire. En minería aparece en numerosas operaciones y puede convertirse en un agente químico peligroso para la salud. En una explotación no todo el polvo tiene la misma composición ni el mismo tamaño. Por eso, una evaluación seria no se limita a observar si el ambiente parece limpio: identifica el material, el proceso que lo fragmenta y la fracción capaz de permanecer suspendida y llegar al trabajador. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

El polvo no es una sustancia única. Su peligrosidad depende de composición mineralógica, granulometría y propiedades; la emisión depende del proceso; y la exposición depende de cuánto llega a la zona de respiración y durante cuánto tiempo. Ver polvo depositado informa sobre limpieza, pero no cuantifica el aerosol respirable.

Caso práctico razonado

Una cinta parece limpia al inicio, pero un punto de transferencia libera material fino durante cada caída. El foco debe identificarse por operación y no por la apariencia general de la nave.

Secuencia operativa recomendada

• Identificar material y porcentaje de sílice.
• Localizar operaciones que fragmentan, caen o movilizan material.
• Distinguir polvo depositado de polvo en suspensión.
• Relacionar focos con personas, tiempo y trayectoria del aire.

Errores críticos que deben evitarse

• Llamar polvo únicamente a la nube visible.
• Suponer que todos los polvos tienen igual peligrosidad.
• Evaluar el material sin evaluar la tarea.

Comprobación antes de continuar

• Identificar material y porcentaje de sílice.
• Localizar operaciones que fragmentan, caen o movilizan material.
• Distinguir polvo depositado de polvo en suspensión.
• Relacionar focos con personas, tiempo y trayectoria del aire.

Idea clave

El riesgo se entiende al unir material, proceso y persona; observar suciedad no equivale a medir exposición.$q1$ where segment_id = '9212a860-3fba-45cf-9418-0e25322d2930';
update public.lesson_segment_notes set summary = $q2$Objetivo

Reconocer la sílice cristalina y diferenciar presencia en el material de exposición respirable.

Explicación detallada

La sílice cristalina es dióxido de silicio cristalizado, generalmente en forma de cuarzo o cristobalita. Está presente en muchas rocas y materiales minerales. El riesgo aparece cuando partículas respirables se ponen en suspensión y pueden ser inhaladas. El cuarzo es la forma más habitual, pero también debe considerarse la cristobalita cuando pueda estar presente. El porcentaje de sílice de la roca ayuda a caracterizar el peligro, aunque por sí solo no determina la exposición real: también influyen el proceso, la humedad, la ventilación y el tiempo de permanencia. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Cuarzo y cristobalita son formas cristalinas de dióxido de silicio. Un análisis a granel identifica el peligro en la materia prima, pero no predice por sí solo la concentración respirada. Humedad, energía del proceso, encerramiento, ventilación y duración pueden modificar ampliamente la exposición.

Caso práctico razonado

Dos rocas tienen el mismo contenido de cuarzo; una se manipula húmeda en sistema cerrado y otra se corta en seco. El peligro intrínseco es parecido, pero la exposición puede ser muy distinta.

Secuencia operativa recomendada

• Consultar análisis mineralógico representativo.
• Identificar la forma cristalina relevante.
• Relacionar el contenido con el método de trabajo.
• Confirmar exposición mediante evaluación y medición personal.

Errores críticos que deben evitarse

• Equiparar porcentaje en roca con concentración ambiental.
• Ignorar cristobalita cuando el proceso puede generarla o contenerla.
• Descartar riesgo por trabajar al aire libre.

Comprobación antes de continuar

• Consultar análisis mineralógico representativo.
• Identificar la forma cristalina relevante.
• Relacionar el contenido con el método de trabajo.
• Confirmar exposición mediante evaluación y medición personal.

Idea clave

El contenido de sílice caracteriza el peligro; la exposición real se determina en la tarea y la zona de respiración.$q2$ where segment_id = '1327fe65-5b4e-4af0-90e5-eef42b93bd80';
update public.lesson_segment_notes set summary = $q3$Objetivo

Identificar exposición directa, indirecta y ocasional, incluso fuera del puesto emisor.

Explicación detallada

Para que exista exposición debe haber un material con sílice cristalina y una tarea capaz de liberar partículas respirables al aire. La evaluación debe considerar también el polvo procedente de focos cercanos, aunque no se genere directamente en el puesto. El análisis debe abarcar tanto a quien genera el polvo como a quienes trabajan cerca o acceden de forma puntual. Un mecánico, un técnico de laboratorio o personal de oficina que entra en producción puede recibir exposición aunque su tarea principal no sea triturar, perforar o transportar material. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La SCR puede desplazarse desde focos próximos y alcanzar mantenimiento, laboratorio, limpieza, vigilancia o accesos. El mapa de exposición debe incluir rutas de personas y corrientes de aire, tareas normales y anormales, y contratistas. La denominación administrativa del puesto no protege frente a una nube procedente de otra tarea.

Caso práctico razonado

Un electricista entra diez minutos en una trituradora parada mientras se limpia en seco cerca. Aunque no opere el proceso, puede recibir un pico relevante.

Secuencia operativa recomendada

• Inventariar focos propios y externos.
• Seguir rutas de propagación y permanencia.
• Incluir accesos breves, contratas y tareas auxiliares.
• Definir controles antes de autorizar la entrada.

Errores críticos que deben evitarse

• Limitar la evaluación a operadores de producción.
• Excluir tareas cortas por su duración.
• Suponer que la distancia elimina automáticamente el riesgo.

Comprobación antes de continuar

• Inventariar focos propios y externos.
• Seguir rutas de propagación y permanencia.
• Incluir accesos breves, contratas y tareas auxiliares.
• Definir controles antes de autorizar la entrada.

Idea clave

Se evalúa a toda persona que pueda inhalar SCR, no solo a quien genera el polvo.$q3$ where segment_id = '775c6f23-3126-48a7-8efb-c5efa07cc799';
update public.lesson_segment_notes set summary = $q4$Objetivo

Recorrer todo el proceso y reconocer operaciones habituales, no regulares y de mantenimiento que generan polvo.

Explicación detallada

La extracción, perforación, trituración, molienda, tamizado, carga, transporte, limpieza y mantenimiento pueden generar polvo respirable. También pueden producir exposición el corte de piedra, los transvases, el almacenamiento y el acceso esporádico a zonas de producción. Conviene recorrer el proceso completo, desde el frente hasta el producto final, incluyendo paradas, averías y limpieza. Las tareas breves pueden producir picos intensos, especialmente al abrir equipos, vaciar filtros o retirar acumulaciones secas; por eso no deben desaparecer de la evaluación por ser poco frecuentes. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La emisión aumenta con trituración, impacto, abrasión, velocidad, altura de caída y manipulación de material seco. Las aperturas, vaciados de filtros y desatascos pueden producir picos mayores que la producción estable. Una matriz de tareas debe describir frecuencia, duración, material, controles y posibles fallos.

Caso práctico razonado

Una captación mantiene controlada la molienda, pero al vaciar el filtro una vez por semana se libera una nube concentrada. Esa tarea breve necesita evaluación y procedimiento propios.

Secuencia operativa recomendada

• Dibujar el flujo desde extracción hasta expedición.
• Anotar transferencias, caídas, corte, transporte y acopios.
• Añadir limpieza, averías y apertura de equipos.
• Priorizar escenarios por potencial de emisión y personas afectadas.

Errores críticos que deben evitarse

• Medir solo durante régimen estable.
• Olvidar contratistas y mantenedores.
• Considerar irrelevante una tarea por ser semanal.

Comprobación antes de continuar

• Dibujar el flujo desde extracción hasta expedición.
• Anotar transferencias, caídas, corte, transporte y acopios.
• Añadir limpieza, averías y apertura de equipos.
• Priorizar escenarios por potencial de emisión y personas afectadas.

Idea clave

Los picos de tareas breves pueden dominar la dosis y deben aparecer en la evaluación.$q4$ where segment_id = '6f2f2fe4-3884-4a2a-a208-2faa367c8d02';
update public.lesson_segment_notes set summary = $q5$Objetivo

Diferenciar fracciones inhalable, torácica y respirable según su penetración en el aparato respiratorio.

Explicación detallada

El polvo se clasifica según hasta dónde puede penetrar en el sistema respiratorio. La fracción respirable es la más relevante para la sílice porque puede alcanzar las zonas profundas del pulmón, donde su eliminación resulta especialmente difícil. La clasificación por fracciones explica por qué dos nubes aparentemente iguales pueden tener efectos diferentes. La fracción inhalable entra por nariz y boca; la torácica supera la laringe; y la respirable alcanza regiones pulmonares profundas. Para la SCR, esta última es la referencia higiénica esencial. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Las fracciones son convenciones relacionadas con la probabilidad de penetración, no rangos rígidos de diámetro. Para SCR interesa la masa de sílice en la fracción respirable, capaz de alcanzar vías no ciliadas. Por ello se emplea un selector o ciclón adecuado antes del filtro de muestreo.

Caso práctico razonado

Una medición de polvo total no puede sustituir automáticamente a la medición de fracción respirable, porque el muestreador y la magnitud evaluada son diferentes.

Secuencia operativa recomendada

• Identificar la fracción exigida por el límite.
• Usar el cabezal selector correspondiente.
• Evitar comparar resultados de fracciones distintas.
• Interpretar concentración y contenido de sílice conjuntamente.

Errores críticos que deben evitarse

• Usar “polvo fino” como medida técnica suficiente.
• Comparar polvo total con VLA respirable.
• Creer que solo penetran partículas invisibles.

Comprobación antes de continuar

• Identificar la fracción exigida por el límite.
• Usar el cabezal selector correspondiente.
• Evitar comparar resultados de fracciones distintas.
• Interpretar concentración y contenido de sílice conjuntamente.

Idea clave

Para evaluar SCR se necesita medir la fracción respirable con el método adecuado.$q5$ where segment_id = '692226a1-ae39-4cd6-8b75-7a48676653a5';
update public.lesson_segment_notes set summary = $q6$Objetivo

Explicar por qué las partículas finas permanecen suspendidas y pueden pasar inadvertidas.

Explicación detallada

Las partículas gruesas tienden a sedimentar antes, mientras que las finas permanecen más tiempo suspendidas y pueden desplazarse con el aire. Que una nube no sea visible no significa que el ambiente esté libre de partículas respirables. La partícula respirable puede permanecer suspendida durante mucho tiempo y desplazarse fuera del foco. La iluminación, el color del material o la humedad pueden ocultarla visualmente. La decisión preventiva debe apoyarse en mediciones representativas y en el conocimiento del proceso, no en la simple percepción del operador. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La velocidad de sedimentación disminuye al reducirse tamaño y puede verse alterada por turbulencia, viento y ventilación. La visibilidad depende de iluminación, contraste y concentración, por lo que no es un instrumento de medición. Una zona puede parecer despejada y mantener aerosol respirable después de cesar la operación.

Caso práctico razonado

Tras una limpieza con aire comprimido la nube visible desaparece, pero las partículas finas pueden seguir suspendidas y desplazarse a zonas limpias.

Secuencia operativa recomendada

• No usar la visión como criterio de conformidad.
• Considerar tiempo de permanencia y corrientes de aire.
• Mantener controles tras cesar el foco cuando proceda.
• Verificar con mediciones representativas.

Errores críticos que deben evitarse

• Retirarse el EPI en cuanto deja de verse polvo.
• Abrir puertas sin conocer el flujo del aire.
• Confundir sedimentación visible con eliminación.

Comprobación antes de continuar

• No usar la visión como criterio de conformidad.
• Considerar tiempo de permanencia y corrientes de aire.
• Mantener controles tras cesar el foco cuando proceda.
• Verificar con mediciones representativas.

Idea clave

Invisible no significa inexistente: la exposición se confirma mediante evaluación y medición.$q6$ where segment_id = '147b0a7a-edf7-46d5-89ef-6fca6bd745c4';
update public.lesson_segment_notes set summary = $q7$Objetivo

Relacionar dosis de SCR con efectos respiratorios y sistémicos graves.

Explicación detallada

La exposición al polvo puede causar irritación, estornudos o molestias respiratorias. La exposición prolongada a sílice cristalina respirable puede provocar silicosis, pérdida de función pulmonar y aumentar el riesgo de tuberculosis, enfermedad renal y cáncer de pulmón. El daño depende de la dosis acumulada, que combina concentración y tiempo, pero también de exposiciones intensas puntuales. La asociación con cáncer de pulmón obliga a aplicar el principio de reducción al nivel más bajo técnicamente posible, incluso cuando todavía no existen síntomas ni se supera el valor límite. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

La dosis acumulada combina concentración y tiempo, pero los picos intensos también importan. La SCR se asocia con silicosis, cáncer de pulmón, tuberculosis, pérdida de función pulmonar y otras patologías. La irritación temprana no es un indicador fiable de dosis: puede existir exposición relevante sin molestias inmediatas.

Caso práctico razonado

Un trabajador sin síntomas opera años cerca de un foco. Su buena tolerancia no valida el puesto; deben mantenerse medición, controles y vigilancia específica.

Secuencia operativa recomendada

• Reconocer efectos agudos de irritación y efectos crónicos.
• No esperar síntomas para actuar.
• Reducir exposición por debajo del límite tanto como sea técnicamente posible.
• Comunicar síntomas sin ocultarlos ni autodiagnosticarse.

Errores críticos que deben evitarse

• Usar síntomas como detector ambiental.
• Aceptar picos por ser esporádicos.
• Considerar suficiente una revisión médica normal.

Comprobación antes de continuar

• Reconocer efectos agudos de irritación y efectos crónicos.
• No esperar síntomas para actuar.
• Reducir exposición por debajo del límite tanto como sea técnicamente posible.
• Comunicar síntomas sin ocultarlos ni autodiagnosticarse.

Idea clave

La prevención primaria actúa sobre la exposición antes de que exista daño detectable.$q7$ where segment_id = '07fa3a26-eb0a-40e5-b5fb-ed207859c117';
update public.lesson_segment_notes set summary = $q8$Objetivo

Comprender la silicosis como fibrosis pulmonar irreversible y prevenible.

Explicación detallada

La silicosis es una enfermedad pulmonar grave e irreversible causada por la inhalación de sílice cristalina respirable. Puede evolucionar incluso después de cesar la exposición. La prevención debe actuar antes de que aparezcan síntomas o alteraciones radiológicas. La silicosis se produce por la respuesta del tejido pulmonar frente a partículas retenidas y genera fibrosis. Esa cicatrización reduce progresivamente la capacidad respiratoria y no se revierte al abandonar el puesto. La prevención primaria, antes del daño, es mucho más eficaz que cualquier actuación posterior. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Las partículas retenidas activan una respuesta inflamatoria y fibrótica que reduce intercambio gaseoso. El cese de exposición evita dosis adicional, pero no revierte la cicatrización ya producida y la enfermedad puede progresar. De ahí la importancia de evitar el daño y detectar precozmente alteraciones.

Caso práctico razonado

Esperar a que aparezca dificultad respiratoria para instalar aspiración supondría actuar cuando el daño puede ser permanente; el control se diseña desde la evaluación inicial.

Secuencia operativa recomendada

• Controlar el foco antes de iniciar producción.
• Mantener vigilancia sanitaria específica.
• Investigar resultados o diagnósticos relacionados.
• Revisar exposición de personas comparables.

Errores críticos que deben evitarse

• Presentar la silicosis como curable al cambiar de puesto.
• Confiar solo en radiografías periódicas.
• Ocultar un diagnóstico para evitar revisar el proceso.

Comprobación antes de continuar

• Controlar el foco antes de iniciar producción.
• Mantener vigilancia sanitaria específica.
• Investigar resultados o diagnósticos relacionados.
• Revisar exposición de personas comparables.

Idea clave

La silicosis no se cura eliminando la exposición; se previene evitando que la SCR llegue al pulmón.$q8$ where segment_id = 'ead51b6e-28be-47ff-b9b1-354d078e853c';
update public.lesson_segment_notes set summary = $q9$Objetivo

Distinguir formas crónica, acelerada y aguda y relacionarlas con intensidad y duración.

Explicación detallada

Según la intensidad y duración de la exposición, la silicosis puede presentarse de forma crónica, acelerada o aguda. Las exposiciones más intensas pueden acortar mucho el tiempo de aparición, por lo que ninguna sobreexposición debe considerarse aceptable. Las categorías crónica, acelerada y aguda ayudan a entender que no existe una única evolución. Una concentración muy alta puede acortar notablemente los plazos de aparición. Por ello, una avería de aspiración, una limpieza incorrecta o una tarea excepcional requieren control inmediato y no pueden normalizarse. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Las categorías muestran que una exposición muy alta puede reducir drásticamente el tiempo de aparición. No existe una “cuota” aceptable de episodios intensos. Un fallo de captación, una reparación o una limpieza seca debe generar respuesta inmediata, registro y reevaluación.

Caso práctico razonado

Una avería libera polvo durante media hora. Aunque el promedio anual parezca bajo, el episodio no se normaliza: se limita acceso, protege, registra y corrige.

Secuencia operativa recomendada

• Detener y delimitar ante emisión anormal.
• Reducir número de expuestos y duración imprescindible.
• Usar protección adecuada al nivel previsto.
• Investigar y evitar repetición.

Errores críticos que deben evitarse

• Promediar el pico con días sin exposición.
• Considerar segura una sobreexposición corta.
• Esperar a la siguiente campaña rutinaria.

Comprobación antes de continuar

• Detener y delimitar ante emisión anormal.
• Reducir número de expuestos y duración imprescindible.
• Usar protección adecuada al nivel previsto.
• Investigar y evitar repetición.

Idea clave

La intensidad importa: los episodios excepcionales necesitan control tan riguroso como la rutina.$q9$ where segment_id = '960f2b08-1848-4540-98df-e8d1aa1f7f5d';
update public.lesson_segment_notes set summary = $q10$Objetivo

Evaluar la interacción entre material, humedad, clima, maquinaria, pistas y producción.

Explicación detallada

Influyen la naturaleza y humedad de la roca, el proceso productivo, la maquinaria, el estado de las pistas, la climatología, el viento y la posibilidad de aplicar agua. Estos factores deben valorarse para elegir medidas preventivas eficaces. Estos factores interactúan: una pista seca con viento y tráfico intenso puede emitir mucho más que la misma pista húmeda y estabilizada. El análisis debe actualizarse cuando cambien estación, producción, maquinaria o método. Una medida eficaz en invierno puede resultar insuficiente durante un periodo seco y ventoso. En la actividad práctica, el alumno relacionará este concepto con materiales y tareas reales de su centro, identificando qué personas pueden quedar expuestas y en qué momento.

Profundización técnica y criterio preventivo

Los factores no actúan aisladamente. Viento, sequedad y tráfico pueden multiplicar emisiones; agua excesiva puede crear barro y riesgo vial. La eficacia de una medida debe comprobarse en distintas estaciones y cargas de producción. Los cambios operativos actualizan la evaluación aunque el equipo sea el mismo.

Caso práctico razonado

El riego que funcionó en invierno resulta insuficiente en verano con viento y más tráfico. La campaña y la frecuencia de riego deben ajustarse a la nueva condición.

Secuencia operativa recomendada

• Registrar clima, humedad y producción durante mediciones.
• Relacionar emisiones con estado de pistas y equipos.
• Revisar medidas en cambios estacionales.
• Controlar riesgos secundarios del agua.

Errores críticos que deben evitarse

• Copiar una frecuencia fija todo el año.
• Aumentar agua sin revisar drenaje y adherencia.
• Ignorar cambios de material o tonelaje.

Comprobación antes de continuar

• Registrar clima, humedad y producción durante mediciones.
• Relacionar emisiones con estado de pistas y equipos.
• Revisar medidas en cambios estacionales.
• Controlar riesgos secundarios del agua.

Idea clave

La medida eficaz es la que se adapta a la condición real y mantiene control sin crear riesgos nuevos.$q10$ where segment_id = '68b7dc42-fc52-40d3-91cb-5a778497205b';
update public.lesson_segment_notes set summary = $q11$Objetivo

Integrar la ITC 02.0.02 con la normativa general de cancerígenos y agentes químicos.

Explicación detallada

La referencia específica en minería es la Orden TED 723 de 2021, que aprueba la ITC 02.0.02. También son aplicables el Real Decreto 665 de 1997 sobre agentes cancerígenos y el Real Decreto 374 de 2001 sobre agentes químicos. La ITC minera convive con la normativa general de agentes cancerígenos, agentes químicos, prevención y equipos de protección. Aplicar la norma más específica no elimina las obligaciones generales. La empresa debe integrar todas ellas en su evaluación y en el Documento sobre Seguridad y Salud, evitando referencias derogadas. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

La Orden TED/723/2021 aporta requisitos mineros específicos, pero no desplaza el RD 665/1997 ni el RD 374/2001. La evaluación debe reflejar la norma aplicable, versiones vigentes y obligaciones más rigurosas. Usar referencias derogadas puede conducir a límites, frecuencias o formación incorrectos.

Caso práctico razonado

Una empresa mantiene un procedimiento basado en la ITC de 2007. Aunque algunas medidas sean útiles, debe actualizar límites, muestreo, ajuste respiratorio y comunicaciones a la norma vigente.

Secuencia operativa recomendada

• Identificar ámbito y norma específica.
• Contrastar texto consolidado y derogaciones.
• Integrar obligaciones en DSS y procedimientos.
• Actualizar documentos, formación y registros.

Errores críticos que deben evitarse

• Citar solo la ITC y omitir cancerígenos.
• Mantener valores de una norma derogada.
• Confundir guía técnica con obligación jurídica.

Comprobación antes de continuar

• Identificar ámbito y norma específica.
• Contrastar texto consolidado y derogaciones.
• Integrar obligaciones en DSS y procedimientos.
• Actualizar documentos, formación y registros.

Idea clave

La prevención se apoya en un marco integrado y actualizado, no en una única norma aislada.$q11$ where segment_id = 'd843a759-41f5-449b-bdc8-078ca1bd1e66';
update public.lesson_segment_notes set summary = $q12$Objetivo

Aplicar el enfoque de agente cancerígeno: evitar y reducir al nivel más bajo técnicamente posible.

Explicación detallada

Los trabajos que generan exposición a polvo respirable de sílice cristalina están incluidos entre los procedimientos cancerígenos. Por ello, la exposición debe evitarse y, cuando no sea posible, reducirse a un nivel tan bajo como sea técnicamente posible. Esta consideración modifica el enfoque: no basta con mantenerse por debajo de un número. Deben analizarse sustitución, sistemas cerrados, captación en origen, reducción del número de personas expuestas, higiene y vigilancia. Las decisiones han de quedar justificadas y revisarse cuando aparezcan alternativas técnicas mejores. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

Cumplir un límite es requisito mínimo, no licencia para mantener exposición evitable. Deben estudiarse sustitución del proceso, sistemas cerrados, captación, reducción de personas y tiempos, higiene y EPI residual. La viabilidad técnica se revisa al aparecer soluciones mejores.

Caso práctico razonado

Una medición de 0,04 mg/m³ cumple, pero una captación viable puede reducirla a 0,015. La mejora debe evaluarse y no descartarse solo por estar bajo el VLA.

Secuencia operativa recomendada

• Eliminar o sustituir cuando sea posible.
• Controlar el foco y el medio.
• Reducir personas y duración.
• Usar EPI únicamente para riesgo residual o temporal.

Errores críticos que deben evitarse

• Tomar 0,05 como objetivo de operación.
• Retirar medidas tras un resultado favorable.
• Justificar exposición evitable por costumbre.

Comprobación antes de continuar

• Eliminar o sustituir cuando sea posible.
• Controlar el foco y el medio.
• Reducir personas y duración.
• Usar EPI únicamente para riesgo residual o temporal.

Idea clave

Para cancerígenos, “por debajo del límite” y “tan bajo como sea técnicamente posible” son obligaciones simultáneas.$q12$ where segment_id = '05f813fd-38c2-4a22-a4b2-89003ff14e6d';
update public.lesson_segment_notes set summary = $q13$Objetivo

Interpretar simultáneamente los VLA-ED de polvo respirable y SCR.

Explicación detallada

Deben cumplirse simultáneamente dos límites: tres miligramos por metro cúbico para el polvo respirable total y cero coma cero cinco miligramos por metro cúbico para la sílice cristalina respirable. Son límites diarios referidos a una jornada estándar de ocho horas. Los dos valores se comparan por separado y deben cumplirse simultáneamente. Un resultado bajo de polvo total no garantiza que la concentración de sílice sea aceptable si la proporción de SCR es elevada. La interpretación debe considerar incertidumbre analítica, representatividad y jornada real antes de concluir conformidad. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

Los límites son 3 mg/m³ para polvo respirable y 0,05 mg/m³ para SCR, referidos a ocho horas. Se comparan por separado. Una baja concentración de polvo puede incumplir SCR si su proporción es alta. La jornada real se pondera y la decisión debe considerar incertidumbre y representatividad.

Caso práctico razonado

Una muestra arroja 1,2 mg/m³ de polvo respirable y 0,06 mg/m³ de SCR: cumple el primer límite, pero el puesto no es conforme por la sílice.

Secuencia operativa recomendada

• Verificar unidades, fracción y duración.
• Comparar cada resultado con su límite.
• Revisar incertidumbre y condiciones de jornada.
• Adoptar medidas si cualquiera incumple.

Errores críticos que deben evitarse

• Promediar ambos resultados entre sí.
• Concluir conformidad por cumplir polvo total.
• Redondear a la baja una cifra próxima.

Comprobación antes de continuar

• Verificar unidades, fracción y duración.
• Comparar cada resultado con su límite.
• Revisar incertidumbre y condiciones de jornada.
• Adoptar medidas si cualquiera incumple.

Idea clave

Los dos valores deben cumplirse simultáneamente; el más desfavorable gobierna la decisión.$q13$ where segment_id = 'd2b0cd4c-7fd4-4b19-b513-ab7313d847e6';
update public.lesson_segment_notes set summary = $q14$Objetivo

Usar el límite como frontera legal y no como nivel deseado.

Explicación detallada

Cumplir el valor límite no permite dar por terminado el control. Al tratarse de un agente cancerígeno, la empresa debe reducir la exposición todo lo técnicamente posible y mantener las medidas preventivas, aunque las mediciones estén por debajo del límite. Trabajar cerca del límite deja poco margen frente a variaciones del proceso, viento, fallos de riego o aumento de producción. La mejora continua busca alejarse de esa situación mediante controles estables. Los resultados favorables sirven para confirmar medidas, no para retirar automáticamente barreras que ya funcionan. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

Trabajar cerca del VLA ofrece poco margen ante variaciones de viento, producción o fallo de controles. Las tendencias, no solo los puntos individuales, deben guiar mejora. Un resultado bajo confirma las barreras utilizadas durante esa muestra; retirarlas cambia la situación y anula la inferencia.

Caso práctico razonado

Tres campañas suben de 0,018 a 0,031 y 0,044 mg/m³. Aún cumplen, pero la tendencia exige investigar antes de superar.

Secuencia operativa recomendada

• Analizar series y variabilidad.
• Mantener controles presentes durante la medición.
• Investigar tendencias ascendentes.
• Planificar mejora con responsable y plazo.

Errores críticos que deben evitarse

• Esperar a superar 0,05.
• Retirar riego por resultado favorable.
• Usar el VLA como consigna de producción.

Comprobación antes de continuar

• Analizar series y variabilidad.
• Mantener controles presentes durante la medición.
• Investigar tendencias ascendentes.
• Planificar mejora con responsable y plazo.

Idea clave

La acción preventiva empieza con la tendencia y la causa, no solo después del incumplimiento.$q14$ where segment_id = '075784de-2db2-444e-a7cb-f028fe9d1e8e';
update public.lesson_segment_notes set summary = $q15$Objetivo

Construir una identificación completa de materiales, tareas, puestos y situaciones anormales.

Explicación detallada

La evaluación comienza identificando materiales con sílice cristalina y tareas que puedan poner polvo respirable en suspensión. Deben incluirse operaciones habituales, mantenimiento, limpiezas, averías, trabajos no regulares y posibles exposiciones procedentes de otras áreas. Una matriz de tareas resulta útil para relacionar material, operación, duración, trabajadores, controles existentes y situaciones anormales. Debe incluir contratistas y puestos indirectos. Después se priorizan los escenarios con mayor potencial de generar SCR y se diseña una estrategia de medición representativa. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

La matriz debe relacionar material, porcentaje de sílice, operación, duración, número de personas, controles, fallos y exposición externa. Debe incluir mantenimiento, limpieza, contratas y accesos esporádicos. Esta base permite formar grupos de exposición y diseñar muestreo representativo.

Caso práctico razonado

La evaluación incluye trituración, pero no el desatasco manual. Un desatasco mensual puede liberar una dosis intensa y debe incorporarse como escenario propio.

Secuencia operativa recomendada

• Inventariar materias primas y productos.
• Descomponer cada puesto en tareas.
• Añadir averías, mantenimiento y limpieza.
• Mapear personas directas, indirectas y contratas.

Errores críticos que deben evitarse

• Usar solo nombres de puestos.
• Excluir tareas infrecuentes.
• Suponer que un análisis de roca sustituye al muestreo.

Comprobación antes de continuar

• Inventariar materias primas y productos.
• Descomponer cada puesto en tareas.
• Añadir averías, mantenimiento y limpieza.
• Mapear personas directas, indirectas y contratas.

Idea clave

Una evaluación útil describe lo que realmente se hace, también cuando el proceso deja de funcionar con normalidad.$q15$ where segment_id = '64af9e0b-cf2e-4e60-98d7-fcda1f9627ad';
update public.lesson_segment_notes set summary = $q16$Objetivo

Comprender el muestreo personal en la zona de respiración y la función del personal competente.

Explicación detallada

La exposición se mide con equipos personales portados por el trabajador. El muestreador se coloca en su zona de respiración y la estrategia debe ser representativa de la actividad real. La toma la realiza personal competente y no el propio trabajador. El cabezal debe situarse correctamente y permanecer sin obstrucciones durante la jornada. El personal competente registra caudal, tiempos, incidencias y tareas realizadas. Si el trabajador cambia de zona o se produce una parada, esa información permite interpretar el resultado en lugar de tratarlo como un dato aislado. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

El muestreador debe acompañar al trabajador y situarse en la semiesfera de respiración, sin quedar tapado. El personal competente calibra, observa, registra tareas e incidencias y permanece durante el muestreo. Un captador fijo en la instalación puede caracterizar ambiente, pero no sustituye la medición personal exigida.

Caso práctico razonado

Un operador se quita el equipo durante una pausa y lo deja cerca de la trituradora: el resultado deja de representar su exposición y la incidencia debe registrarse.

Secuencia operativa recomendada

• Calibrar y montar el conjunto correctamente.
• Colocar el cabezal en la zona de respiración.
• Acompañar tareas reales y registrar cambios.
• Comprobar caudal y tratar incidencias.

Errores críticos que deben evitarse

• Colgar el muestreador en la cabina vacía.
• Dejar al trabajador gestionar solo la muestra.
• Ocultar el cabezal bajo ropa.

Comprobación antes de continuar

• Calibrar y montar el conjunto correctamente.
• Colocar el cabezal en la zona de respiración.
• Acompañar tareas reales y registrar cambios.
• Comprobar caudal y tratar incidencias.

Idea clave

La muestra válida sigue a la persona y documenta fielmente su jornada.$q16$ where segment_id = '01e1ac20-500d-477e-adfc-c61397eb657c';
update public.lesson_segment_notes set summary = $q17$Objetivo

Garantizar que duración y estrategia representen la jornada completa.

Explicación detallada

La toma de muestras debe extenderse a toda la jornada de trabajo. Solo puede reducirse excepcionalmente por exigencias analíticas, dejando constancia de la incidencia y garantizando que la muestra siga siendo suficiente y representativa de la exposición diaria. La representatividad exige cubrir las fases que definen la exposición habitual. Si la muestra se acorta por saturación, debe justificarse y seguir describiendo la jornada completa mediante una estrategia técnicamente válida. Una medición cómoda pero ajena al trabajo real puede conducir a decisiones preventivas equivocadas. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

La regla general es muestrear toda la jornada. Solo se reduce excepcionalmente por exigencias analíticas como saturación, dejando constancia y conservando representatividad de la actividad total. Elegir solo la fase limpia sesga el resultado aunque el tiempo sea largo.

Caso práctico razonado

Una muestra de cuatro horas cubre solo la mañana húmeda y omite la tarde seca con carga máxima: no representa la exposición diaria.

Secuencia operativa recomendada

• Planificar cobertura de todas las fases.
• Registrar tiempos y tareas.
• Justificar cualquier reducción excepcional.
• Interpretar jornada real y referencia de ocho horas.

Errores críticos que deben evitarse

• Muestrear la franja más cómoda.
• Eliminar picos para evitar saturación sin justificar.
• Extrapolar sin base técnica.

Comprobación antes de continuar

• Planificar cobertura de todas las fases.
• Registrar tiempos y tareas.
• Justificar cualquier reducción excepcional.
• Interpretar jornada real y referencia de ocho horas.

Idea clave

La representatividad depende de cubrir la variabilidad, no solo de acumular minutos.$q17$ where segment_id = '7747a074-b020-472f-ad94-81853ca22a93';
update public.lesson_segment_notes set summary = $q18$Objetivo

Aplicar la frecuencia mínima cuatrimestral y ampliarla cuando el riesgo lo requiera.

Explicación detallada

En los puestos con riesgo de exposición a polvo se tomarán muestras, como mínimo, una vez cada cuatrimestre del año natural. Los análisis los realiza el Instituto Nacional de Silicosis o un laboratorio reconocido por la Autoridad Minera. La frecuencia mínima cuatrimestral no impide medir más cuando cambian condiciones, fallan controles o existe incertidumbre. Las campañas deben repartirse de forma que recojan variabilidad estacional y productiva. Repetir siempre el muestreo en el momento más favorable reduciría su utilidad preventiva. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

“Una vez cada cuatrimestre del año natural” implica al menos tres campañas distribuidas. Es un mínimo, no una prohibición de medir tras cambios, fallos o incertidumbre. Seleccionar siempre días favorables reduce la capacidad de detectar variabilidad estacional.

Caso práctico razonado

Las tres muestras se realizan en días lluviosos pese a que la mayor producción ocurre en verano. La frecuencia formal se cumple, pero la estrategia puede no ser representativa.

Secuencia operativa recomendada

• Distribuir campañas por cuatrimestres.
• Capturar estaciones y condiciones relevantes.
• Añadir mediciones tras cambios o fallos.
• Usar laboratorios reconocidos.

Errores críticos que deben evitarse

• Concentrar campañas en el mismo mes.
• Elegir solo condiciones favorables.
• Esperar al siguiente cuatrimestre tras una avería grave.

Comprobación antes de continuar

• Distribuir campañas por cuatrimestres.
• Capturar estaciones y condiciones relevantes.
• Añadir mediciones tras cambios o fallos.
• Usar laboratorios reconocidos.

Idea clave

Cumplir calendario no basta: cada campaña debe aportar evidencia representativa.$q18$ where segment_id = '91ba067b-ccec-4ba1-bbcf-fd6286dd00da';
update public.lesson_segment_notes set summary = $q19$Objetivo

Revisar la evaluación por cambios, daños o ineficacia y, en todo caso, cada tres años.

Explicación detallada

La evaluación se revisa cuando cambian las condiciones, aparecen daños para la salud o las medidas resultan insuficientes. En minería, la ITC exige además revisarla en todo caso cada tres años, sin esperar a que ocurra un incidente. La revisión trienal es un máximo ordinario, no una espera obligatoria. Una nueva trituradora, un cambio de material, un diagnóstico relacionado o resultados crecientes exigen actuar antes. Revisar significa volver a comprobar peligros, exposición y eficacia de controles, y actualizar medidas y documentación. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

El plazo trienal es máximo ordinario. Cambiar material, proceso, producción, control, diagnóstico o tendencia puede exigir revisión inmediata. Revisar no significa cambiar la fecha: implica reconsiderar peligros, grupos, mediciones, eficacia y medidas.

Caso práctico razonado

Se instala una trituradora nueva seis meses después de la última evaluación. No se espera dos años y medio; se revisa antes de exponer.

Secuencia operativa recomendada

• Definir disparadores de revisión.
• Reevaluar antes de cambios planificados.
• Incorporar resultados sanitarios y ambientales.
• Actualizar DSS, procedimientos y formación.

Errores críticos que deben evitarse

• Esperar siempre tres años.
• Limitarse a cambiar la portada.
• Revisar solo tras accidente.

Comprobación antes de continuar

• Definir disparadores de revisión.
• Reevaluar antes de cambios planificados.
• Incorporar resultados sanitarios y ambientales.
• Actualizar DSS, procedimientos y formación.

Idea clave

Cada tres años es el máximo; cualquier cambio relevante adelanta la revisión.$q19$ where segment_id = '99c8945f-9deb-4e15-9944-a7307c66a15d';
update public.lesson_segment_notes set summary = $q20$Objetivo

Comunicar resultados individuales de manera comprensible y conservar trazabilidad con confidencialidad sanitaria.

Explicación detallada

Cada trabajador debe conocer los riesgos de su puesto, los resultados que le afecten y las medidas implantadas. Los valores de exposición se registran periódicamente en fichas individualizadas para conocer el riesgo acumulado y se incorporan al expediente médico. La comunicación debe ser comprensible y relacionar el dato con el puesto y las medidas necesarias. No basta con entregar una cifra sin contexto. La trazabilidad individual permite observar tendencias y vincular tareas, resultados y vigilancia sanitaria respetando la confidencialidad de la información médica. El ejercicio asociado consistirá en interpretar el dato o requisito, decidir qué evidencia debe quedar documentada y justificar cuándo procede revisar la evaluación o ampliar el muestreo.

Profundización técnica y criterio preventivo

El trabajador debe conocer qué se midió, en qué tarea, qué resultado le afecta, cómo se interpreta y qué medidas siguen. Las fichas individualizadas se integran en su expediente médico, pero los datos sanitarios tienen acceso reservado. La comunicación preventiva no consiste en entregar una cifra sin contexto.

Caso práctico razonado

Un trabajador recibe “0,038 mg/m³” sin explicar tarea ni controles. No puede valorar significado ni saber qué conducta mantener; la información es incompleta.

Secuencia operativa recomendada

• Relacionar resultado, jornada y tarea.
• Explicar comparación y tendencia.
• Informar medidas y acciones previstas.
• Proteger confidencialidad médica.

Errores críticos que deben evitarse

• Publicar expedientes médicos.
• Comunicar solo si hay incumplimiento.
• Entregar cifras sin explicación.

Comprobación antes de continuar

• Relacionar resultado, jornada y tarea.
• Explicar comparación y tendencia.
• Informar medidas y acciones previstas.
• Proteger confidencialidad médica.

Idea clave

La transparencia preventiva exige contexto; la confidencialidad protege la información sanitaria, no oculta la exposición.$q20$ where segment_id = '58958a71-e777-44d1-9d67-8a335076a5ef';
update public.lesson_segment_notes set summary = $q21$Objetivo

Aplicar la jerarquía: evitar, controlar en origen y medio, organizar y proteger el riesgo residual.

Explicación detallada

La prioridad es evitar la generación de polvo o reducirla en el foco. Después se actúa sobre el medio de propagación y, por último, sobre el trabajador. La protección respiratoria complementa estas medidas, pero no puede sustituirlas. La jerarquía evita convertir la mascarilla en solución automática. Primero se elimina o reduce el foco; después se encierra, capta o asienta el contaminante; a continuación se limita la exposición mediante organización; y solo como complemento se selecciona protección respiratoria adecuada al riesgo residual. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La mascarilla no debe convertirse en respuesta automática. Se prioriza eliminar o modificar el proceso; después cerramiento, captación o vía húmeda; luego separación, tiempo y acceso; por último EPI durante el tiempo imprescindible. Las capas se complementan y su eficacia se verifica.

Caso práctico razonado

Una perforadora emite polvo por una boquilla obstruida. Entregar mascarillas sin reparar el riego mantiene un foco evitable y contradice la jerarquía.

Secuencia operativa recomendada

• Identificar si puede evitarse la tarea o emisión.
• Actuar en el foco.
• Controlar propagación y acceso.
• Seleccionar EPI para el riesgo residual.

Errores críticos que deben evitarse

• Sustituir mantenimiento por EPI.
• Elegir primero la solución más barata.
• Retirar controles colectivos al usar mascarilla.

Comprobación antes de continuar

• Identificar si puede evitarse la tarea o emisión.
• Actuar en el foco.
• Controlar propagación y acceso.
• Seleccionar EPI para el riesgo residual.

Idea clave

El EPI protege a una persona; el control en origen evita que el contaminante alcance a todas.$q21$ where segment_id = 'fdc342e9-11c2-4b86-a3a1-5228de3bf479';
update public.lesson_segment_notes set summary = $q22$Objetivo

Reducir emisión modificando material, método, herramienta, velocidad, caída o secuencia.

Explicación detallada

Cuando sea técnicamente posible, deben sustituirse materiales o procedimientos por otros menos peligrosos. En minería la sustitución de la roca suele ser inviable, pero sí pueden modificarse métodos, herramientas, velocidades o secuencias para generar menos polvo. Aunque no pueda sustituirse el mineral, sí pueden compararse herramientas, métodos húmedos, velocidades de corte, alturas de caída o secuencias de apertura. Cada cambio debe evaluarse de forma global para no crear otros riesgos, como proyecciones, resbalones, atrapamientos o contaminación del agua. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Aunque no pueda sustituirse la roca, casi siempre pueden compararse métodos. El cambio se evalúa globalmente para evitar riesgos secundarios: agua y electricidad, barro, atrapamiento, proyección o residuo contaminado. La mejora se valida mediante observación, mantenimiento y medición.

Caso práctico razonado

Reducir altura de caída baja polvo, pero desplaza un punto de trabajo hacia una zona de atrapamiento. La solución debe rediseñarse sin intercambiar un riesgo por otro.

Secuencia operativa recomendada

• Generar varias alternativas técnicas.
• Comparar emisión y exposición esperada.
• Evaluar riesgos secundarios.
• Probar, medir y documentar la opción.

Errores críticos que deben evitarse

• Cambiar sin evaluar seguridad global.
• Descartar cambios porque la roca no es sustituible.
• Dar por eficaz una prueba visual.

Comprobación antes de continuar

• Generar varias alternativas técnicas.
• Comparar emisión y exposición esperada.
• Evaluar riesgos secundarios.
• Probar, medir y documentar la opción.

Idea clave

Modificar el proceso es prevención en origen solo si reduce la exposición sin crear un riesgo mayor.$q22$ where segment_id = 'c7b055cd-b5be-413c-8bf6-897cb4a2f546';
update public.lesson_segment_notes set summary = $q23$Objetivo

Mantener confinamientos íntegros y compatibles con captación, acceso y limpieza.

Explicación detallada

Carenados, capotajes y cerramientos limitan la dispersión del polvo en trituradoras, cintas y puntos de transferencia. Para ser eficaces deben mantenerse íntegros, combinarse cuando proceda con aspiración y abrirse solo siguiendo el procedimiento establecido. Un cerramiento con huecos, tapas abiertas o juntas deterioradas pierde eficacia. También puede generar acumulaciones que después se liberan durante el mantenimiento. La inspección práctica debe comprobar integridad, depresión cuando proceda, acceso seguro y un método de limpieza que no vuelva a dispersar el polvo. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Un cerramiento necesita juntas, tapas y conductos en buen estado y, cuando procede, depresión suficiente. Abrirlo altera el flujo y puede liberar acumulaciones. Mantenimiento y limpieza deben planificarse con parada, aislamiento, aspiración y protección residual.

Caso práctico razonado

Una tapa queda abierta para observar el material. La aspiración continúa, pero el punto de entrada de aire cambia y puede escapar polvo hacia el trabajador.

Secuencia operativa recomendada

• Inspeccionar integridad y cierres.
• Verificar depresión o caudal de captación.
• Mantener accesos cerrados durante operación.
• Planificar apertura y limpieza segura.

Errores críticos que deben evitarse

• Retirar paneles para mejorar acceso.
• Sellar sin prever mantenimiento.
• Barrer acumulaciones del interior.

Comprobación antes de continuar

• Inspeccionar integridad y cierres.
• Verificar depresión o caudal de captación.
• Mantener accesos cerrados durante operación.
• Planificar apertura y limpieza segura.

Idea clave

Un cerramiento solo protege si conserva su geometría y se abre bajo procedimiento.$q23$ where segment_id = '3926cd59-a18b-46dd-9b1f-45760b322a6c';
update public.lesson_segment_notes set summary = $q24$Objetivo

Conservar la protección de cabinas mediante cierre, filtración, presurización y limpieza controlada.

Explicación detallada

Las cabinas cerradas, con filtración y presión positiva, aíslan al operador del ambiente contaminado. Su eficacia depende de mantener puertas y ventanas cerradas, revisar juntas y filtros y comprobar que el sistema funciona durante toda la tarea. La presión positiva solo protege si el caudal de aire filtrado compensa las entradas no controladas. Abrir una ventana, usar un filtro saturado o mantener una puerta con juntas dañadas puede anular el sistema. El operador debe reconocer indicadores de fallo y comunicar cualquier pérdida de estanqueidad. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La presión positiva evita entrada de polvo si puertas, ventanas y sellos están cerrados. Filtros saturados, fugas o climatización mal mantenida reducen el diferencial. Introducir ropa contaminada o barrer la cabina crea una fuente interior que la presurización no elimina.

Caso práctico razonado

Un operador abre la ventana por calor. Aunque el filtro sea nuevo, anula la barrera de presión y recibe aire sin filtrar.

Secuencia operativa recomendada

• Comprobar indicador o diferencial de presión.
• Revisar filtros, juntas y puertas.
• Mantener ventanas cerradas.
• Limpiar interior con aspiración adecuada.

Errores críticos que deben evitarse

• Abrir para desempañar.
• Sacudir ropa dentro.
• Cambiar filtro solo cuando se vea polvo.

Comprobación antes de continuar

• Comprobar indicador o diferencial de presión.
• Revisar filtros, juntas y puertas.
• Mantener ventanas cerradas.
• Limpiar interior con aspiración adecuada.

Idea clave

La cabina es un sistema de protección, no solo un habitáculo cerrado.$q24$ where segment_id = '1ebe4dbc-79fd-4218-9a08-f6a194d44dcd';
update public.lesson_segment_notes set summary = $q25$Objetivo

Aplicar agua en cantidad, tamaño de gota y punto adecuados sin generar riesgos secundarios.

Explicación detallada

La inyección, pulverización o niebla de agua ayuda a impedir que las partículas pasen al aire y favorece su sedimentación. El sistema debe aplicarse en el punto adecuado y mantenerse operativo, evitando que el agua cree nuevos riesgos. Más agua no siempre significa mejor control. Deben ajustarse tamaño de gota, orientación, caudal y punto de aplicación al polvo generado. También se vigilan barro, visibilidad, estabilidad del firme, heladas y consumo. Una boquilla obstruida o mal orientada puede dejar el foco prácticamente sin protección. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La humectación evita que el material genere aerosol y la pulverización captura o asienta. Boquillas obstruidas, mala orientación o presión insuficiente dejan zonas secas. Demasiada agua puede crear barro, resbalones, drenajes contaminados o afectar al proceso.

Caso práctico razonado

El manómetro indica presión normal, pero varias boquillas están taponadas. El indicador general no demuestra cobertura efectiva; hay que observar el patrón.

Secuencia operativa recomendada

• Verificar suministro, presión y cobertura.
• Orientar al foco y sincronizar con proceso.
• Mantener boquillas limpias.
• Controlar drenaje, barro y calidad del producto.

Errores críticos que deben evitarse

• Regar solo cuando se ve nube.
• Aumentar caudal sin límite.
• Confiar únicamente en el manómetro.

Comprobación antes de continuar

• Verificar suministro, presión y cobertura.
• Orientar al foco y sincronizar con proceso.
• Mantener boquillas limpias.
• Controlar drenaje, barro y calidad del producto.

Idea clave

La vía húmeda se valida por cobertura efectiva del foco y control de sus consecuencias.$q25$ where segment_id = '1eb0f936-df98-4065-9e91-69baeb399ae3';
update public.lesson_segment_notes set summary = $q26$Objetivo

Capturar el polvo cerca del foco con caudal y diseño compatibles con la emisión.

Explicación detallada

La aspiración localizada captura el polvo cerca del punto de generación antes de que alcance la zona de respiración. Campanas, conductos, filtros y separadores deben dimensionarse, revisarse y mantenerse para conservar el caudal y la eficacia previstos. La campana debe estar próxima al foco y el aire captado debe conducirse y filtrarse sin fugas. Pérdidas de carga, conductos rotos o filtros colmatados reducen el caudal. La verificación combina inspección, indicadores de presión y, cuando proceda, medición del rendimiento del sistema. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La aspiración localizada necesita velocidad de captura, proximidad, conductos estancos, filtros y descarga segura. Alejar la campana reduce rápidamente eficacia. Abrir cerramientos o aumentar producción puede superar el caudal disponible. El mantenimiento se hace sin liberar el polvo capturado.

Caso práctico razonado

Se aumenta el tonelaje un 30 % y aparece emisión pese a que el ventilador funciona. El sistema puede haber quedado subdimensionado y debe reevaluarse.

Secuencia operativa recomendada

• Comprobar posición de campana.
• Verificar caudal/depresión y conductos.
• Revisar filtros y alarmas.
• Reevaluar tras cambios de producción.

Errores críticos que deben evitarse

• Confundir ventilación general con captación.
• Vaciar filtros sin control.
• Aceptar emisión porque el motor gira.

Comprobación antes de continuar

• Comprobar posición de campana.
• Verificar caudal/depresión y conductos.
• Revisar filtros y alarmas.
• Reevaluar tras cambios de producción.

Idea clave

Que el ventilador funcione no prueba que el contaminante sea capturado.$q26$ where segment_id = 'b1f44cfa-e948-4d21-8489-976e8ebd2c43';
update public.lesson_segment_notes set summary = $q27$Objetivo

Controlar emisiones de pistas, transporte y acopios mediante firme, agua, velocidad y geometría.

Explicación detallada

El riego o estabilización de pistas, la limitación de velocidad, la limpieza de ruedas y el cubrimiento de cargas reducen las emisiones del transporte. Los acopios pueden protegerse del viento y gestionarse para evitar caídas y manipulaciones innecesarias. El control del transporte exige coordinar riego, mantenimiento de firme, velocidad y limpieza. Regar sin reparar baches puede generar barro y pérdida de control; limitar velocidad sin supervisión puede no funcionar. En acopios, la altura de caída y la orientación respecto al viento son variables decisivas. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

El tráfico resuspende finos. Riego, estabilización, reparación, limpieza de derrames y velocidad actúan juntos. En acopios importan altura de caída, humedad y orientación al viento. La medida debe evitar barro, pérdida de adherencia y contaminación del agua.

Caso práctico razonado

Regar una pista con baches crea charcos y barro; reducir polvo a costa de perder control del vehículo no es aceptable.

Secuencia operativa recomendada

• Mantener firme y drenaje.
• Ajustar riego a clima y tráfico.
• Controlar velocidad y derrames.
• Reducir altura de caída y exposición al viento.

Errores críticos que deben evitarse

• Usar solo una señal de velocidad.
• Regar sin revisar adherencia.
• Dejar finos acumulados en bordes.

Comprobación antes de continuar

• Mantener firme y drenaje.
• Ajustar riego a clima y tráfico.
• Controlar velocidad y derrames.
• Reducir altura de caída y exposición al viento.

Idea clave

Las emisiones difusas se controlan con un sistema coordinado, no con una medida aislada.$q27$ where segment_id = '247a5ce5-aa96-41fe-ad4a-5a16eb79530f';
update public.lesson_segment_notes set summary = $q28$Objetivo

Limpiar sin volver a poner el contaminante en suspensión ni trasladarlo.

Explicación detallada

La limpieza debe realizarse por aspiración industrial o por vía húmeda. Barrer en seco o utilizar aire comprimido vuelve a poner el polvo en suspensión y aumenta la exposición, por lo que estas prácticas deben evitarse salvo procedimiento específicamente controlado. La aspiración debe ser apta para el polvo recogido y mantenerse conforme al fabricante. En limpieza húmeda se evita crear salpicaduras o arrastres contaminados. Antes de intervenir se planifica dónde irá el residuo y cómo se limpiará el propio equipo sin exponer nuevamente al trabajador. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

La aspiración industrial adecuada o la vía húmeda son métodos preferentes. Aire comprimido y barrido seco dispersan el polvo y contaminan superficies cercanas. Debe definirse el destino del residuo y cómo se descontamina el propio aspirador o útil.

Caso práctico razonado

Un operario barre al final del turno cuando no hay producción. Aunque haya menos personas, genera exposición propia y contaminación residual.

Secuencia operativa recomendada

• Planificar área, método y residuo.
• Usar aspiración apta o vía húmeda.
• Delimitar y proteger según riesgo residual.
• Limpiar equipos sin dispersar.

Errores críticos que deben evitarse

• Barrer cuando no haya supervisión.
• Soplar ropa con aire.
• Vaciar aspirador en saco abierto.

Comprobación antes de continuar

• Planificar área, método y residuo.
• Usar aspiración apta o vía húmeda.
• Delimitar y proteger según riesgo residual.
• Limpiar equipos sin dispersar.

Idea clave

La limpieza elimina polvo; si lo suspende de nuevo, traslada el riesgo en vez de controlarlo.$q28$ where segment_id = '46a818dd-0d43-49b9-9601-003a86306015';
update public.lesson_segment_notes set summary = $q29$Objetivo

Convertir el mantenimiento de controles en comprobaciones con criterios de aceptación y parada.

Explicación detallada

Una medida preventiva solo protege si funciona. Deben revisarse boquillas, captaciones, filtros, cerramientos, cabinas y sistemas de riego. Cualquier fallo se comunica y corrige antes de continuar si compromete el control de la exposición. El mantenimiento preventivo debe definir responsable, frecuencia, criterio de aceptación y registro. No basta con anotar que se ha revisado. Una lista útil obliga a comprobar caudal, presión, estado de filtros, boquillas, puertas y alarmas, y establece qué fallos requieren detener la tarea. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Una lista útil define qué se mide, rango aceptable, responsable, frecuencia y acción. “Revisado” no demuestra caudal, presión, saturación o cierre. El mantenimiento preventivo evita que la exposición sea el primer indicador del fallo.

Caso práctico razonado

Una boquilla se anota como revisada, pero no se registra patrón ni presión. No hay evidencia de que controle el foco.

Secuencia operativa recomendada

• Definir parámetro y rango.
• Inspeccionar con frecuencia basada en fallo.
• Registrar resultado, no solo firma.
• Establecer criterio de parada y reparación.

Errores críticos que deben evitarse

• Usar la nube como alarma de mantenimiento.
• Posponer defectos al mantenimiento anual.
• Aceptar controles sin indicadores.

Comprobación antes de continuar

• Definir parámetro y rango.
• Inspeccionar con frecuencia basada en fallo.
• Registrar resultado, no solo firma.
• Establecer criterio de parada y reparación.

Idea clave

Una barrera preventiva necesita condición verificable y respuesta definida cuando falla.$q29$ where segment_id = '1e68fb8b-92a7-4919-94f3-42d5f051e7cb';
update public.lesson_segment_notes set summary = $q30$Objetivo

Planificar averías, reparaciones e inspecciones como exposiciones no regulares de potencial elevado.

Explicación detallada

En averías, reparaciones, inspecciones y limpiezas extraordinarias puede aumentar la exposición. Se limitará el acceso a personal autorizado, se reducirá el tiempo imprescindible y se usarán medidas técnicas y protección respiratoria adecuadas al riesgo. Estas situaciones requieren planificación previa: delimitar la zona, informar al personal, reducir el número de expuestos y elegir controles temporales. Al finalizar se realiza limpieza segura y se verifica la recuperación del control normal. La urgencia de una reparación no elimina el riesgo cancerígeno. La práctica exigirá comprobar el control sobre un equipo o escenario, reconocer señales de pérdida de eficacia y proponer una corrección que no introduzca riesgos adicionales.

Profundización técnica y criterio preventivo

Se limita acceso, número y tiempo; se aíslan energías; se aplican captación o humedad temporal; se selecciona EPI por concentración prevista y se limpia antes de reabrir. La urgencia productiva no reduce carcinogenicidad ni justifica exposición desconocida.

Caso práctico razonado

Una tubería de aspiración se rompe y mantenimiento entra sin delimitar porque la reparación durará cinco minutos. La corta duración no elimina el pico ni la dispersión.

Secuencia operativa recomendada

• Parar y delimitar.
• Evaluar tarea y concentración potencial.
• Autorizar personal mínimo con controles y EPI.
• Verificar limpieza y recuperación antes de abrir.

Errores críticos que deben evitarse

• Entrar por ser reparación breve.
• Usar mascarilla no seleccionada.
• Reabrir sin verificar control.

Comprobación antes de continuar

• Parar y delimitar.
• Evaluar tarea y concentración potencial.
• Autorizar personal mínimo con controles y EPI.
• Verificar limpieza y recuperación antes de abrir.

Idea clave

Las tareas excepcionales se planifican antes del fallo y se controlan hasta recuperar la condición normal.$q30$ where segment_id = '722099b5-6e67-4f45-9179-34aed8584930';
update public.lesson_segment_notes set summary = $q31$Objetivo

Definir cuándo el EPI respiratorio es necesario y por qué su uso debe limitarse al riesgo residual.

Explicación detallada

La protección respiratoria se utiliza cuando las medidas técnicas y organizativas no eliminan suficientemente el riesgo, durante exposiciones accidentales o mientras se implantan soluciones más eficaces. Su uso debe limitarse al tiempo imprescindible y ajustarse a la evaluación. La decisión debe indicar para qué tarea, durante cuánto tiempo y con qué factor de protección se utiliza el equipo. Si la exposición es desconocida o puede ser muy alta, una mascarilla filtrante sencilla puede resultar insuficiente. La selección corresponde a la evaluación, no a la preferencia personal. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La evaluación determina tarea, concentración, tiempo y factor de protección. En condiciones desconocidas o muy altas puede requerirse un equipo distinto de una mascarilla filtrante. El EPI se usa durante implantación de controles, exposición accidental o insuficiencia residual, sin sustituir la corrección del foco.

Caso práctico razonado

Tras fallo de aspiración, se propone trabajar todo el turno con FFP2. Sin estimar concentración ni corregir el sistema, no puede asegurarse protección suficiente.

Secuencia operativa recomendada

• Caracterizar contaminante y concentración.
• Seleccionar factor de protección necesario.
• Limitar duración y usuarios.
• Corregir la medida colectiva.

Errores críticos que deben evitarse

• Elegir por comodidad.
• Usar el EPI como solución permanente.
• Entrar con concentración desconocida.

Comprobación antes de continuar

• Caracterizar contaminante y concentración.
• Seleccionar factor de protección necesario.
• Limitar duración y usuarios.
• Corregir la medida colectiva.

Idea clave

El equipo respiratorio se selecciona por riesgo evaluado; no convierte un ambiente desconocido en seguro.$q31$ where segment_id = '61144895-75d9-4338-92ee-2e6a2bbdc3fd';
update public.lesson_segment_notes set summary = $q32$Objetivo

Seleccionar pieza facial, filtro o equipo asistido según exposición, tarea y persona.

Explicación detallada

El tipo de mascarilla, filtro o equipo asistido debe elegirse según la concentración, la tarea, el tiempo de uso y las características del trabajador. No todos los equipos protegen igual ni resultan adecuados para cualquier nivel de exposición. Además del contaminante se valoran esfuerzo físico, temperatura, compatibilidad con gafas o casco y posibles limitaciones médicas. El equipo debe disponer de marcado y documentación aplicables. Un filtro adecuado instalado en una pieza facial que no ajusta sigue ofreciendo una protección deficiente. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

Además del factor de protección se consideran esfuerzo, calor, duración, visión, comunicación, gafas, casco y limitaciones médicas. El marcado y la documentación deben corresponder al uso. Un filtro correcto con fuga facial no alcanza la protección nominal.

Caso práctico razonado

Un trabajador realiza esfuerzo intenso durante dos horas y no tolera bien la resistencia respiratoria. Debe valorarse un equipo asistido u otra solución, no aflojar la mascarilla.

Secuencia operativa recomendada

• Definir factor necesario.
• Evaluar ergonomía y compatibilidad.
• Comprobar documentación y talla.
• Validar ajuste individual y formación.

Errores críticos que deben evitarse

• Elegir un modelo universal.
• Compartir sin descontaminar.
• Aflojar correas para respirar mejor.

Comprobación antes de continuar

• Definir factor necesario.
• Evaluar ergonomía y compatibilidad.
• Comprobar documentación y talla.
• Validar ajuste individual y formación.

Idea clave

La selección correcta combina nivel de protección y capacidad real de uso durante toda la tarea.$q32$ where segment_id = 'b110bd41-663f-4aca-a417-163a517d2166';
update public.lesson_segment_notes set summary = $q33$Objetivo

Garantizar estanqueidad mediante ensayo cuantitativo y comprobación diaria de sellado.

Explicación detallada

Un equipo filtrante solo protege si sella correctamente sobre la cara. Debe realizarse el control de ajuste indicado y la formación práctica incluirá ensayos cuantitativos. Barba, patillas, suciedad o una talla incorrecta pueden romper la estanqueidad. El ensayo cuantitativo comprueba con una medida objetiva si un modelo y talla concretos sellan en esa persona. Debe repetirse cuando cambia la pieza facial o existen cambios físicos relevantes. La comprobación diaria de sellado complementa el ensayo, pero no lo sustituye. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

El ensayo cuantitativo verifica un modelo y talla en una persona; no se transfiere a otra. Se repite tras cambios de pieza facial o cambios físicos relevantes. Barba, patillas, cicatrices, suciedad o gafas interfiriendo rompen el sello. La comprobación diaria no sustituye al ensayo.

Caso práctico razonado

Un trabajador supera el ensayo afeitado y semanas después lleva barba en la línea de sellado. El resultado anterior deja de garantizar estanqueidad.

Secuencia operativa recomendada

• Elegir modelo/talla individual.
• Realizar ensayo cuantitativo.
• Mantener zona de sellado libre.
• Comprobar sellado en cada colocación.

Errores críticos que deben evitarse

• Aprobar por talla de ropa.
• Compartir resultado de ajuste.
• Confiar solo en presión manual.

Comprobación antes de continuar

• Elegir modelo/talla individual.
• Realizar ensayo cuantitativo.
• Mantener zona de sellado libre.
• Comprobar sellado en cada colocación.

Idea clave

El ajuste pertenece al conjunto persona-modelo-talla-condición facial.$q33$ where segment_id = '0682d8a5-3c07-460d-a2ae-390b2da66ba4';
update public.lesson_segment_notes set summary = $q34$Objetivo

Colocar antes de entrar, retirar fuera, descontaminar y almacenar sin deformar ni contaminar.

Explicación detallada

El equipo se coloca antes de entrar en la zona contaminada y se retira después de salir. Debe limpiarse, revisarse, almacenarse protegido y sustituir filtros o componentes según las instrucciones, sin compartirlo si no está previsto y descontaminado. La retirada es un momento crítico porque la superficie exterior puede estar contaminada. Se siguen pasos que eviten tocar cara y vías respiratorias, y después se limpia o desecha según el tipo. El almacenamiento protege de polvo, humedad, deformación, luz y productos químicos. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La superficie exterior puede contener SCR. La retirada evita tocar cara y parte interna; el filtro se cambia por criterio de fabricante/evaluación, no solo cuando se nota resistencia. El almacenamiento protege de polvo, humedad, luz, productos químicos y deformación.

Caso práctico razonado

Una mascarilla reutilizable se deja abierta sobre el salpicadero. El interior puede contaminarse y el calor deformar el sello.

Secuencia operativa recomendada

• Inspeccionar antes de usar.
• Colocar y comprobar en zona limpia.
• Retirar fuera evitando contacto contaminado.
• Limpiar, secar y guardar protegido.

Errores críticos que deben evitarse

• Retirar dentro para hablar.
• Lavar filtros no lavables.
• Guardar en bolsa contaminada.

Comprobación antes de continuar

• Inspeccionar antes de usar.
• Colocar y comprobar en zona limpia.
• Retirar fuera evitando contacto contaminado.
• Limpiar, secar y guardar protegido.

Idea clave

La protección continúa dependiendo del equipo cuando ya no se lleva: conservación y retirada son parte del uso.$q34$ where segment_id = 'cbba34ce-f5a2-4859-8eb3-a9dde8729df3';
update public.lesson_segment_notes set summary = $q35$Objetivo

Evitar ingestión y traslado del contaminante mediante separación limpia/sucia e higiene.

Explicación detallada

En las zonas con riesgo no se debe comer, beber ni fumar. Hay que lavarse antes de las pausas y al terminar, usar las instalaciones higiénicas previstas y evitar trasladar polvo a comedores, vehículos, viviendas u otras zonas limpias. La separación entre zonas limpias y sucias reduce la ingestión y el traslado de contaminante. Lavarse manos y cara, ducharse cuando proceda y respetar vestuarios separados forman parte del control. Comer dentro de la cabina solo sería admisible si el procedimiento garantiza realmente una zona limpia. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

No se come, bebe o fuma en zonas de riesgo. Lavado, duchas cuando proceda y vestuarios separados cortan la vía de transferencia. Una cabina solo es zona limpia si se mantiene cerrada, filtrada y sin contaminación interior; no basta con estar aislada visualmente.

Caso práctico razonado

Un operador come en una cabina con polvo en superficies y ropa contaminada. La presurización no elimina la contaminación ya introducida.

Secuencia operativa recomendada

• Respetar zonas de higiene.
• Lavarse antes de pausas.
• Mantener comedores y cabinas limpios.
• Evitar traslado a vehículos y hogares.

Errores críticos que deben evitarse

• Comer con guantes.
• Usar aire para limpiar ropa.
• Guardar comida junto a EPI.

Comprobación antes de continuar

• Respetar zonas de higiene.
• Lavarse antes de pausas.
• Mantener comedores y cabinas limpios.
• Evitar traslado a vehículos y hogares.

Idea clave

La higiene impide que el polvo pase de la zona de trabajo al organismo y a espacios limpios.$q35$ where segment_id = '9617add8-03d0-4f41-9358-7b2fbbf541b9';
update public.lesson_segment_notes set summary = $q36$Objetivo

Gestionar ropa contaminada sin liberar polvo ni llevarlo al domicilio.

Explicación detallada

La empresa debe proporcionar ropa de protección cuando proceda y organizar su limpieza o descontaminación. La ropa contaminada no debe llevarse a casa. Se guardará separada de la ropa de calle y se manipulará evitando liberar polvo. La ropa no debe sacudirse ni limpiarse con aire comprimido. Se retira siguiendo un método que limite la dispersión, se deposita en recipientes definidos y se lava por un sistema gestionado por la empresa. La familia del trabajador no debe quedar expuesta por contaminación doméstica. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La empresa organiza retirada, almacenamiento, transporte y lavado. La ropa de calle se separa; las prendas no se sacuden ni se soplan; los recipientes evitan dispersión y se identifican. La contaminación doméstica puede exponer a familiares ajenos al trabajo.

Caso práctico razonado

Un trabajador lleva el mono en una bolsa a casa para lavarlo. Aunque vaya cerrado, traslada la responsabilidad y el contaminante fuera del sistema empresarial.

Secuencia operativa recomendada

• Retirar sin sacudir.
• Depositar en recipiente definido.
• Separar de ropa de calle.
• Gestionar limpieza por la empresa.

Errores críticos que deben evitarse

• Lavar junto a ropa familiar.
• Soplar antes de guardar.
• Reutilizar hasta que se vea sucio.

Comprobación antes de continuar

• Retirar sin sacudir.
• Depositar en recipiente definido.
• Separar de ropa de calle.
• Gestionar limpieza por la empresa.

Idea clave

La ropa de trabajo contaminada no abandona el circuito de descontaminación de la empresa.$q36$ where segment_id = '78bf4f11-e2fa-47d2-87db-79f020f00afb';
update public.lesson_segment_notes set summary = $q37$Objetivo

Entender la vigilancia sanitaria específica como detección precoz vinculada al riesgo.

Explicación detallada

La empresa garantizará una vigilancia adecuada y específica realizada por personal sanitario competente. Su contenido y periodicidad se fijan conforme a los protocolos sanitarios y al riesgo, no mediante una regla única basada solo en el porcentaje de sílice de la roca. La vigilancia sanitaria no sustituye el control ambiental ni demuestra por sí sola que un puesto sea seguro. Su objetivo es detectar precozmente posibles efectos y valorar la aptitud con criterios sanitarios. Los resultados colectivos también pueden revelar la necesidad de revisar la prevención. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

Personal sanitario competente define contenido y periodicidad según protocolos, exposición e historia. No existe una regla única basada solo en porcentaje de sílice. Los resultados individuales son confidenciales; las conclusiones preventivas y colectivas pueden exigir revisión de puestos y controles.

Caso práctico razonado

Un reconocimiento sin hallazgos no demuestra que la aspiración funcione ni permite suspender muestreos.

Secuencia operativa recomendada

• Garantizar vigilancia específica.
• Aportar historial de exposición.
• Respetar confidencialidad.
• Revisar prevención ante hallazgos.

Errores críticos que deben evitarse

• Usar reconocimiento como medición ambiental.
• Aplicar igual periodicidad a todos sin riesgo.
• Entregar diagnósticos a mandos no sanitarios.

Comprobación antes de continuar

• Garantizar vigilancia específica.
• Aportar historial de exposición.
• Respetar confidencialidad.
• Revisar prevención ante hallazgos.

Idea clave

Vigilar la salud detecta efectos; controlar el ambiente evita que aparezcan.$q37$ where segment_id = '9b80d683-a81b-4401-9858-b6c05f146cc0';
update public.lesson_segment_notes set summary = $q38$Objetivo

Mantener un historial coherente de puestos, tareas, tiempos y resultados a lo largo de la vida laboral.

Explicación detallada

Los resultados de exposición de cada trabajador se registran para conocer el riesgo acumulado y se incorporan a su expediente médico. Esta trazabilidad permite relacionar los puestos, tareas, tiempos y mediciones con la vigilancia de la salud. El historial debe poder seguir cambios de puesto, centros, tareas y resultados a lo largo del tiempo. Los datos médicos permanecen bajo confidencialidad sanitaria, mientras que la empresa gestiona la información preventiva necesaria. Una trazabilidad incompleta dificulta valorar la dosis acumulada. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

La dosis acumulada no coincide con el último resultado. Cambios de centro, contrata, tarea y controles deben quedar trazados. Las fichas se incorporan al expediente médico, mientras la empresa conserva los registros preventivos previstos. La falta de continuidad limita la interpretación sanitaria.

Caso práctico razonado

Un trabajador rota entre perforación y cabina, pero todas las mediciones figuran bajo “operario”. Sin tareas y tiempos, el historial pierde utilidad.

Secuencia operativa recomendada

• Identificar puesto y tarea real.
• Registrar fechas, duración y controles.
• Vincular mediciones al trabajador.
• Conservar y transferir según obligaciones.

Errores críticos que deben evitarse

• Usar categorías genéricas.
• Borrar datos al cambiar de puesto.
• Mezclar datos médicos con acceso general.

Comprobación antes de continuar

• Identificar puesto y tarea real.
• Registrar fechas, duración y controles.
• Vincular mediciones al trabajador.
• Conservar y transferir según obligaciones.

Idea clave

La trazabilidad convierte resultados aislados en una historia de exposición interpretable.$q38$ where segment_id = '7af3924f-18d6-46b5-9bdf-cc11409fe510';
update public.lesson_segment_notes set summary = $q39$Objetivo

Comunicar fallos de control con información suficiente y detener cuando comprometan protección.

Explicación detallada

El trabajador debe avisar si una perforadora emite polvo, falla una boquilla, una cabina no presuriza, la ventilación se detiene o se limpia en seco. Comunicarlo pronto permite corregir la causa antes de que afecte a más personas. Una comunicación eficaz describe el equipo, el síntoma del fallo, el momento y la tarea afectada. También indica si se ha detenido el trabajo o delimitado la zona. Avisar sin abandonar la exposición o sin impedir que otro ocupe el puesto puede resultar insuficiente. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

El aviso debe identificar equipo, síntoma, momento, tarea, personas afectadas y condición adoptada. Comunicar sin salir del foco o sin impedir relevo no controla la exposición. Las reglas deben indicar qué defectos obligan a parada, zona restringida o método alternativo.

Caso práctico razonado

Una cabina pierde presión. El operador envía un mensaje pero sigue dos horas con ventanas cerradas. La comunicación no compensa la barrera perdida.

Secuencia operativa recomendada

• Detectar señal o indicador.
• Salir o detener según criterio.
• Delimitar y evitar relevo expuesto.
• Comunicar datos y registrar corrección.

Errores críticos que deben evitarse

• Avisar al final del turno.
• Abrir ventanas para ventilar.
• Continuar por no ver polvo.

Comprobación antes de continuar

• Detectar señal o indicador.
• Salir o detener según criterio.
• Delimitar y evitar relevo expuesto.
• Comunicar datos y registrar corrección.

Idea clave

Un aviso eficaz cambia la condición de trabajo y evita que otros hereden el riesgo.$q39$ where segment_id = '7f535354-e8b1-4c9a-b66f-73e6147d0476';
update public.lesson_segment_notes set summary = $q40$Objetivo

Actuar ante síntomas sin usar su presencia o ausencia como medida ambiental.

Explicación detallada

La aparición de tos persistente, dificultad respiratoria u otros síntomas debe comunicarse al servicio sanitario, sin esperar al reconocimiento programado. Los síntomas no sirven para medir la exposición, pero requieren valoración y pueden motivar la revisión de las medidas preventivas. La consulta sanitaria temprana permite valorar causas y decidir si procede adaptar el trabajo. No debe culpabilizarse al trabajador ni ocultarse información. Paralelamente se revisan mediciones, controles y personas potencialmente afectadas, porque un síntoma puede señalar una deficiencia colectiva. El alumno deberá demostrar la actuación correcta, explicar cuándo detenerse, comunicar o pedir apoyo especializado y distinguir la protección individual de las medidas colectivas prioritarias.

Profundización técnica y criterio preventivo

Tos persistente o disnea requieren consulta sanitaria temprana. Paralelamente se revisan exposición, controles y posibles personas comparables, sin invadir confidencialidad. Un síntoma puede tener otras causas, pero no se ignora ni se atribuye automáticamente sin valoración.

Caso práctico razonado

Dos trabajadores del mismo área comunican tos. El servicio sanitario evalúa y prevención revisa captación y mediciones; no se espera al reconocimiento anual.

Secuencia operativa recomendada

• Comunicar al servicio sanitario.
• Valorar urgencia y aptitud.
• Revisar tareas y controles.
• Proteger confidencialidad y no culpabilizar.

Errores críticos que deben evitarse

• Autodiagnosticarse silicosis.
• Esperar al examen periódico.
• Ocultar síntomas por temor laboral.

Comprobación antes de continuar

• Comunicar al servicio sanitario.
• Valorar urgencia y aptitud.
• Revisar tareas y controles.
• Proteger confidencialidad y no culpabilizar.

Idea clave

Los síntomas activan atención sanitaria y revisión preventiva, no sustituyen el diagnóstico ni la medición.$q40$ where segment_id = 'a7af8b7c-3864-485a-843e-0965e8c291f7';
update public.lesson_segment_notes set summary = $q41$Objetivo

Mantener un DSS capaz de demostrar decisiones, controles, responsables y revisión.

Explicación detallada

La empresa debe conservar la documentación exigida para los trabajos con riesgo de sílice e integrarla en el Documento sobre Seguridad y Salud. Debe incluir la evaluación, los criterios de muestreo, los resultados y las medidas de prevención y protección. La documentación debe permitir reconstruir por qué se eligió una medida y comprobar si sigue siendo válida. Incluye puestos, tareas, estrategia de medición, resultados, mantenimiento, formación y acciones correctoras. Un archivo extenso pero desactualizado no cumple la función preventiva del DSS. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La documentación integra evaluación, estrategia de muestreo, resultados, medidas, mantenimiento, formación y acciones correctoras. Debe permitir reconstruir por qué se tomó una decisión y si sigue vigente. Un archivo desactualizado o sin conexión con el trabajo real no cumple su función.

Caso práctico razonado

El DSS incluye una aspiración que fue retirada meses atrás. Aunque el documento sea extenso, describe barreras inexistentes y debe actualizarse.

Secuencia operativa recomendada

• Controlar versión y responsables.
• Vincular evaluación y medidas.
• Adjuntar criterios de muestreo.
• Cerrar acciones con verificación.

Errores críticos que deben evitarse

• Archivar sin revisar.
• Copiar un DSS de otro centro.
• Registrar medidas sin responsables.

Comprobación antes de continuar

• Controlar versión y responsables.
• Vincular evaluación y medidas.
• Adjuntar criterios de muestreo.
• Cerrar acciones con verificación.

Idea clave

Documentar no es acumular papel: es conservar evidencia vigente y trazable para decidir.$q41$ where segment_id = '1bf30edd-740e-4f9f-8ed4-b926fce0670d';
update public.lesson_segment_notes set summary = $q42$Objetivo

Completar fichas individualizadas con contexto suficiente para interpretar y comparar mediciones.

Explicación detallada

Los resultados de las tomas de muestras se registran mediante fichas individualizadas. Estas deben permitir identificar el puesto, la jornada, el equipo, las condiciones de trabajo y los resultados de polvo respirable y sílice cristalina respirable. La ficha debe relacionar resultado y condiciones: trabajador, puesto, duración, caudal, volumen, material, controles y anomalías. Esa información hace comparables las campañas y ayuda a explicar cambios. Sin contexto, dos concentraciones numéricamente distintas pueden interpretarse de forma errónea. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La ficha incluye trabajador/puesto, jornada, tareas, material, controles, aparato, caudal, volumen, incidencias y resultados de polvo y SCR. Una cifra sin condiciones no permite explicar diferencias ni saber si representa el escenario habitual. La calidad del dato comienza en el registro de campo.

Caso práctico razonado

Dos muestras difieren mucho; una se tomó con lluvia y otra con avería de riego, pero la ficha no lo indica. La comparación pierde capacidad diagnóstica.

Secuencia operativa recomendada

• Identificar persona, puesto y fecha.
• Describir tareas y controles.
• Registrar equipo, caudal y duración.
• Anotar incidencias y resultados.

Errores críticos que deben evitarse

• Omitir condiciones meteorológicas relevantes.
• Rellenar después de memoria.
• Confundir polvo respirable y SCR.

Comprobación antes de continuar

• Identificar persona, puesto y fecha.
• Describir tareas y controles.
• Registrar equipo, caudal y duración.
• Anotar incidencias y resultados.

Idea clave

La ficha convierte una concentración en evidencia auditable de una jornada concreta.$q42$ where segment_id = '34fc1ea1-657f-4ffa-a839-edc8bfeb62f0';
update public.lesson_segment_notes set summary = $q43$Objetivo

Cumplir remisiones periódicas sin retrasar el análisis y la acción interna.

Explicación detallada

Las fichas estadísticas con los resultados se envían al Instituto Nacional de Silicosis al menos cada cuatrimestre. Además, se presentan anualmente a la Autoridad Minera junto con las modificaciones del Documento sobre Seguridad y Salud. La obligación de remisión no sustituye el análisis interno. La empresa debe revisar resultados al recibirlos, informar a quienes corresponda y activar acciones si detecta desviaciones. Esperar al envío anual para reaccionar perdería la finalidad preventiva de la medición. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

Las fichas estadísticas se envían al INS al menos cuatrimestralmente y anualmente a la Autoridad Minera junto con modificaciones del DSS. La empresa debe analizar al recibir resultados, informar y corregir. La remisión administrativa no es una fase de espera.

Caso práctico razonado

Un resultado supera el VLA en febrero y se propone actuar al envío anual. Debe intervenirse de inmediato y después comunicar conforme al calendario.

Secuencia operativa recomendada

• Revisar resultado al recibirlo.
• Activar medidas y comunicación interna.
• Enviar al INS cuatrimestralmente.
• Presentar anualmente a Autoridad Minera.

Errores críticos que deben evitarse

• Esperar al cierre anual.
• Enviar sin analizar.
• Corregir el dato para evitar incidencia.

Comprobación antes de continuar

• Revisar resultado al recibirlo.
• Activar medidas y comunicación interna.
• Enviar al INS cuatrimestralmente.
• Presentar anualmente a Autoridad Minera.

Idea clave

La obligación de informar nunca aplaza la obligación de proteger.$q43$ where segment_id = '24c591fb-fbb5-4805-b0f3-3e12d07debfe';
update public.lesson_segment_notes set summary = $q44$Objetivo

Comunicar enfermedades reconocidas y utilizar cada caso para revisar prevención.

Explicación detallada

Todo caso reconocido de neumoconiosis, silicosis o cáncer de pulmón derivado de la exposición laboral a polvo o sílice debe comunicarse a la Autoridad Minera y al Instituto Nacional de Silicosis, además de las obligaciones laborales aplicables. La comunicación institucional permite mejorar la vigilancia epidemiológica y orientar políticas preventivas. Debe realizarse sin perjuicio de la gestión como enfermedad profesional y de la protección de datos. Cada caso reconocido obliga además a revisar la evaluación y las medidas aplicadas. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

Los casos reconocidos de neumoconiosis, silicosis y cáncer de pulmón laboral por polvo o SCR se comunican a Autoridad Minera e INS, sin perjuicio de otras obligaciones. Se protege la información personal y se revisan evaluación, grupos comparables y barreras. La comunicación no busca culpables, sino prevención y vigilancia.

Caso práctico razonado

Se reconoce silicosis en un extrabajador. El tiempo transcurrido no elimina la necesidad de comunicación y revisión de exposiciones históricas comparables.

Secuencia operativa recomendada

• Activar circuitos sanitario/laboral.
• Comunicar a organismos exigidos.
• Preservar confidencialidad.
• Revisar puestos y medidas.

Errores críticos que deben evitarse

• Difundir el diagnóstico en la plantilla.
• Limitarse al trámite.
• No revisar por ser extrabajador.

Comprobación antes de continuar

• Activar circuitos sanitario/laboral.
• Comunicar a organismos exigidos.
• Preservar confidencialidad.
• Revisar puestos y medidas.

Idea clave

Cada enfermedad reconocida es también una señal preventiva que obliga a comprobar el sistema.$q44$ where segment_id = '9e4992d8-b1d8-4581-84bc-0b176fc413c4';
update public.lesson_segment_notes set summary = $q45$Objetivo

Proporcionar información precisa, comprensible y vinculada al puesto real.

Explicación detallada

La información debe explicar los materiales y tareas de riesgo, los posibles efectos sobre la salud, los resultados de la evaluación, las medidas preventivas, los procedimientos de emergencia y el uso correcto de los equipos de protección. La información se adapta al lenguaje, experiencia y tareas del grupo. Debe explicar qué hacer ante un fallo, dónde consultar resultados y a quién comunicar incidencias. Una presentación genérica sin relación con la explotación difícilmente modifica conductas ni demuestra una formación adecuada. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

Debe explicar materiales, tareas, efectos, resultados, controles, emergencias, EPI y canales de comunicación. Se adapta a idioma, experiencia y responsabilidad. Una presentación general no enseña qué hacer cuando falla una boquilla concreta o cómo consultar un resultado individual.

Caso práctico razonado

Una contrata recibe un folleto genérico, pero desconoce zonas restringidas y alarmas del centro. La información no es suficiente para entrar.

Secuencia operativa recomendada

• Explicar riesgos del centro y tarea.
• Mostrar controles y fallos críticos.
• Indicar actuación y contactos.
• Comprobar comprensión.

Errores críticos que deben evitarse

• Entregar solo para firma.
• Usar lenguaje no entendido.
• Omitir resultados y cambios.

Comprobación antes de continuar

• Explicar riesgos del centro y tarea.
• Mostrar controles y fallos críticos.
• Indicar actuación y contactos.
• Comprobar comprensión.

Idea clave

Informar es conseguir que la persona sepa reconocer, decidir y actuar, no solo que reciba un documento.$q45$ where segment_id = 'e09ad3ff-e66f-4c6a-b9d7-47a83b7a3aac';
update public.lesson_segment_notes set summary = $q46$Objetivo

Acreditar competencia teórica y práctica, no mera asistencia.

Explicación detallada

Cada trabajador debe recibir formación suficiente y adecuada para su puesto, tanto teórica como práctica. No basta con entregar documentación: hay que comprender los riesgos, aplicar las medidas de control y demostrar el uso correcto de la protección respiratoria. La parte práctica puede incluir inspección de cabinas y captaciones, identificación de focos, demostración de limpieza y ensayo de ajuste respiratorio. La competencia se comprueba observando la ejecución, no solo mediante asistencia. Los errores detectados durante la práctica se corrigen antes de volver al puesto. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La práctica incluye identificación de focos, inspección de controles, limpieza segura, colocación y retirada de EPI y ensayo cuantitativo de ajuste. La evaluación observa ejecución y corrige errores antes del puesto. Las locuciones y diapositivas apoyan, pero no sustituyen por sí solas la práctica real en el puesto.

Caso práctico razonado

Un alumno aprueba test pero no consigue sellado facial. No se considera competente para usar ese equipo hasta corregir selección y práctica.

Secuencia operativa recomendada

• Explicar fundamentos.
• Demostrar procedimientos.
• Observar ejecución individual.
• Registrar evaluación y corrección.

Errores críticos que deben evitarse

• Convalidar por experiencia.
• Usar solo cuestionario.
• Dar por apto tras una firma.

Comprobación antes de continuar

• Explicar fundamentos.
• Demostrar procedimientos.
• Observar ejecución individual.
• Registrar evaluación y corrección.

Idea clave

La competencia preventiva se demuestra haciendo correctamente la tarea en condiciones representativas.$q46$ where segment_id = 'f649ca3b-4b87-4b11-9a47-30a2ebbff1d0';
update public.lesson_segment_notes set summary = $q47$Objetivo

Aplicar repetición mínima anual y actualización extraordinaria ante cambios.

Explicación detallada

La formación frente al polvo y la sílice debe repetirse, como mínimo, una vez al año. También se actualizará cuando cambien las funciones, el puesto, el lugar de trabajo, la tecnología, los equipos o los conocimientos sobre el riesgo. El refuerzo anual debe recuperar los riesgos esenciales y centrarse también en cambios, incidentes, mediciones y fallos observados desde la sesión anterior. Completar este curso no elimina esa repetición. La actualización anual mantiene la formación conectada con el trabajo real. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La formación se repite al menos una vez al año y se adapta a cambios de función, puesto, lugar, tecnología, equipos o conocimiento. Completar este curso no elimina el refuerzo anual mínimo. La sesión anual debe incorporar mediciones, fallos e incidentes recientes.

Caso práctico razonado

Se realiza el curso en enero y en julio cambia la tecnología de captación. La actualización procede en julio, no al siguiente enero.

Secuencia operativa recomendada

• Programar refuerzo anual.
• Definir disparadores por cambio.
• Adaptar a puesto y resultados.
• Conservar evidencia teórica y práctica.

Errores críticos que deben evitarse

• Confundir la realización del curso con una exención de la formación anual.
• Repetir material sin cambios.
• Esperar a aniversario tras nueva tecnología.

Comprobación antes de continuar

• Programar refuerzo anual.
• Definir disparadores por cambio.
• Adaptar a puesto y resultados.
• Conservar evidencia teórica y práctica.

Idea clave

Anual es frecuencia mínima; el cambio relevante exige formación antes.$q47$ where segment_id = '5aa67069-1796-4c65-9b48-bacccec1b5a8';
update public.lesson_segment_notes set summary = $q48$Objetivo

Convertir experiencia de trabajadores y representantes en mejora verificada.

Explicación detallada

Los trabajadores y sus representantes deben recibir información y participar conforme a la normativa preventiva. Su experiencia ayuda a detectar focos, fallos de mantenimiento y situaciones reales que pueden no aparecer durante una visita puntual. La participación convierte la experiencia diaria en información preventiva. Operadores y mantenedores pueden señalar boquillas que se obstruyen, puertas que no sellan o momentos con emisiones anormales. Estas observaciones se contrastan y se incorporan a la mejora, sin sustituir la evaluación técnica. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La participación ayuda a detectar emisiones, obstrucciones, fallos de sellado y tareas no previstas. Las observaciones se registran, contrastan y responden; no sustituyen medición o competencia técnica. Cerrar el ciclo exige comunicar qué se decidió y por qué.

Caso práctico razonado

Operadores informan de polvo al arrancar cada mañana. Aunque una visita posterior no lo observe, se investiga el patrón y el arranque.

Secuencia operativa recomendada

• Abrir canales de comunicación.
• Registrar observación y contexto.
• Investigar con participación.
• Responder y verificar la medida.

Errores críticos que deben evitarse

• Descartar por no reproducirse.
• Sustituir medición por opinión.
• No informar del cierre.

Comprobación antes de continuar

• Abrir canales de comunicación.
• Registrar observación y contexto.
• Investigar con participación.
• Responder y verificar la medida.

Idea clave

La participación aporta conocimiento del trabajo real; la evaluación técnica lo transforma en prevención.$q48$ where segment_id = '32510752-56f6-4c60-8f5c-56ec028b1c87';
update public.lesson_segment_notes set summary = $q49$Objetivo

Realizar una comprobación previa observable de controles colectivos, EPI y zonas.

Explicación detallada

Antes de trabajar, comprueba que funcionan el riego, la aspiración, la ventilación o la presurización de la cabina. Verifica el estado del equipo respiratorio, conoce las zonas restringidas y comunica cualquier anomalía antes de exponerte. La comprobación previa se convierte en una rutina observable: mirar, probar, registrar y comunicar. Si un control esencial no funciona, se aplica el criterio definido de parada o trabajo alternativo. Empezar confiando en que el sistema se recuperará durante el turno aumenta innecesariamente la dosis. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La rutina es mirar, probar, registrar y comunicar. Se verifican riego, aspiración, ventilación, presión de cabina, filtros, EPI y restricciones. El procedimiento define qué fallo obliga a parada y qué trabajo alternativo es seguro. Comenzar esperando que el control se recupere añade dosis evitable.

Caso práctico razonado

La aspiración no alcanza depresión mínima al inicio. Aunque suele estabilizarse, no se expone al personal hasta cumplir criterio o aplicar alternativa autorizada.

Secuencia operativa recomendada

• Revisar indicadores y estado físico.
• Probar funcionamiento antes del foco.
• Registrar anomalías.
• Parar o cambiar tarea según criterio.

Errores críticos que deben evitarse

• Arrancar para ver si mejora.
• Confiar en ausencia de nube.
• Dejar el aviso al siguiente turno.

Comprobación antes de continuar

• Revisar indicadores y estado físico.
• Probar funcionamiento antes del foco.
• Registrar anomalías.
• Parar o cambiar tarea según criterio.

Idea clave

La jornada empieza cuando las barreras están operativas, no cuando arranca el proceso.$q49$ where segment_id = '81a87be6-80d8-4d8b-848a-468ca1feeee6';
update public.lesson_segment_notes set summary = $q50$Objetivo

Integrar control en origen, mantenimiento, conducta, medición y mejora diaria.

Explicación detallada

La silicosis es prevenible si se controla el polvo desde el origen, se mantienen las medidas colectivas y cada persona aplica los procedimientos. Trabajar sin nube visible no garantiza seguridad: la evaluación, la medición y la disciplina preventiva deben acompañar cada tarea. El cierre del curso debe traducirse en compromisos verificables: controlar el foco, mantener cabinas y captaciones, limpiar sin dispersar, usar correctamente el EPI y comunicar desviaciones. La prevención funciona cuando estas decisiones se repiten cada día y quedan respaldadas por mediciones y supervisión. La evaluación aplicará este criterio a un caso de explotación, comprobará que la respuesta queda trazable y exigirá una medida concreta, un responsable y un plazo de seguimiento.

Profundización técnica y criterio preventivo

La silicosis es prevenible si las barreras se repiten y verifican. El compromiso debe traducirse en acciones observables: no barrer en seco, mantener cierres, informar fallos, conservar EPI, respetar zonas y analizar tendencias. La ausencia de nube no elimina la disciplina.

Caso práctico razonado

Una planta obtiene buenos resultados durante un año. El éxito confirma el sistema utilizado; no justifica desmontarlo, sino mantenerlo y buscar mejora.

Secuencia operativa recomendada

• Controlar el foco.
• Mantener y comprobar barreras.
• Medir y analizar tendencias.
• Comunicar y corregir desviaciones.

Errores críticos que deben evitarse

• Depender de la memoria individual.
• Relajar controles por buenos datos.
• Normalizar fallos pequeños.

Comprobación antes de continuar

• Controlar el foco.
• Mantener y comprobar barreras.
• Medir y analizar tendencias.
• Comunicar y corregir desviaciones.

Idea clave

La prevención funciona cuando cada resultado favorable se utiliza para sostener y mejorar las barreras que lo hicieron posible.$q50$ where segment_id = '3c573ab6-5d5d-45c7-81e7-abd819c7d0ea';

-- 4) Retitular los 5 bloques definitivos
update public.course_modules set title = 'El polvo, la sílice cristalina respirable y sus efectos sobre la salud' where id = '2ad93906-d41f-47f0-aeba-d1cfab89a54b';
update public.course_modules set title = 'Marco normativo, identificación, evaluación y medición de la exposición' where id = '73954a5e-90b0-4522-936c-3e30970ceb21';
update public.course_modules set title = 'Prevención y reducción de la exposición mediante medidas colectivas' where id = 'e8315d2b-2d7c-49cd-82d4-6a5b94840b1b';
update public.course_modules set title = 'Protección individual, higiene, vigilancia de la salud y actuación del trabajador' where id = '29430c70-b110-4b6e-867c-c54c186090f6';
update public.course_modules set title = 'Documentación, información, formación anual y aplicación práctica' where id = '0d1de5d9-111b-403a-a583-4faf0803f2f9';

-- 5) Desactivar (sin borrar) el antiguo modulo 6 "Vigilancia, informacion y evaluacion" (audios largos, fuera del nuevo esquema de 5 bloques)
update public.lessons set active = false where id = 'fce03d31-c6fe-43e5-869a-f8c187440ff5';
update public.quizzes set active = false where id = '643a293e-737d-4d16-bad9-02bb901518d3';

-- 6) Reconstruir los tests: exactamente 50 preguntas definitivas (10 por bloque), sustituyendo el banco anterior de 15/bloque
delete from public.question_options where question_id in (select id from public.questions where question_bank_id in ('112be636-5e55-41cb-bad6-d559cfabda4a','89bb2ce0-59d1-4954-b070-c7aaa24c2684','c029b57c-a96e-40fe-bc33-96254f80124b','39993e17-c53a-4393-a164-fdcd9331bba3','88399a6b-1a9e-498c-84ab-b0b7698bddf8'));
delete from public.questions where question_bank_id in ('112be636-5e55-41cb-bad6-d559cfabda4a','89bb2ce0-59d1-4954-b070-c7aaa24c2684','c029b57c-a96e-40fe-bc33-96254f80124b','39993e17-c53a-4393-a164-fdcd9331bba3','88399a6b-1a9e-498c-84ab-b0b7698bddf8');

do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Cuál de las siguientes definiciones describe mejor el polvo?', 'single_choice', 1.00, true, '9212a860-3fba-45cf-9418-0e25322d2930') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Un gas generado exclusivamente por combustión.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Materia sólida particulada y dispersa en la atmósfera.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Únicamente arena gruesa depositada sobre superficies.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Vapor de agua visible en el ambiente.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿En qué formas aparece habitualmente la sílice cristalina considerada en el curso?', 'single_choice', 1.00, true, '1327fe65-5b4e-4af0-90e5-eef42b93bd80') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Cuarzo y cristobalita.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Caliza y yeso.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Hierro y cobre.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Sal y arcilla.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Qué condiciones deben concurrir para que exista riesgo de exposición a sílice cristalina respirable?', 'single_choice', 1.00, true, '775c6f23-3126-48a7-8efb-c5efa07cc799') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Únicamente que exista viento.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Que el trabajador se encuentre al aire libre.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Que exista un material con sílice cristalina y una tarea capaz de liberar partículas respirables al aire.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Que exista polvo visible en el suelo.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Cuál de las siguientes actividades puede generar polvo respirable?', 'single_choice', 1.00, true, '6f2f2fe4-3884-4a2a-a208-2faa367c8d02') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Perforación.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Trituración.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Carga y transporte.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Todas las anteriores.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Qué fracción del polvo puede alcanzar las zonas profundas del pulmón y es especialmente relevante en la exposición a sílice?', 'single_choice', 1.00, true, '692226a1-ae39-4cd6-8b75-7a48676653a5') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'La fracción sedimentada.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'La fracción respirable.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'La fracción compactada.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'La fracción visible.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', 'Si deja de verse una nube de polvo, ¿puede seguir existiendo riesgo por partículas respirables?', 'single_choice', 1.00, true, '147b0a7a-edf7-46d5-89ef-6fca6bd745c4') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Sí, las partículas finas pueden permanecer suspendidas aunque no sean visibles.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'No, si no se ve polvo el ambiente es seguro.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Solo durante la noche.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Solo si la temperatura supera 30 ºC.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Cuál de las siguientes enfermedades está directamente asociada a la exposición prolongada a sílice cristalina respirable?', 'single_choice', 1.00, true, '07fa3a26-eb0a-40e5-b5fb-ed207859c117') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Esguince.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Otitis.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Silicosis.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Miopía.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Cuál de las siguientes afirmaciones sobre la silicosis es correcta?', 'single_choice', 1.00, true, 'ead51b6e-28be-47ff-b9b1-354d078e853c') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Es una enfermedad leve que desaparece al dejar de trabajar.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Solo aparece si el polvo es visible.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Se cura automáticamente al cesar la exposición.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Es una enfermedad pulmonar grave e irreversible y puede evolucionar incluso después de cesar la exposición.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Cuáles son las formas de evolución de la silicosis tratadas en el curso?', 'single_choice', 1.00, true, '960f2b08-1848-4540-98df-e8d1aa1f7f5d') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Crónica, acelerada y aguda.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Leve, media y grave exclusivamente.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Estacional y permanente.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Húmeda y seca.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('112be636-5e55-41cb-bad6-d559cfabda4a', '¿Qué factores pueden influir en la generación y dispersión del polvo en una explotación?', 'single_choice', 1.00, true, '68b7dc42-fc52-40d3-91cb-5a778497205b') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Solo el color de la maquinaria.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'La humedad de la roca, el proceso, la maquinaria, el estado de las pistas, la climatología y el viento, entre otros.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Únicamente la hora del día.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Exclusivamente el número de trabajadores.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', '¿Qué norma aprueba la actual ITC 02.0.02 sobre polvo y sílice cristalina respirable en minería?', 'single_choice', 1.00, true, 'd843a759-41f5-449b-bdc8-078ca1bd1e66') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Real Decreto 773/1997.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Ley 39/2015.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Orden TED/723/2021.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Orden ITC/2585/2007 como norma actualmente vigente.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', 'Los trabajos que generan exposición a polvo respirable de sílice cristalina generado en un proceso de trabajo se consideran:', 'single_choice', 1.00, true, '05f813fd-38c2-4a22-a4b2-89003ff14e6d') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Actividades sin riesgo químico.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Procedimientos cancerígenos.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Actividades exentas de evaluación.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Riesgos exclusivamente ambientales.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', '¿Cuáles son los valores límite de exposición diaria que deben cumplirse simultáneamente según la ITC 02.0.02?', 'single_choice', 1.00, true, 'd2b0cd4c-7fd4-4b19-b513-ab7313d847e6') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, '1 mg/m³ de polvo respirable y 0,10 mg/m³ de SCR.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, '10 mg/m³ de polvo respirable y 0,5 mg/m³ de SCR.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, '0,05 mg/m³ de polvo respirable y 3 mg/m³ de SCR.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, '3 mg/m³ de polvo respirable y 0,05 mg/m³ de sílice cristalina respirable.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', 'Una medición de sílice cristalina respirable por debajo del valor límite significa que:', 'single_choice', 1.00, true, '075784de-2db2-444e-a7cb-f028fe9d1e8e') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Debe seguir reduciéndose la exposición hasta un nivel tan bajo como técnicamente sea posible.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Pueden eliminarse todas las medidas preventivas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Ya no es necesario revisar el proceso.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'La sílice deja de considerarse peligrosa.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', 'Para identificar correctamente el riesgo de exposición a SCR, ¿qué debe estudiarse?', 'single_choice', 1.00, true, '64af9e0b-cf2e-4e60-98d7-fcda1f9627ad') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Solo el nombre comercial de la empresa.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Los materiales y las tareas que pueden poner en suspensión SCR, incluyendo posibles exposiciones por proximidad.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Únicamente las tareas realizadas en oficinas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Solo las zonas donde exista una nube de polvo visible.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', '¿Dónde debe colocarse el muestreador personal para evaluar la exposición del trabajador?', 'single_choice', 1.00, true, '01e1ac20-500d-477e-adfc-c61397eb657c') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'En el suelo.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Sobre la máquina, lejos del trabajador.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'En la zona de respiración del trabajador.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'En una oficina próxima.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', 'Como criterio general, ¿qué duración debe tener una toma de muestras para evaluar la exposición diaria?', 'single_choice', 1.00, true, '7747a074-b020-472f-ad94-81853ca22a93') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Debe extenderse a toda la jornada de trabajo, salvo excepciones justificadas por exigencias analíticas.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Siempre exactamente 15 minutos.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Solo durante la pausa del trabajador.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Únicamente mientras exista polvo visible.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', '¿Con qué frecuencia mínima deben tomarse muestras en los puestos con riesgo de exposición a polvo?', 'single_choice', 1.00, true, '91ba067b-ccec-4ba1-bbcf-fd6286dd00da') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Una vez cada diez años.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Solo después de que aparezca una enfermedad.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Una vez al año en todos los casos.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Al menos una vez cada cuatrimestre del año natural.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', '¿Cada cuánto debe revisarse en todo caso la evaluación de riesgos según la ITC 02.0.02, sin perjuicio de revisarla antes cuando sea necesario?', 'single_choice', 1.00, true, '99c8945f-9deb-4e15-9944-a7307c66a15d') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Cada seis meses.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Cada tres años.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Cada cinco años.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Nunca mientras no haya accidentes.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('89bb2ce0-59d1-4954-b070-c7aaa24c2684', '¿Qué información debe conocer el trabajador respecto a su exposición?', 'single_choice', 1.00, true, '58958a71-e777-44d1-9d67-8a335076a5ef') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Solo si ha existido un incumplimiento.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Únicamente el nombre del laboratorio.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Los riesgos de su puesto, los resultados que le afecten y las medidas implantadas, explicados de forma comprensible.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Ninguna, porque los resultados son exclusivamente de la empresa.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', '¿Cuál es el orden preventivo prioritario frente al polvo?', 'single_choice', 1.00, true, 'fdc342e9-11c2-4b86-a3a1-5228de3bf479') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Actuar primero sobre el trabajador y después sobre el foco.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Evitar o reducir el polvo en el foco, actuar después sobre su propagación y utilizar la protección individual como complemento.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Utilizar siempre mascarilla como única medida.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Esperar a superar el valor límite antes de actuar.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', 'Si no es posible sustituir la roca, ¿qué puede hacerse para reducir la generación de polvo?', 'single_choice', 1.00, true, 'c7b055cd-b5be-413c-8bf6-897cb4a2f546') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Modificar métodos, herramientas, velocidades o secuencias de trabajo.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Eliminar los sistemas de riego.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Aumentar siempre la velocidad de operación.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Sustituir las medidas colectivas por ropa de trabajo.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', '¿Qué función tienen los carenados, capotajes y cerramientos?', 'single_choice', 1.00, true, '3926cd59-a18b-46dd-9b1f-45760b322a6c') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Aumentar la dispersión del polvo.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Sustituir siempre la aspiración.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Limitar la dispersión del polvo en equipos y puntos de transferencia.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Facilitar que el trabajador acceda al foco durante el funcionamiento.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', 'Para que una cabina cerrada y presurizada proteja correctamente al operador es necesario:', 'single_choice', 1.00, true, '1ebe4dbc-79fd-4218-9a08-f6a194d44dcd') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Mantener las ventanas abiertas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Desactivar la filtración cuando no se vea polvo.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Trabajar siempre con la puerta entreabierta.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Mantener puertas y ventanas cerradas y revisar juntas, filtros y funcionamiento del sistema.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', '¿Cuál es el objetivo principal del control por vía húmeda?', 'single_choice', 1.00, true, '1eb0f936-df98-4065-9e91-69baeb399ae3') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Impedir o reducir que las partículas pasen al aire y favorecer su sedimentación.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Secar el material lo antes posible.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Aumentar la velocidad del polvo.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Sustituir todas las demás medidas preventivas.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', '¿Dónde debe actuar preferentemente un sistema de aspiración localizada?', 'single_choice', 1.00, true, 'b1f44cfa-e948-4d21-8489-976e8ebd2c43') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'En el comedor.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Cerca del punto de generación del polvo, antes de que alcance la zona de respiración.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Únicamente en el exterior de la explotación.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Después de que el polvo se haya dispersado por toda la zona.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', '¿Cuál de las siguientes medidas ayuda a reducir las emisiones de polvo en pistas y transporte?', 'single_choice', 1.00, true, '247a5ce5-aa96-41fe-ad4a-5a16eb79530f') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Aumentar la velocidad de los vehículos.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Circular con las cargas siempre descubiertas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Regar o estabilizar pistas, limitar la velocidad y cubrir las cargas cuando proceda.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Evitar la limpieza de ruedas.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', '¿Cuál es una forma adecuada de realizar la limpieza en zonas con riesgo de polvo?', 'single_choice', 1.00, true, '46a818dd-0d43-49b9-9601-003a86306015') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Barrer siempre en seco.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Utilizar aire comprimido de forma rutinaria.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Sacudir manualmente la ropa contaminada.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Utilizar aspiración industrial o métodos por vía húmeda.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', '¿Qué debe hacerse si falla una medida de control y el fallo compromete la exposición?', 'single_choice', 1.00, true, '1e68fb8b-92a7-4919-94f3-42d5f051e7cb') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Comunicarlo y corregirlo antes de continuar cuando el control de la exposición esté comprometido.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Ignorarlo si no se ve una nube.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Esperar al mantenimiento anual.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Abrir todas las ventanas independientemente del proceso.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('c029b57c-a96e-40fe-bc33-96254f80124b', 'Ante una reparación o limpieza extraordinaria con posible aumento de exposición, se debe:', 'single_choice', 1.00, true, '722099b5-6e67-4f45-9179-34aed8584930') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Permitir el acceso a cualquier trabajador.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Limitar el acceso a personal autorizado, reducir el tiempo imprescindible y aplicar medidas adecuadas al riesgo.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Retirar las medidas técnicas para trabajar más rápido.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Evitar cualquier protección respiratoria.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Cuándo debe utilizarse protección respiratoria?', 'single_choice', 1.00, true, '61144895-75d9-4338-92ee-2e6a2bbdc3fd') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Como sustituto permanente de cualquier medida colectiva.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Solo cuando el trabajador vea polvo.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Cuando las medidas técnicas y organizativas no reduzcan suficientemente el riesgo, en situaciones accidentales o mientras se implantan medidas más eficaces.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Únicamente durante las pausas.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿De qué debe depender la selección de una mascarilla, filtro o equipo respiratorio?', 'single_choice', 1.00, true, 'b110bd41-663f-4aca-a417-163a517d2166') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Solo de su color.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'De la concentración, la tarea, el tiempo de uso y las características del trabajador, entre otros factores.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Únicamente del precio.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'De que sea el mismo modelo para toda la plantilla.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Qué puede comprometer el sellado de un equipo de protección respiratoria sobre la cara?', 'single_choice', 1.00, true, '0682d8a5-3c07-460d-a2ae-390b2da66ba4') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'La barba, las patillas, la suciedad o una talla incorrecta.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Llevar calzado de seguridad.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Utilizar casco.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Trabajar en turno de mañana.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Cuándo debe colocarse y retirarse el equipo respiratorio?', 'single_choice', 1.00, true, 'cbba34ce-f5a2-4859-8eb3-a9dde8729df3') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Colocarlo después de entrar en la zona y retirarlo dentro de ella.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Colocarlo solo cuando aparezcan síntomas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Colocarlo al terminar la jornada.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Colocarlo antes de entrar en la zona contaminada y retirarlo después de salir.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Cuál de estas conductas está prohibida en una zona con riesgo de exposición a SCR?', 'single_choice', 1.00, true, '9617add8-03d0-4f41-9358-7b2fbbf541b9') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Lavarse las manos antes de las pausas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Comer, beber o fumar.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Utilizar las instalaciones higiénicas previstas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Evitar trasladar polvo a zonas limpias.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Qué debe hacerse con la ropa de trabajo contaminada?', 'single_choice', 1.00, true, '78bf4f11-e2fa-47d2-87db-79f020f00afb') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Llevarla a casa para lavarla.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Guardarla junto a la ropa de calle.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Mantenerla dentro del circuito de limpieza o descontaminación organizado por la empresa.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Sacudirla con aire comprimido antes de salir.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Quién debe realizar la vigilancia específica de la salud?', 'single_choice', 1.00, true, '9b80d683-a81b-4401-9858-b6c05f146cc0') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Personal sanitario competente.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Cualquier compañero.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'El fabricante de la maquinaria.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Exclusivamente el propio trabajador.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Para qué sirve mantener un historial individual de exposición?', 'single_choice', 1.00, true, '7af3924f-18d6-46b5-9bdf-cc11409fe510') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Para sustituir las mediciones futuras.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Para eliminar la necesidad de vigilancia sanitaria.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Solo para calcular la antigüedad laboral.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Para relacionar puestos, tareas, tiempos y resultados de exposición con la vigilancia de la salud.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', '¿Qué debe hacer un trabajador si detecta que falla una boquilla, la cabina pierde presurización o se detiene la ventilación?', 'single_choice', 1.00, true, '7f535354-e8b1-4c9a-b66f-73e6147d0476') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Continuar hasta terminar el turno.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Comunicar el fallo para que pueda corregirse antes de que aumente la exposición.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Abrir las ventanas de la cabina en todos los casos.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Esperar a que otro trabajador lo comunique.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('39993e17-c53a-4393-a164-fdcd9331bba3', 'Ante tos persistente, dificultad respiratoria u otros síntomas compatibles, el trabajador debe:', 'single_choice', 1.00, true, 'a7af8b7c-3864-485a-843e-0965e8c291f7') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Autodiagnosticarse silicosis.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Esperar necesariamente al siguiente reconocimiento periódico.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Comunicarlo al servicio sanitario para su valoración.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Utilizar una mascarilla diferente sin comunicar nada.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Dónde debe integrarse la documentación específica relativa al riesgo por polvo y sílice en minería?', 'single_choice', 1.00, true, '1bf30edd-740e-4f9f-8ed4-b926fce0670d') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'En el Documento sobre Seguridad y Salud.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Únicamente en las facturas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'En el permiso de circulación de la maquinaria.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Solo en documentación comercial.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Qué deben permitir identificar las fichas individualizadas de medición?', 'single_choice', 1.00, true, '34fc1ea1-657f-4ffa-a839-edc8bfeb62f0') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Solo el nombre del trabajador.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'El puesto, la jornada, el equipo, las condiciones de trabajo y los resultados de polvo respirable y SCR.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Únicamente la marca del equipo de protección.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Solo la fecha de contratación.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿A qué organismo se envían las fichas estadísticas con los resultados al menos cada cuatrimestre?', 'single_choice', 1.00, true, '24c591fb-fbb5-4805-b0f3-3e12d07debfe') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Al ayuntamiento.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Al fabricante de la maquinaria.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Al Instituto Nacional de Silicosis.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Al proveedor de EPIs.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Qué casos reconocidos derivados de la exposición laboral a polvo o sílice deben comunicarse a la Autoridad Minera y al Instituto Nacional de Silicosis?', 'single_choice', 1.00, true, '9e4992d8-b1d8-4581-84bc-0b176fc413c4') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Únicamente resfriados comunes.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Solo accidentes de tráfico.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Ninguna enfermedad.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Neumoconiosis, silicosis y cáncer de pulmón relacionados con dicha exposición.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Qué información debe recibir el trabajador?', 'single_choice', 1.00, true, 'e09ad3ff-e66f-4c6a-b9d7-47a83b7a3aac') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Materiales y tareas de riesgo, efectos sobre la salud, resultados de la evaluación, medidas preventivas, procedimientos de emergencia y uso correcto de los equipos de protección.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Solo el precio de los equipos de protección.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Únicamente el horario de trabajo.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Exclusivamente los resultados cuando se supere el límite.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', 'Según la ITC 02.0.02, la formación del trabajador frente al riesgo por polvo y sílice debe ser:', 'single_choice', 1.00, true, 'f649ca3b-4b87-4b11-9a47-30a2ebbff1d0') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Exclusivamente documental.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Teórica y práctica, suficiente y adecuada para su puesto.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Solo práctica y sin información normativa.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Voluntaria cuando se utilice protección respiratoria.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Con qué frecuencia mínima debe repetirse la labor formativa sobre polvo y sílice cristalina respirables?', 'single_choice', 1.00, true, '5aa67069-1796-4c65-9b48-bacccec1b5a8') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Cada cuatro años.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Una sola vez durante toda la vida laboral.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Al menos una vez al año.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Solo cuando lo solicite el trabajador.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Por qué es importante la consulta y participación de los trabajadores y sus representantes?', 'single_choice', 1.00, true, '32510752-56f6-4c60-8f5c-56ec028b1c87') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Porque sustituye las mediciones higiénicas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Porque permite eliminar la evaluación de riesgos.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Porque les permite decidir libremente si aplican las medidas preventivas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Porque su experiencia puede ayudar a detectar focos, fallos y situaciones reales de exposición.', true);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Qué comprobación debe realizarse antes de comenzar una tarea con riesgo de exposición?', 'single_choice', 1.00, true, '81a87be6-80d8-4d8b-848a-468ca1feeee6') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Verificar que funcionan los sistemas de control, comprobar el estado del equipo respiratorio y comunicar las anomalías antes de exponerse.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Comprobar únicamente que no se vea polvo.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Abrir todas las puertas y ventanas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Esperar a que empiece la tarea para comprobar los controles.', false);
end
$ins$;
do $ins$
declare v_question_id uuid;
begin
  insert into public.questions (question_bank_id, prompt, type, points, active, lesson_audio_segment_id) values ('88399a6b-1a9e-498c-84ab-b0b7698bddf8', '¿Cuál resume mejor el compromiso preventivo diario frente a la SCR?', 'single_choice', 1.00, true, '3c573ab6-5d5d-45c7-81e7-abd819c7d0ea') returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 1, 'Si no se ve polvo, no es necesario aplicar medidas.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 2, 'Controlar el polvo desde el origen, mantener las medidas colectivas y seguir los procedimientos, apoyándose en evaluación y medición.', true);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 3, 'Utilizar siempre únicamente protección respiratoria.', false);
  insert into public.question_options (question_id, position, option_text, is_correct) values (v_question_id, 4, 'Actuar solo después de superar el valor límite.', false);
end
$ins$;

update public.quizzes set question_count = 10 where id = '98eb2887-9e2a-4a34-b4a2-b5edc63908f7';
update public.quizzes set question_count = 10 where id = 'db6970ac-a848-4b22-ad56-6ef7ac0d25a3';
update public.quizzes set question_count = 10 where id = '2c0dfc9d-5009-413a-888c-b032a1591e2e';
update public.quizzes set question_count = 10 where id = 'f4b35ceb-1f8b-4ff9-be91-793a3dc35efa';
update public.quizzes set question_count = 10 where id = 'cbf899d8-af21-40fb-90a2-a7067b00a456';

-- 7) Actualizar la version superviviente: duracion aproximada 3h, precio 78 EUR + IVA, renovacion anual
update public.course_versions set duration_hours = 3, price_net = 78.00, syllabus_summary = $q51$1. El polvo, la sílice cristalina respirable y sus efectos sobre la salud
2. Marco normativo, identificación, evaluación y medición de la exposición
3. Prevención y reducción de la exposición mediante medidas colectivas
4. Protección individual, higiene, vigilancia de la salud y actuación del trabajador
5. Documentación, información, formación anual y aplicación práctica$q51$, renewal_interval_months = 12, stripe_price_id = null where id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315';

-- 8) Retirar (no borrar) la version "20h": deja de listarse/venderse, conserva todo su historico
update public.course_versions set status = 'retired' where id = 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24';

-- 8b) Anadir el recurso "Presentacion completa del curso" a los 5 lecciones de la version superviviente
-- (antes solo existia en la version 20h retirada); reutiliza el mismo PDF combinado, sin duplicarlo.
insert into public.lesson_resources (lesson_id, kind, title, storage_path, downloadable, required, position) values
('ff160ade-4910-461b-9421-bb9686e27011', 'presentation', 'Presentación completa del curso · 50 diapositivas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/resources/formacion-polvo-silice-20h-presentacion-completa.pdf', true, false, 100),
('93560979-7248-46dd-b481-77b90f3c4d9d', 'presentation', 'Presentación completa del curso · 50 diapositivas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/resources/formacion-polvo-silice-20h-presentacion-completa.pdf', true, false, 100),
('241fbfc8-113c-4fd0-a653-0bddf42e7300', 'presentation', 'Presentación completa del curso · 50 diapositivas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/resources/formacion-polvo-silice-20h-presentacion-completa.pdf', true, false, 100),
('54f7ca3c-8700-4e2a-ad1b-efa15ab4bdb7', 'presentation', 'Presentación completa del curso · 50 diapositivas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/resources/formacion-polvo-silice-20h-presentacion-completa.pdf', true, false, 100),
('3d673590-9bdb-4b65-b144-a51280635397', 'presentation', 'Presentación completa del curso · 50 diapositivas', 'c0e3eca7-3a09-463d-b1d1-cb8cacfa4d24/resources/formacion-polvo-silice-20h-presentacion-completa.pdf', true, false, 100);

-- 9) Validacion final: 50 segmentos con audio/diapositiva/explicacion, 50 preguntas, 5 quizzes de 10
do $val$
declare
  v_segments int; v_slides int; v_notes int; v_questions int; v_options int; v_quiz_bad int;
begin
  select count(*) into v_segments from public.lesson_audio_segments las join public.lessons l on l.id = las.lesson_id join public.course_modules cm on cm.id = l.module_id where cm.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and cm.position between 1 and 5 and las.audio_storage_path is not null;
  if v_segments <> 50 then raise exception 'Se esperaban 50 segmentos con audio, hay %', v_segments; end if;
  select count(*) into v_slides from public.lesson_segment_slides lss join public.lesson_audio_segments las on las.id = lss.segment_id join public.lessons l on l.id = las.lesson_id join public.course_modules cm on cm.id = l.module_id where cm.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and cm.position between 1 and 5 and lss.image_storage_path is not null;
  if v_slides <> 50 then raise exception 'Se esperaban 50 diapositivas, hay %', v_slides; end if;
  select count(*) into v_notes from public.lesson_segment_notes lsn join public.lesson_audio_segments las on las.id = lsn.segment_id join public.lessons l on l.id = las.lesson_id join public.course_modules cm on cm.id = l.module_id where cm.course_version_id = 'cd155d2b-1c6d-4cdd-8f40-84c830f75315' and cm.position between 1 and 5 and length(lsn.summary) > 100;
  if v_notes <> 50 then raise exception 'Se esperaban 50 explicaciones, hay %', v_notes; end if;
  select count(*) into v_questions from public.questions where question_bank_id in ('112be636-5e55-41cb-bad6-d559cfabda4a','89bb2ce0-59d1-4954-b070-c7aaa24c2684','c029b57c-a96e-40fe-bc33-96254f80124b','39993e17-c53a-4393-a164-fdcd9331bba3','88399a6b-1a9e-498c-84ab-b0b7698bddf8');
  if v_questions <> 50 then raise exception 'Se esperaban 50 preguntas, hay %', v_questions; end if;
  select count(*) into v_options from public.question_options where question_id in (select id from public.questions where question_bank_id in ('112be636-5e55-41cb-bad6-d559cfabda4a','89bb2ce0-59d1-4954-b070-c7aaa24c2684','c029b57c-a96e-40fe-bc33-96254f80124b','39993e17-c53a-4393-a164-fdcd9331bba3','88399a6b-1a9e-498c-84ab-b0b7698bddf8'));
  if v_options <> 200 then raise exception 'Se esperaban 200 opciones, hay %', v_options; end if;
  select count(*) into v_quiz_bad from (select question_id, count(*) filter (where is_correct) as n_correct from public.question_options where question_id in (select id from public.questions where question_bank_id in ('112be636-5e55-41cb-bad6-d559cfabda4a','89bb2ce0-59d1-4954-b070-c7aaa24c2684','c029b57c-a96e-40fe-bc33-96254f80124b','39993e17-c53a-4393-a164-fdcd9331bba3','88399a6b-1a9e-498c-84ab-b0b7698bddf8')) group by question_id having count(*) filter (where is_correct) <> 1) x;
  if v_quiz_bad <> 0 then raise exception 'Hay % preguntas sin exactamente 1 respuesta correcta', v_quiz_bad; end if;
end
$val$;
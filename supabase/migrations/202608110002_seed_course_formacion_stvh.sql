-- InmínerCampus
-- Alta del curso interno «Formación STVH».
--   · Acceso exclusivamente mediante código emitido por administración.
--   · Contenido: la presentación de 57 diapositivas, sin audio ni vídeo.
--   · Test final de 26 preguntas: 3 rondas perfectas consecutivas.
--   · Materiales de origen descargables y contrato de confidencialidad.
--
-- Requiere la migración 202608110001. Es idempotente: puede reejecutarse.

begin;

do $$
declare
  v_course_id uuid;
  v_version_id uuid;
  v_module_id uuid;
  v_lesson_id uuid;
  v_bank_id uuid;
  v_quiz_id uuid;
  v_segment_id uuid;
  v_question_id uuid;
begin

  insert into public.courses (
    slug, title, short_description, description, specialty, status,
    access_mode, listed, cover_storage_path
  )
  values (
    'formacion-stvh',
    'Formación STVH',
    'Medición de dimensiones y masas de vehículos y registro de datos primarios en la inspección.',
    'Formación interna de LVH Carricoche sobre la sistemática y los criterios de medición de dimensiones de los vehículos inspeccionados, las exenciones dimensionales aplicables por categoría, la medición de dimensiones y masas en remolques y tractores agrícolas y el registro de los datos primarios en las fichas de inspección LVH-13.1 a LVH-13.6.',
    'Inspección de vehículos',
    'published',
    'access_code',
    false,
    '/images/curso-stvh-portada.jpg'
  )
  on conflict (slug) do update set
    title = excluded.title,
    short_description = excluded.short_description,
    description = excluded.description,
    specialty = excluded.specialty,
    status = excluded.status,
    access_mode = excluded.access_mode,
    listed = excluded.listed,
    cover_storage_path = excluded.cover_storage_path,
    updated_at = now()
  returning id into v_course_id;

  insert into public.course_versions (
    course_id, version_number, duration_hours, modality, objectives,
    target_audience, requirements, syllabus_summary, practice_required,
    required_perfect_streak, price_net, status, published_at
  )
  values (
    v_course_id, 1, 3, 'online',
    jsonb_build_array(
      'Aplicar la sistemática y los criterios de medición de dimensiones de los vehículos inspeccionados.',
      'Identificar los dispositivos y equipos exentos al determinar las dimensiones máximas por categoría.',
      'Medir dimensiones y obtener masas en remolques y tractores agrícolas.',
      'Cumplimentar correctamente las fichas de inspección LVH-13.1 a LVH-13.6.'
    ),
    jsonb_build_array('Personal de inspección de vehículos de LVH Carricoche.'),
    jsonb_build_array('Acceso mediante código facilitado por administración.'),
    'Presentación de 57 diapositivas y test final de 26 preguntas.',
    false, 3, null, 'published', now()
  )
  on conflict (course_id, version_number) do update set
    duration_hours = excluded.duration_hours,
    modality = excluded.modality,
    objectives = excluded.objectives,
    target_audience = excluded.target_audience,
    requirements = excluded.requirements,
    syllabus_summary = excluded.syllabus_summary,
    practice_required = excluded.practice_required,
    required_perfect_streak = excluded.required_perfect_streak,
    price_net = excluded.price_net,
    status = excluded.status,
    published_at = coalesce(public.course_versions.published_at, now()),
    updated_at = now()
  returning id into v_version_id;

  insert into public.course_modules (course_version_id, position, title, description)
  values (
    v_version_id, 1, 'Formación STVH',
    'Contenido completo de la acción formativa y evaluación final.'
  )
  on conflict (course_version_id, position) do update set
    title = excluded.title,
    description = excluded.description,
    updated_at = now()
  returning id into v_module_id;

  insert into public.lessons (
    module_id, position, title, summary, kind, duration_minutes,
    sequential_required, active, content_mode
  )
  values (
    v_module_id, 1, 'Presentación de la formación',
    'Presentación de 57 diapositivas dividida en cinco capítulos. Al terminarla se habilita el test final.',
    'mixed', 90, true, true, 'slides'
  )
  on conflict (module_id, position) do update set
    title = excluded.title,
    summary = excluded.summary,
    kind = excluded.kind,
    duration_minutes = excluded.duration_minutes,
    content_mode = excluded.content_mode,
    active = true,
    updated_at = now()
  returning id into v_lesson_id;

  -- Capítulo 1 (diapositivas 1 a 4)
  insert into public.lesson_audio_segments (
    lesson_id, position, title, narration_text, duration_seconds, published
  )
  values (v_lesson_id, 1, 'Introducción y documentación de referencia', 'Objeto y alcance de la formación, estructura del curso y normativa y procedimientos de referencia.', 180, true)
  on conflict (lesson_id, position) do update set
    title = excluded.title,
    narration_text = excluded.narration_text,
    duration_seconds = excluded.duration_seconds,
    published = true,
    updated_at = now()
  returning id into v_segment_id;

  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 1, 'Formación STVH · portada', '', '/course-slides/stvh/slide-001.jpg', 'Formación STVH', 'Diapositiva 1', 'Formación STVH · portada')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 2, 'Objeto de la acción formativa', '', '/course-slides/stvh/slide-002.jpg', 'Formación STVH', 'Diapositiva 2', 'Objeto de la acción formativa')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 3, 'Contenido del curso', '', '/course-slides/stvh/slide-003.jpg', 'Formación STVH', 'Diapositiva 3', 'Contenido del curso')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 4, 'Documentación de referencia', '', '/course-slides/stvh/slide-004.jpg', 'Formación STVH', 'Diapositiva 4', 'Documentación de referencia')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();

  -- Capítulo 2 (diapositivas 5 a 19)
  insert into public.lesson_audio_segments (
    lesson_id, position, title, narration_text, duration_seconds, published
  )
  values (v_lesson_id, 2, 'Bloque 1 · Medición de dimensiones de vehículos', 'Equipos y utillaje, proceso de medición, medidas directas e indirectas y toma de cada dimensión.', 675, true)
  on conflict (lesson_id, position) do update set
    title = excluded.title,
    narration_text = excluded.narration_text,
    duration_seconds = excluded.duration_seconds,
    published = true,
    updated_at = now()
  returning id into v_segment_id;

  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 1, 'Bloque 1 · Medición de dimensiones de vehículos', '', '/course-slides/stvh/slide-005.jpg', 'Formación STVH', 'Diapositiva 5', 'Bloque 1 · Medición de dimensiones de vehículos')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 2, 'Equipos de medición y utillaje auxiliar', '', '/course-slides/stvh/slide-006.jpg', 'Formación STVH', 'Diapositiva 6', 'Equipos de medición y utillaje auxiliar')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 3, 'Proceso de medición: los seis pasos', '', '/course-slides/stvh/slide-007.jpg', 'Formación STVH', 'Diapositiva 7', 'Proceso de medición: los seis pasos')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 4, 'Criterios de medición: directas e indirectas', '', '/course-slides/stvh/slide-008.jpg', 'Formación STVH', 'Diapositiva 8', 'Criterios de medición: directas e indirectas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 5, 'Longitud total', '', '/course-slides/stvh/slide-009.jpg', 'Formación STVH', 'Diapositiva 9', 'Longitud total')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 6, 'Anchura total', '', '/course-slides/stvh/slide-010.jpg', 'Formación STVH', 'Diapositiva 10', 'Anchura total')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 7, 'Distancia entre ejes: los dos casos posibles', '', '/course-slides/stvh/slide-011.jpg', 'Formación STVH', 'Diapositiva 11', 'Distancia entre ejes: los dos casos posibles')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 8, '2º caso · 1er método: con el flexómetro', '', '/course-slides/stvh/slide-012.jpg', 'Formación STVH', 'Diapositiva 12', '2º caso · 1er método: con el flexómetro')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 9, '2º caso · 2º método: con la escuadra', '', '/course-slides/stvh/slide-013.jpg', 'Formación STVH', 'Diapositiva 13', '2º caso · 2º método: con la escuadra')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 10, 'Verificación en ambos laterales y tolerancia', '', '/course-slides/stvh/slide-014.jpg', 'Formación STVH', 'Diapositiva 14', 'Verificación en ambos laterales y tolerancia')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 11, 'Categoría L: comprobación de la rectitud del manillar', '', '/course-slides/stvh/slide-015.jpg', 'Formación STVH', 'Diapositiva 15', 'Categoría L: comprobación de la rectitud del manillar')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 12, 'Voladizos', '', '/course-slides/stvh/slide-016.jpg', 'Formación STVH', 'Diapositiva 16', 'Voladizos')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 13, 'Ancho de vías', '', '/course-slides/stvh/slide-017.jpg', 'Formación STVH', 'Diapositiva 17', 'Ancho de vías')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 14, 'Altura', '', '/course-slides/stvh/slide-018.jpg', 'Formación STVH', 'Diapositiva 18', 'Altura')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 15, 'Quinta rueda (cabezas tractoras)', '', '/course-slides/stvh/slide-019.jpg', 'Formación STVH', 'Diapositiva 19', 'Quinta rueda (cabezas tractoras)')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();

  -- Capítulo 3 (diapositivas 20 a 26)
  insert into public.lesson_audio_segments (
    lesson_id, position, title, narration_text, duration_seconds, published
  )
  values (v_lesson_id, 3, 'Bloque 2 · Exenciones dimensionales', 'Valor que se traslada a la tarjeta ITV y elementos que no se tienen en cuenta al determinar las dimensiones máximas.', 315, true)
  on conflict (lesson_id, position) do update set
    title = excluded.title,
    narration_text = excluded.narration_text,
    duration_seconds = excluded.duration_seconds,
    published = true,
    updated_at = now()
  returning id into v_segment_id;

  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 1, 'Bloque 2 · Exenciones dimensionales', '', '/course-slides/stvh/slide-020.jpg', 'Formación STVH', 'Diapositiva 20', 'Bloque 2 · Exenciones dimensionales')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 2, 'Qué valor se traslada a la tarjeta ITV', '', '/course-slides/stvh/slide-021.jpg', 'Formación STVH', 'Diapositiva 21', 'Qué valor se traslada a la tarjeta ITV')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 3, 'Condiciones generales de exención · categorías M, N y O', '', '/course-slides/stvh/slide-022.jpg', 'Formación STVH', 'Diapositiva 22', 'Condiciones generales de exención · categorías M, N y O')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 4, 'Cuadro I · Longitud del vehículo (1/2)', '', '/course-slides/stvh/slide-023.jpg', 'Formación STVH', 'Diapositiva 23', 'Cuadro I · Longitud del vehículo (1/2)')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 5, 'Cuadro I · Longitud del vehículo (2/2)', '', '/course-slides/stvh/slide-024.jpg', 'Formación STVH', 'Diapositiva 24', 'Cuadro I · Longitud del vehículo (2/2)')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 6, 'Cuadro II · Anchura y Cuadro III · Altura', '', '/course-slides/stvh/slide-025.jpg', 'Formación STVH', 'Diapositiva 25', 'Cuadro II · Anchura y Cuadro III · Altura')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 7, 'Exenciones en categoría L y vehículos agrícolas y de obras', '', '/course-slides/stvh/slide-026.jpg', 'Formación STVH', 'Diapositiva 26', 'Exenciones en categoría L y vehículos agrícolas y de obras')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();

  -- Capítulo 4 (diapositivas 27 a 41)
  insert into public.lesson_audio_segments (
    lesson_id, position, title, narration_text, duration_seconds, published
  )
  values (v_lesson_id, 4, 'Bloque 3 · Remolques y tractores agrícolas', 'Condiciones iniciales, traslado de puntos al suelo, tablas de dimensiones y obtención de masas.', 675, true)
  on conflict (lesson_id, position) do update set
    title = excluded.title,
    narration_text = excluded.narration_text,
    duration_seconds = excluded.duration_seconds,
    published = true,
    updated_at = now()
  returning id into v_segment_id;

  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 1, 'Bloque 3 · Remolques y tractores agrícolas', '', '/course-slides/stvh/slide-027.jpg', 'Formación STVH', 'Diapositiva 27', 'Bloque 3 · Remolques y tractores agrícolas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 2, 'Tipos de medición en vehículos agrícolas', '', '/course-slides/stvh/slide-028.jpg', 'Formación STVH', 'Diapositiva 28', 'Tipos de medición en vehículos agrícolas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 3, 'Condiciones iniciales del remolque agrícola', '', '/course-slides/stvh/slide-029.jpg', 'Formación STVH', 'Diapositiva 29', 'Condiciones iniciales del remolque agrícola')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 4, 'Remolque agrícola de dos ejes · traslado de puntos al suelo', '', '/course-slides/stvh/slide-030.jpg', 'Formación STVH', 'Diapositiva 30', 'Remolque agrícola de dos ejes · traslado de puntos al suelo')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 5, 'Remolque agrícola de un eje · traslado de puntos al suelo', '', '/course-slides/stvh/slide-031.jpg', 'Formación STVH', 'Diapositiva 31', 'Remolque agrícola de un eje · traslado de puntos al suelo')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 6, 'Tabla de dimensiones en remolques agrícolas', '', '/course-slides/stvh/slide-032.jpg', 'Formación STVH', 'Diapositiva 32', 'Tabla de dimensiones en remolques agrícolas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 7, 'Tractores agrícolas · condiciones iniciales y puntos al suelo', '', '/course-slides/stvh/slide-033.jpg', 'Formación STVH', 'Diapositiva 33', 'Tractores agrícolas · condiciones iniciales y puntos al suelo')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 8, 'Tractores agrícolas · ejes, líneas definitorias y puntos V y R', '', '/course-slides/stvh/slide-034.jpg', 'Formación STVH', 'Diapositiva 34', 'Tractores agrícolas · ejes, líneas definitorias y puntos V y R')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 9, 'Ancho de vías en ejes de tractor con vía variable (1/2)', '', '/course-slides/stvh/slide-035.jpg', 'Formación STVH', 'Diapositiva 35', 'Ancho de vías en ejes de tractor con vía variable (1/2)')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 10, 'Ancho de vías en ejes de tractor con vía variable (2/2)', '', '/course-slides/stvh/slide-036.jpg', 'Formación STVH', 'Diapositiva 36', 'Ancho de vías en ejes de tractor con vía variable (2/2)')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 11, 'Altura del sistema de enganche de remolque sobre el suelo', '', '/course-slides/stvh/slide-037.jpg', 'Formación STVH', 'Diapositiva 37', 'Altura del sistema de enganche de remolque sobre el suelo')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 12, 'Tabla de dimensiones en tractores agrícolas', '', '/course-slides/stvh/slide-038.jpg', 'Formación STVH', 'Diapositiva 38', 'Tabla de dimensiones en tractores agrícolas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 13, 'Obtención de las masas de remolques agrícolas', '', '/course-slides/stvh/slide-039.jpg', 'Formación STVH', 'Diapositiva 39', 'Obtención de las masas de remolques agrícolas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 14, 'Medición de masa en remolques de un eje y semirremolques', '', '/course-slides/stvh/slide-040.jpg', 'Formación STVH', 'Diapositiva 40', 'Medición de masa en remolques de un eje y semirremolques')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 15, 'Obtención de las masas de tractores agrícolas', '', '/course-slides/stvh/slide-041.jpg', 'Formación STVH', 'Diapositiva 41', 'Obtención de las masas de tractores agrícolas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();

  -- Capítulo 5 (diapositivas 42 a 57)
  insert into public.lesson_audio_segments (
    lesson_id, position, title, narration_text, duration_seconds, published
  )
  values (v_lesson_id, 5, 'Bloque 4 · Registro de datos primarios', 'Los formatos LVH-13.1 a LVH-13.6 y cómo cumplimentar cada casilla por categoría de vehículo.', 720, true)
  on conflict (lesson_id, position) do update set
    title = excluded.title,
    narration_text = excluded.narration_text,
    duration_seconds = excluded.duration_seconds,
    published = true,
    updated_at = now()
  returning id into v_segment_id;

  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 1, 'Bloque 4 · Registro de datos primarios', '', '/course-slides/stvh/slide-042.jpg', 'Formación STVH', 'Diapositiva 42', 'Bloque 4 · Registro de datos primarios')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 2, 'Antecedentes y alcance', '', '/course-slides/stvh/slide-043.jpg', 'Formación STVH', 'Diapositiva 43', 'Antecedentes y alcance')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 3, 'Los seis formatos de ficha de inspección', '', '/course-slides/stvh/slide-044.jpg', 'Formación STVH', 'Diapositiva 44', 'Los seis formatos de ficha de inspección')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 4, 'LVH-13.1 · Ficha de inspección L (1/3): identificación', '', '/course-slides/stvh/slide-045.jpg', 'Formación STVH', 'Diapositiva 45', 'LVH-13.1 · Ficha de inspección L (1/3): identificación')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 5, 'Categorías y subcategorías de vehículos L', '', '/course-slides/stvh/slide-046.jpg', 'Formación STVH', 'Diapositiva 46', 'Categorías y subcategorías de vehículos L')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 6, 'LVH-13.1 · Ficha L (2/3): masas, dimensiones y cálculos', '', '/course-slides/stvh/slide-047.jpg', 'Formación STVH', 'Diapositiva 47', 'LVH-13.1 · Ficha L (2/3): masas, dimensiones y cálculos')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 7, 'LVH-13.1 · Ficha L (3/3): resto de bloques', '', '/course-slides/stvh/slide-048.jpg', 'Formación STVH', 'Diapositiva 48', 'LVH-13.1 · Ficha L (3/3): resto de bloques')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 8, 'LVH-13.2 · Ficha M1 y N1 (1/3): identificación y constitución', '', '/course-slides/stvh/slide-049.jpg', 'Formación STVH', 'Diapositiva 49', 'LVH-13.2 · Ficha M1 y N1 (1/3): identificación y constitución')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 9, 'LVH-13.2 · Ficha M1 y N1 (2/3): masas y cálculos', '', '/course-slides/stvh/slide-050.jpg', 'Formación STVH', 'Diapositiva 50', 'LVH-13.2 · Ficha M1 y N1 (2/3): masas y cálculos')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 10, 'Tipos de carrocería en M1 y N1', '', '/course-slides/stvh/slide-051.jpg', 'Formación STVH', 'Diapositiva 51', 'Tipos de carrocería en M1 y N1')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 11, 'LVH-13.2 · Ficha M1 y N1 (3/3): resto de bloques', '', '/course-slides/stvh/slide-052.jpg', 'Formación STVH', 'Diapositiva 52', 'LVH-13.2 · Ficha M1 y N1 (3/3): resto de bloques')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 12, 'LVH-13.3 · Ficha M2 y M3: lo específico', '', '/course-slides/stvh/slide-053.jpg', 'Formación STVH', 'Diapositiva 53', 'LVH-13.3 · Ficha M2 y M3: lo específico')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 13, 'LVH-13.4 · Ficha N2 y N3: lo específico', '', '/course-slides/stvh/slide-054.jpg', 'Formación STVH', 'Diapositiva 54', 'LVH-13.4 · Ficha N2 y N3: lo específico')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 14, 'LVH-13.5 · Ficha O: lo específico', '', '/course-slides/stvh/slide-055.jpg', 'Formación STVH', 'Diapositiva 55', 'LVH-13.5 · Ficha O: lo específico')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 15, 'LVH-13.6 · Ficha T-C: lo específico', '', '/course-slides/stvh/slide-056.jpg', 'Formación STVH', 'Diapositiva 56', 'LVH-13.6 · Ficha T-C: lo específico')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();
  insert into public.lesson_segment_slides (
    segment_id, position, title, body, image_external_url, source_label, source_page, alt_text
  )
  values (v_segment_id, 16, 'Observaciones y buenas prácticas', '', '/course-slides/stvh/slide-057.jpg', 'Formación STVH', 'Diapositiva 57', 'Observaciones y buenas prácticas')
  on conflict (segment_id, position) do update set
    title = excluded.title,
    image_external_url = excluded.image_external_url,
    source_label = excluded.source_label,
    source_page = excluded.source_page,
    alt_text = excluded.alt_text,
    updated_at = now();

  -- Material descargable del curso
  delete from public.lesson_resources where lesson_id = v_lesson_id;
  insert into public.lesson_resources (
    lesson_id, kind, title, external_url, mime_type, downloadable, required, position
  )
  values (v_lesson_id, 'presentation', 'Presentación completa de la formación (PDF)', '/course-materials/stvh/formacion-stvh-diapositivas.pdf', 'application/pdf', true, false, 1);
  insert into public.lesson_resources (
    lesson_id, kind, title, external_url, mime_type, downloadable, required, position
  )
  values (v_lesson_id, 'pdf', '1. Medición de dimensiones de vehículos', '/course-materials/stvh/1-medicion-de-dimensiones-de-vehiculos.pdf', 'application/pdf', true, false, 2);
  insert into public.lesson_resources (
    lesson_id, kind, title, external_url, mime_type, downloadable, required, position
  )
  values (v_lesson_id, 'pdf', '2. Medición de dimensiones y masas en remolques y tractores agrícolas', '/course-materials/stvh/2-medicion-dimensiones-y-masas-vehiculos-agricolas.pdf', 'application/pdf', true, false, 3);
  insert into public.lesson_resources (
    lesson_id, kind, title, external_url, mime_type, downloadable, required, position
  )
  values (v_lesson_id, 'pdf', '3. Registro de datos primarios en la inspección', '/course-materials/stvh/3-registro-de-datos-primarios.pdf', 'application/pdf', true, false, 4);
  insert into public.lesson_resources (
    lesson_id, kind, title, external_url, mime_type, downloadable, required, position
  )
  values (v_lesson_id, 'pdf', '4. Exenciones de elementos para medidas en vehículos según categorías', '/course-materials/stvh/4-exenciones-de-elementos-segun-categorias.pdf', 'application/pdf', true, false, 5);

  insert into public.question_banks (course_version_id, title)
  select v_version_id, 'Banco de preguntas · Formación STVH'
  where not exists (
    select 1 from public.question_banks
    where course_version_id = v_version_id
      and title = 'Banco de preguntas · Formación STVH'
  );

  select id into v_bank_id
  from public.question_banks
  where course_version_id = v_version_id
    and title = 'Banco de preguntas · Formación STVH'
  limit 1;

  -- Se regeneran las preguntas para que la migración sea reejecutable.
  delete from public.questions where question_bank_id = v_bank_id;

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, '¿Con qué elemento del utillaje se comprueba, antes de medir, que el suelo de la zona de inspección es horizontal?', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'El flexómetro', false),
    (v_question_id, 2, 'La regla-nivel', true),
    (v_question_id, 3, 'El espejo', false),
    (v_question_id, 4, 'La plomada', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'El flexómetro se utiliza para mediciones de longitudes…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Siempre superiores a 10.000 mm', false),
    (v_question_id, 2, 'Inferiores a 5.000 o 10.000 mm, en función de la longitud del equipo', true),
    (v_question_id, 3, 'Únicamente indirectas', false),
    (v_question_id, 4, 'Únicamente en vehículos agrícolas', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, '¿Cuál de las siguientes es una medida DIRECTA?', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'La longitud total del vehículo', false),
    (v_question_id, 2, 'El voladizo trasero', false),
    (v_question_id, 3, 'Las dimensiones de una caja abierta', true),
    (v_question_id, 4, 'La distancia entre ejes con rueda gemela', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Durante la medición, el vehículo debe estar…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Cargado y con el motor en marcha', false),
    (v_question_id, 2, 'Libre de carga, con el motor apagado y el freno de estacionamiento accionado', true),
    (v_question_id, 3, 'Con las puertas abiertas y las escaleras desplegadas', false),
    (v_question_id, 4, 'Sobre el elevador de la nave', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Si se observa visualmente que la presión de inflado de los neumáticos es insuficiente…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Se mide igualmente y se anota la incidencia', false),
    (v_question_id, 2, 'Se rechaza el vehículo', false),
    (v_question_id, 3, 'Se indica al conductor del vehículo para que lo subsane', true),
    (v_question_id, 4, 'Se corrige el valor medido por cálculo', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'En las medidas indirectas, cuando no es posible marcar con tiza los puntos proyectados, se utilizan…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Rotulador permanente', false),
    (v_question_id, 2, 'Varillas marcadoras coloreadas', true),
    (v_question_id, 3, 'Cinta adhesiva', false),
    (v_question_id, 4, 'Pintura en spray', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, '¿Cuál es el orden correcto de trabajo en las medidas indirectas?', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Resto de dimensiones, distancia entre ejes y ancho de vías', false),
    (v_question_id, 2, 'Distancia entre ejes en ambos costados, ancho de vías, retirar el vehículo y tomar el resto de dimensiones', true),
    (v_question_id, 3, 'Ancho de vías, altura y después longitud total', false),
    (v_question_id, 4, 'El orden es indiferente', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Tolerancia máxima admitida entre las distancias entre ejes medidas en ambos laterales del vehículo:', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, '5 mm', false),
    (v_question_id, 2, '10 mm', false),
    (v_question_id, 3, '15 mm', true),
    (v_question_id, 4, '25 mm', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'En vehículos de categoría L, la posición del manillar se da por válida cuando la diferencia entre las cotas de ambos laterales es…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Menor o igual a 5 mm', true),
    (v_question_id, 2, 'Menor o igual a 15 mm', false),
    (v_question_id, 3, 'Menor o igual a 25 mm', false),
    (v_question_id, 4, 'No se comprueba', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Para medir la altura del vehículo se…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Mide directamente con el flexómetro desde el techo', false),
    (v_question_id, 2, 'Coloca la regla-nivel en el punto más alto y se proyecta con la plomada al suelo', true),
    (v_question_id, 3, 'Utiliza el espejo y la escuadra', false),
    (v_question_id, 4, 'Consulta únicamente la documentación', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'La posición del centro de la quinta rueda se proyecta al suelo mediante…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Tiza y espejo', false),
    (v_question_id, 2, 'Regla-nivel y plomada, usando la escuadra para asegurar la perpendicularidad', true),
    (v_question_id, 3, 'Únicamente el flexómetro', false),
    (v_question_id, 4, 'No se proyecta, se toma de la documentación', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Si la comprobación dimensional resulta correcta, a la tarjeta ITV se trasladan…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Las dimensiones medidas en la estación ITV', false),
    (v_question_id, 2, 'Las dimensiones que figuran en la documentación técnica aportada', true),
    (v_question_id, 3, 'La media de ambas', false),
    (v_question_id, 4, 'Las del CoC en todos los casos', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Los dispositivos y equipos añadidos a la longitud del vehículo no deberán sobresalir en total más de…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, '100 mm', false),
    (v_question_id, 2, '250 mm', false),
    (v_question_id, 3, '500 mm', false),
    (v_question_id, 4, '750 mm', true);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Con excepción de los retrovisores, los dispositivos añadidos a la anchura no deberán sobresalir en total más de…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, '100 mm', true),
    (v_question_id, 2, '250 mm', false),
    (v_question_id, 3, '300 mm', false),
    (v_question_id, 4, '750 mm', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'En un remolque agrícola con lanza giratoria respecto al chasis, para garantizar su correcta posición…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Las distancias entre ejes derecha e izquierda (DED y DEI) han de ser iguales', true),
    (v_question_id, 2, 'La lanza debe estar elevada 30 cm', false),
    (v_question_id, 3, 'El remolque debe ir cargado', false),
    (v_question_id, 4, 'Basta con una comprobación visual', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Al establecer las dimensiones de un vehículo agrícola NO se incluyen…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'La caja del remolque', false),
    (v_question_id, 2, 'Los intermitentes, retrovisores, luces de gálibo y el abombamiento de los neumáticos', true),
    (v_question_id, 3, 'Las ruedas', false),
    (v_question_id, 4, 'La lanza de remolque', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'El Ancho de Vías Máximo de un tractor con vía variable se obtiene como…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Avi + EFizq + EFder', true),
    (v_question_id, 2, 'Avi − CDizq − CDder', false),
    (v_question_id, 3, 'Avi × 2', false),
    (v_question_id, 4, 'AB + CD', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'La altura máxima del sistema de enganche de remolque se calcula como…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'hins − hi', false),
    (v_question_id, 2, 'hins + hs', true),
    (v_question_id, 3, 'hs + hi', false),
    (v_question_id, 4, 'hins × 2', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'En un remolque agrícola de un solo eje, el peso sobre el eje delantero se calcula mediante…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Ped = (Pap × D) / (d + D)', true),
    (v_question_id, 2, 'Ped = Pap + D', false),
    (v_question_id, 3, 'Ped = (Pap × d) / D', false),
    (v_question_id, 4, 'Se mide directamente con la báscula', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'La Masa en Orden de Marcha de un TRACTOR agrícola se obtiene como…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'La suma de los pesajes de ambos ejes', false),
    (v_question_id, 2, 'La suma de los pesajes de ambos ejes más 75 kg', true),
    (v_question_id, 3, 'La tara que figura en el expediente', false),
    (v_question_id, 4, 'La MMTA menos 75 kg', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Cuando en una casilla de la ficha de inspección no procede registrar ningún dato, se anota…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Un 0', false),
    (v_question_id, 2, 'Un guion', false),
    (v_question_id, 3, '«N/A»', true),
    (v_question_id, 4, 'Se deja en blanco', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'El formato LVH-13.5 corresponde a la ficha de inspección de vehículos de categoría…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'L', false),
    (v_question_id, 2, 'M2 y M3', false),
    (v_question_id, 3, 'O', true),
    (v_question_id, 4, 'T-C', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'La Potencia Fiscal (CVF) se calcula mediante la expresión…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, '0,11 × (Cilindrada / Nº cilindros)^0,6 × Nº cilindros', true),
    (v_question_id, 2, 'Cilindrada / 100', false),
    (v_question_id, 3, 'kW × 1,36', false),
    (v_question_id, 4, 'No se calcula, siempre viene en el expediente', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'Al estimar masas por número de plazas, por cada plaza adicional se suman…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, '75 kg', false),
    (v_question_id, 2, '85 kg (75 kg de pasajero + 10 kg de equipaje)', true),
    (v_question_id, 3, '100 kg', false),
    (v_question_id, 4, '68 kg', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'El peso del vehículo se establece en una Estación ITV con báscula calibrada bajo acreditación ENAC. El ticket original de pesaje…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'Se entrega al titular del vehículo', false),
    (v_question_id, 2, 'Se archiva en el expediente del vehículo, dejando evidencia de la calibración', true),
    (v_question_id, 3, 'No es necesario conservarlo', false),
    (v_question_id, 4, 'Se sustituye por una anotación en la ficha', false);

  insert into public.questions (question_bank_id, prompt, type, points, active)
  values (v_bank_id, 'En un vehículo M1 o N1 con gancho, la Masa Máxima Técnicamente Admisible del Conjunto se obtiene como…', 'single_choice', 1, true)
  returning id into v_question_id;
  insert into public.question_options (question_id, position, option_text, is_correct)
  values
    (v_question_id, 1, 'MMTC = MMTA + MR', true),
    (v_question_id, 2, 'MMTC = MMTA − MR', false),
    (v_question_id, 3, 'MMTC = MOM + 75 kg', false),
    (v_question_id, 4, 'MMTC = MMA × 2', false);

  insert into public.quizzes (
    lesson_id, question_bank_id, title, question_count, passing_percent,
    required_perfect_streak, completion_mode, randomize_questions,
    randomize_options, minimum_retry_seconds, active
  )
  values (
    v_lesson_id, v_bank_id, 'Test final · Formación STVH', 26, 100,
    3, 'consecutive_perfect', true, true, 0, true
  )
  on conflict (lesson_id) do update set
    question_bank_id = excluded.question_bank_id,
    title = excluded.title,
    question_count = excluded.question_count,
    passing_percent = excluded.passing_percent,
    required_perfect_streak = excluded.required_perfect_streak,
    completion_mode = excluded.completion_mode,
    randomize_questions = excluded.randomize_questions,
    randomize_options = excluded.randomize_options,
    active = true,
    updated_at = now()
  returning id into v_quiz_id;

  insert into public.confidentiality_agreements (
    course_version_id, version_number, title, body, active
  )
  values (
    v_version_id, 1,
    'Contrato de confidencialidad · Formación STVH',
    '1. Objeto.
El presente contrato regula el compromiso de confidencialidad asumido por la persona firmante (en adelante, la persona receptora) respecto de toda la información a la que ha tenido acceso durante la acción formativa «Formación STVH» impartida por Inmíner Ingeniería, S.L. para LVH Carricoche.

2. Información confidencial.
Tiene la consideración de información confidencial toda la documentación, procedimientos internos, fichas de inspección, criterios de medición, imágenes, datos técnicos y cualquier otro material entregado o mostrado durante el curso, con independencia del soporte en el que se encuentre y de si está o no expresamente marcado como confidencial. Se incluyen de forma expresa los procedimientos LVH-08, LVH-13 y LVH-13.9 y las fichas LVH-13.1 a LVH-13.6.

3. Obligaciones de la persona receptora.
La persona receptora se obliga a: (a) mantener la información confidencial en estricto secreto; (b) utilizarla exclusivamente para el desempeño de sus funciones de inspección; (c) no reproducirla, distribuirla, publicarla ni comunicarla a terceros, ni total ni parcialmente, por ningún medio, incluidas redes sociales y servicios de mensajería; (d) no extraerla de los sistemas y soportes autorizados; y (e) custodiar con diligencia las credenciales de acceso al campus y el código de acceso al curso, que son personales e intransferibles.

4. Excepciones.
No se considera información confidencial aquella que sea de dominio público sin incumplimiento de este contrato, la que la persona receptora pueda acreditar que conocía previamente de forma lícita, ni aquella cuya divulgación venga impuesta por una norma o por una resolución judicial o administrativa firme, en cuyo caso la persona receptora lo comunicará de inmediato y por escrito a Inmíner Ingeniería, S.L.

5. Duración.
El deber de confidencialidad es indefinido y subsiste tras la finalización de la relación laboral, mercantil o formativa que une a las partes.

6. Devolución y supresión.
A la finalización de dicha relación, o a simple requerimiento, la persona receptora devolverá o destruirá todos los materiales del curso en su poder y suprimirá las copias digitales que conserve, confirmándolo por escrito si así se le solicita.

7. Protección de datos.
Los datos personales facilitados en esta firma (nombre, apellidos y documento de identidad) serán tratados por Inmíner Ingeniería, S.L. con la finalidad de acreditar la aceptación de este compromiso y por el tiempo exigido por la normativa aplicable. Puede ejercer sus derechos de acceso, rectificación, supresión, limitación, oposición y portabilidad dirigiéndose a administracion@inminer.es.

8. Incumplimiento.
El incumplimiento de las obligaciones de este contrato podrá dar lugar a las responsabilidades disciplinarias, civiles o penales que en cada caso procedan.

9. Legislación y fuero.
Este contrato se rige por la legislación española. Para cualquier controversia, las partes se someten a los juzgados y tribunales del domicilio social de Inmíner Ingeniería, S.L., con renuncia expresa a cualquier otro fuero que pudiera corresponderles.

Al pulsar «Firmar el contrato» la persona firmante declara haber leído y comprendido íntegramente este documento y lo acepta de forma expresa, quedando registrada la fecha y hora de la firma.',
    true
  )
  on conflict (course_version_id, version_number) do update set
    title = excluded.title,
    body = excluded.body,
    active = true,
    updated_at = now();

end
$$;

commit;

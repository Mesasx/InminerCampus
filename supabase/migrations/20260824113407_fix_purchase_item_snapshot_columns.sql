begin;

-- Production can have the company checkout migration without these columns
-- when the earlier billing automation migration was recorded but not applied.
alter table public.purchase_items
  add column if not exists course_code_snapshot text,
  add column if not exists description_snapshot text;

update public.purchase_items as purchase_item
set
  course_code_snapshot = coalesce(purchase_item.course_code_snapshot, course.slug),
  description_snapshot = coalesce(
    purchase_item.description_snapshot,
    concat(
      course.title,
      ' · Versión ',
      course_version.version_number,
      ' · ',
      course_version.duration_hours,
      ' horas'
    )
  )
from public.course_versions as course_version
join public.courses as course on course.id = course_version.course_id
where course_version.id = purchase_item.course_version_id
  and (
    purchase_item.course_code_snapshot is null
    or purchase_item.description_snapshot is null
  );

commit;

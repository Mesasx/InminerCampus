-- Read-only production checks for InmínerCampus.

-- Every application table must have RLS enabled and at least one policy.
select
  c.relname as table_name,
  c.relrowsecurity as rls_enabled,
  count(p.polname) as policy_count
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
left join pg_policy p on p.polrelid = c.oid
where n.nspname = 'public'
  and c.relkind = 'r'
group by c.relname, c.relrowsecurity
order by c.relname;

-- Private storage buckets must never become public accidentally.
select id, public, file_size_limit
from storage.buckets
where id in (
  'course-materials',
  'support-attachments',
  'practice-evidence',
  'certificates',
  'billing-documents'
)
order by id;

-- Sensitive functions expose only their intended execution roles.
select
  has_function_privilege(
    'anon',
    'public.redeem_access_code(text)',
    'EXECUTE'
  ) as anon_can_redeem_code,
  has_function_privilege(
    'authenticated',
    'public.redeem_access_code(text)',
    'EXECUTE'
  ) as learner_can_redeem_code,
  has_function_privilege(
    'anon',
    'public.verify_certificate(text)',
    'EXECUTE'
  ) as public_can_verify_certificate,
  has_function_privilege(
    'authenticated',
    'public.fulfill_stripe_checkout_v2(text,text,boolean,uuid,text,text,text,text,numeric,numeric,numeric,timestamptz)',
    'EXECUTE'
  ) as browser_can_fulfill_purchase,
  has_function_privilege(
    'authenticated',
    'public.claim_billing_jobs(integer)',
    'EXECUTE'
  ) as browser_can_claim_billing_jobs,
  has_function_privilege(
    'authenticated',
    'public.claim_archive_jobs(integer)',
    'EXECUTE'
  ) as browser_can_claim_archive_jobs,
  has_function_privilege(
    'authenticated',
    'public.retry_invoice_jobs(uuid,text)',
    'EXECUTE'
  ) as browser_can_retry_invoice_jobs;

-- Access-code hashes must remain unreadable to browser clients.
select has_column_privilege(
  'authenticated',
  'public.access_codes',
  'code_hash',
  'SELECT'
) as browser_can_read_access_code_hash;

-- Find foreign keys whose leading column does not have a supporting index.
with fk_columns as (
  select
    n.nspname as schema_name,
    c.relname as table_name,
    a.attname as column_name
  from pg_constraint con
  join pg_class c on c.oid = con.conrelid
  join pg_namespace n on n.oid = c.relnamespace
  cross join lateral unnest(con.conkey) as key(attnum)
  join pg_attribute a
    on a.attrelid = c.oid
   and a.attnum = key.attnum
  where con.contype = 'f'
    and n.nspname = 'public'
),
indexed_columns as (
  select
    ns.nspname as schema_name,
    tbl.relname as table_name,
    att.attname as column_name
  from pg_index ix
  join pg_class tbl on tbl.oid = ix.indrelid
  join pg_namespace ns on ns.oid = tbl.relnamespace
  cross join lateral unnest(ix.indkey) with ordinality as key(attnum, ord)
  join pg_attribute att
    on att.attrelid = tbl.oid
   and att.attnum = key.attnum
  where ns.nspname = 'public'
    and key.ord = 1
)
select fk.*
from fk_columns fk
left join indexed_columns idx
  using (schema_name, table_name, column_name)
where idx.column_name is null
order by fk.table_name, fk.column_name;

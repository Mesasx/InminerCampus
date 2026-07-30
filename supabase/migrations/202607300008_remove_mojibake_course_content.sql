begin;

-- Remove the duplicate banks created by an incorrectly decoded deployment.
-- The UTF-8 hex comparison keeps the repair deterministic across clients.
delete from public.question_banks
where encode(convert_to(title, 'UTF8'), 'hex')
  = '4576616c75616369c383c2b36e2066696e616c20c382c2b720636f6e74656e69646f20437572736f7320506564726f';

commit;

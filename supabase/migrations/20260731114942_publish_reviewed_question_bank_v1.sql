-- Make the canonical, reviewed 2026 v1 questions available in topic practice.
-- Duplicate variants remain drafts and incomplete mock papers remain drafts.
update public.questions
set status = 'published'::public.question_status
where explanation like '[Original bank 2026 v1]%'
  and status = 'reviewed'
  and correct_answer = '0'::jsonb;

do $$
declare
  published_count integer;
begin
  select count(*) into published_count
  from public.questions
  where explanation like '[Original bank 2026 v1]%'
    and status = 'published';

  if published_count <> 50 then
    raise exception 'Expected 50 published canonical questions, found %', published_count;
  end if;
end
$$;

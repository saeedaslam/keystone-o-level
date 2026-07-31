-- Human/content review gate for the generated 2026 question bank.
--
-- The seed contains 50 distinct knowledge checks and three presentation
-- variants of each check. The variants reuse the same fact and distractors,
-- so approving all 150 would create near-duplicates in the same mock paper.
-- Keep one canonical version of each check and leave the other variants in
-- draft until they are replaced by genuinely distinct questions.

update public.questions
set status = case
  when correct_answer = '0'::jsonb then 'reviewed'::public.question_status
  else 'draft'::public.question_status
end
where explanation like '[Original bank 2026 v1]%';

-- Fail the migration if the review set no longer has the expected shape.
do $$
declare
  reviewed_count integer;
  draft_count integer;
begin
  select
    count(*) filter (where status = 'reviewed'),
    count(*) filter (where status = 'draft')
  into reviewed_count, draft_count
  from public.questions
  where explanation like '[Original bank 2026 v1]%';

  if reviewed_count <> 50 or draft_count <> 100 then
    raise exception
      'Unexpected question review result: reviewed %, draft %',
      reviewed_count, draft_count;
  end if;
end
$$;

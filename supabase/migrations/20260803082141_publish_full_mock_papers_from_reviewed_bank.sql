-- Publish two complete 75-mark mocks using only current published questions.
insert into public.exam_papers (
  subject_id, paper_number, title, description, duration_minutes, total_marks, status
)
select s.id, x.paper_number, x.title, x.description, 105, 75, 'published'
from public.subjects s
cross join (values
  (1, 'Paper 1 Full Mock A - 2026', 'A balanced 75-mark timed paper covering syllabus Topics 1-6.'),
  (2, 'Paper 2 Full Mock A - 2026', 'A balanced 75-mark timed paper covering syllabus Topics 7-10.')
) x(paper_number,title,description)
where s.code='2210'
  and not exists (select 1 from public.exam_papers p where p.title=x.title);

with candidates as (
  select q.id question_id, t.sort_order topic_order,
    row_number() over (
      partition by t.sort_order
      order by
        case
          when q.explanation like '[Original bank 2026 v2]%' then 1
          when q.explanation like '[Reference-informed bank 2026 v3]%' then 2
          else 3
        end,
        q.created_at, q.id
    ) within_topic
  from public.questions q
  join public.topics t on t.id=q.topic_id
  where q.status='published'
    and q.marks=1
), paper_candidates as (
  select p.id paper_id, c.question_id,
    row_number() over (
      partition by p.id order by c.within_topic, c.topic_order, c.question_id
    ) position
  from public.exam_papers p
  join candidates c on
    (p.paper_number=1 and c.topic_order between 1 and 6)
    or (p.paper_number=2 and c.topic_order between 7 and 10)
  where p.title in ('Paper 1 Full Mock A - 2026','Paper 2 Full Mock A - 2026')
)
insert into public.exam_paper_questions (exam_paper_id,question_id,position)
select paper_id,question_id,position
from paper_candidates pc
where position <= 75
  and not exists (
    select 1 from public.exam_paper_questions existing
    where existing.exam_paper_id=pc.paper_id
  );

do $$
declare bad_count integer; paper_count integer;
begin
  select count(*) into paper_count from public.exam_papers
  where title in ('Paper 1 Full Mock A - 2026','Paper 2 Full Mock A - 2026')
    and status='published';
  if paper_count <> 2 then
    raise exception 'Expected two published full mocks, found %', paper_count;
  end if;
  select count(*) into bad_count
  from (
    select p.id, count(epq.question_id) question_count, coalesce(sum(q.marks),0) linked_marks
    from public.exam_papers p
    left join public.exam_paper_questions epq on epq.exam_paper_id=p.id
    left join public.questions q on q.id=epq.question_id
    where p.title in ('Paper 1 Full Mock A - 2026','Paper 2 Full Mock A - 2026')
      and p.status='published'
    group by p.id
    having count(epq.question_id) <> 75 or coalesce(sum(q.marks),0) <> 75
  ) invalid;
  if bad_count <> 0 then
    raise exception 'Every published full mock must contain exactly 75 linked marks';
  end if;
end $$;

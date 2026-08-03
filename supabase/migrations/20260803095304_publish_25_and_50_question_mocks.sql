-- Permit short, standard, and full mock papers, then publish four balanced mocks.
create or replace function public.validate_exam_paper_publication()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.status = 'published' and new.total_marks not in (25, 50, 75) then
    raise exception 'Published exam papers must total 25, 50, or 75 marks';
  end if;
  return new;
end;
$$;

insert into public.exam_papers (
  subject_id, paper_number, title, description, duration_minutes, total_marks, status
)
select s.id, x.paper_number, x.title, x.description, x.duration_minutes, x.total_marks, 'published'
from public.subjects s
cross join (values
  (1, 'Paper 1 Short Mock A - 2026', 'A balanced 25-question timed paper covering syllabus Topics 1-6.', 35, 25),
  (2, 'Paper 2 Short Mock A - 2026', 'A balanced 25-question timed paper covering syllabus Topics 7-10.', 35, 25),
  (1, 'Paper 1 Standard Mock A - 2026', 'A balanced 50-question timed paper covering syllabus Topics 1-6.', 70, 50),
  (2, 'Paper 2 Standard Mock A - 2026', 'A balanced 50-question timed paper covering syllabus Topics 7-10.', 70, 50)
) x(paper_number, title, description, duration_minutes, total_marks)
where s.code = '2210'
  and not exists (select 1 from public.exam_papers p where p.title = x.title);

with paper_settings as (
  select p.id paper_id, p.paper_number, p.total_marks target_size,
    case when p.total_marks = 25 then 0 else 25 end offset_position
  from public.exam_papers p
  where p.title in (
    'Paper 1 Short Mock A - 2026', 'Paper 2 Short Mock A - 2026',
    'Paper 1 Standard Mock A - 2026', 'Paper 2 Standard Mock A - 2026'
  )
), candidates as (
  select q.id question_id, t.sort_order topic_order,
    row_number() over (
      partition by t.sort_order
      order by
        case
          when q.explanation like '[Reference-informed bank 2026 v3]%' then 1
          when q.explanation like '[Original bank 2026 v2]%' then 2
          else 3
        end,
        q.created_at, q.id
    ) within_topic
  from public.questions q
  join public.topics t on t.id = q.topic_id
  where q.status = 'published' and q.marks = 1
), ranked as (
  select ps.paper_id, ps.target_size, ps.offset_position, c.question_id,
    row_number() over (
      partition by ps.paper_id order by c.within_topic, c.topic_order, c.question_id
    ) position
  from paper_settings ps
  join candidates c on
    (ps.paper_number = 1 and c.topic_order between 1 and 6)
    or (ps.paper_number = 2 and c.topic_order between 7 and 10)
)
insert into public.exam_paper_questions (exam_paper_id, question_id, position)
select paper_id, question_id, position - offset_position
from ranked r
where position > offset_position
  and position <= offset_position + target_size
  and not exists (
    select 1 from public.exam_paper_questions existing
    where existing.exam_paper_id = r.paper_id
  );

do $$
declare invalid_count integer; published_count integer;
begin
  select count(*) into published_count
  from public.exam_papers
  where title in (
    'Paper 1 Short Mock A - 2026', 'Paper 2 Short Mock A - 2026',
    'Paper 1 Standard Mock A - 2026', 'Paper 2 Standard Mock A - 2026'
  ) and status = 'published';
  if published_count <> 4 then
    raise exception 'Expected four published short and standard mocks, found %', published_count;
  end if;

  select count(*) into invalid_count
  from (
    select p.id
    from public.exam_papers p
    left join public.exam_paper_questions epq on epq.exam_paper_id = p.id
    left join public.questions q on q.id = epq.question_id
    where p.title in (
      'Paper 1 Short Mock A - 2026', 'Paper 2 Short Mock A - 2026',
      'Paper 1 Standard Mock A - 2026', 'Paper 2 Standard Mock A - 2026'
    ) and p.status = 'published'
    group by p.id, p.total_marks
    having count(epq.question_id) <> p.total_marks
       or coalesce(sum(q.marks), 0) <> p.total_marks
  ) invalid;
  if invalid_count <> 0 then
    raise exception 'Each new mock must contain exactly its declared number of one-mark questions';
  end if;
end $$;

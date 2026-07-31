create index exam_paper_questions_question_idx on public.exam_paper_questions(question_id);
create index exam_papers_created_by_idx on public.exam_papers(created_by);

drop policy if exists "students create own attempts" on public.attempts;
drop policy if exists "students update own attempts" on public.attempts;
revoke insert, update on public.attempts from authenticated;

create or replace function public.submit_mock_attempt(
  p_exam_paper_id uuid,
  p_answers jsonb,
  p_started_at timestamptz
)
returns table (id uuid, score numeric, total_marks integer, per_topic_breakdown jsonb)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_student_id uuid := auth.uid();
  v_score integer;
  v_total integer;
  v_breakdown jsonb;
begin
  if v_student_id is null then raise exception 'Authentication required.'; end if;
  if not exists (select 1 from public.exam_papers where exam_papers.id = p_exam_paper_id and status = 'published') then
    raise exception 'Published exam paper not found.';
  end if;

  select
    coalesce(sum(case when q.question_type = 'mcq' and p_answers -> (q.id::text) = q.correct_answer then q.marks else 0 end), 0),
    coalesce(sum(q.marks), 0)
  into v_score, v_total
  from public.exam_paper_questions epq
  join public.questions q on q.id = epq.question_id
  where epq.exam_paper_id = p_exam_paper_id and q.status = 'published';

  select coalesce(jsonb_object_agg(topic_number, jsonb_build_object('score', earned, 'total', possible)), '{}'::jsonb)
  into v_breakdown
  from (
    select t.topic_number,
      sum(case when q.question_type = 'mcq' and p_answers -> (q.id::text) = q.correct_answer then q.marks else 0 end) as earned,
      sum(q.marks) as possible
    from public.exam_paper_questions epq
    join public.questions q on q.id = epq.question_id
    join public.topics t on t.id = q.topic_id
    where epq.exam_paper_id = p_exam_paper_id and q.status = 'published'
    group by t.topic_number
  ) grouped;

  return query
  insert into public.attempts (student_id, mode, exam_paper_id, started_at, submitted_at, answers, score, total_marks, per_topic_breakdown)
  values (v_student_id, 'full_mock', p_exam_paper_id, coalesce(p_started_at, now()), now(), coalesce(p_answers, '{}'::jsonb), v_score, v_total, v_breakdown)
  returning attempts.id, attempts.score, attempts.total_marks, attempts.per_topic_breakdown;
end;
$$;

revoke all on function public.submit_mock_attempt(uuid, jsonb, timestamptz) from public, anon;
grant execute on function public.submit_mock_attempt(uuid, jsonb, timestamptz) to authenticated;

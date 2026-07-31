alter function public.submit_mock_attempt(uuid, jsonb, timestamptz) security invoker;

grant insert on public.attempts to authenticated;
create policy "students create calculated mock attempts" on public.attempts
  for insert to authenticated
  with check ((select auth.uid()) = student_id and mode = 'full_mock' and exam_paper_id is not null);

create or replace function public.calculate_mock_attempt_score()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_score integer;
  v_total integer;
  v_breakdown jsonb;
begin
  if new.student_id is distinct from auth.uid() then raise exception 'Attempt owner must match the signed-in user.'; end if;
  if not exists (select 1 from public.exam_papers where exam_papers.id = new.exam_paper_id and status = 'published') then
    raise exception 'Published exam paper not found.';
  end if;
  select
    coalesce(sum(case when q.question_type = 'mcq' and new.answers -> (q.id::text) = q.correct_answer then q.marks else 0 end), 0),
    coalesce(sum(q.marks), 0)
  into v_score, v_total
  from public.exam_paper_questions epq
  join public.questions q on q.id = epq.question_id
  where epq.exam_paper_id = new.exam_paper_id and q.status = 'published';
  select coalesce(jsonb_object_agg(topic_number, jsonb_build_object('score', earned, 'total', possible)), '{}'::jsonb)
  into v_breakdown from (
    select t.topic_number,
      sum(case when q.question_type = 'mcq' and new.answers -> (q.id::text) = q.correct_answer then q.marks else 0 end) as earned,
      sum(q.marks) as possible
    from public.exam_paper_questions epq
    join public.questions q on q.id = epq.question_id
    join public.topics t on t.id = q.topic_id
    where epq.exam_paper_id = new.exam_paper_id and q.status = 'published'
    group by t.topic_number
  ) grouped;
  new.score := v_score;
  new.total_marks := v_total;
  new.per_topic_breakdown := v_breakdown;
  new.submitted_at := coalesce(new.submitted_at, now());
  return new;
end;
$$;

revoke execute on function public.calculate_mock_attempt_score() from public, anon, authenticated;
create trigger attempts_calculate_mock_score
before insert on public.attempts
for each row when (new.mode = 'full_mock')
execute function public.calculate_mock_attempt_score();

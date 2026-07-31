create policy "admins read all questions" on public.questions
  for select to authenticated
  using (coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') = 'admin');

create policy "admins create questions" on public.questions
  for insert to authenticated
  with check (
    coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') = 'admin'
    and created_by = (select auth.uid())
  );

create policy "admins update questions" on public.questions
  for update to authenticated
  using (coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') = 'admin')
  with check (coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') = 'admin');

create policy "admins delete draft questions" on public.questions
  for delete to authenticated
  using (
    coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') = 'admin'
    and status = 'draft'
  );

grant insert, update, delete on public.questions to authenticated;

create or replace function public.question_objective_matches_topic()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.syllabus_objective_id is not null and not exists (
    select 1
    from public.syllabus_objectives o
    join public.syllabus_subtopics st on st.id = o.subtopic_id
    where o.id = new.syllabus_objective_id and st.topic_id = new.topic_id
  ) then
    raise exception 'The selected syllabus objective does not belong to the selected topic.';
  end if;
  return new;
end;
$$;

revoke execute on function public.question_objective_matches_topic() from public, anon, authenticated;

create trigger questions_objective_topic_check
before insert or update of topic_id, syllabus_objective_id on public.questions
for each row execute function public.question_objective_matches_topic();

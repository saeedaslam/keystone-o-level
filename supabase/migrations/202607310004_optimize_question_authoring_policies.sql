drop policy if exists "published questions are readable" on public.questions;
drop policy if exists "admins read all questions" on public.questions;

create policy "published questions and admin drafts are readable" on public.questions
  for select to anon, authenticated
  using (
    status = 'published'
    or coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin'
  );

drop policy if exists "admins create questions" on public.questions;
create policy "admins create questions" on public.questions
  for insert to authenticated
  with check (
    coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin'
    and created_by = (select auth.uid())
  );

drop policy if exists "admins update questions" on public.questions;
create policy "admins update questions" on public.questions
  for update to authenticated
  using (coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin')
  with check (coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin');

drop policy if exists "admins delete draft questions" on public.questions;
create policy "admins delete draft questions" on public.questions
  for delete to authenticated
  using (
    coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin'
    and status = 'draft'
  );

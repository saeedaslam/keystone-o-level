drop policy if exists "public question media is readable" on storage.objects;
create index if not exists questions_created_by_idx on public.questions(created_by);
create index if not exists questions_reviewed_by_idx on public.questions(reviewed_by);
create index if not exists question_assets_question_id_idx on public.question_assets(question_id);

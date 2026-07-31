create type public.paper_status as enum ('draft', 'published', 'archived');

create table public.exam_papers (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  paper_number smallint not null check (paper_number in (1, 2)),
  title text not null,
  description text,
  duration_minutes smallint not null default 105 check (duration_minutes > 0),
  total_marks smallint not null check (total_marks > 0),
  status public.paper_status not null default 'draft',
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.exam_paper_questions (
  exam_paper_id uuid not null references public.exam_papers(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete restrict,
  position smallint not null check (position > 0),
  primary key (exam_paper_id, question_id),
  unique (exam_paper_id, position)
);

alter table public.attempts
  add column exam_paper_id uuid references public.exam_papers(id) on delete restrict,
  add column topic_id uuid references public.topics(id) on delete restrict;

create index exam_papers_subject_status_idx on public.exam_papers(subject_id, status, paper_number);
create index exam_paper_questions_paper_position_idx on public.exam_paper_questions(exam_paper_id, position);
create index attempts_exam_paper_idx on public.attempts(exam_paper_id, submitted_at desc);
create index attempts_topic_idx on public.attempts(topic_id, submitted_at desc);

alter table public.exam_papers enable row level security;
alter table public.exam_paper_questions enable row level security;

create policy "published papers and admin drafts are readable" on public.exam_papers
  for select to anon, authenticated
  using (status = 'published' or coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin');
create policy "admins create papers" on public.exam_papers for insert to authenticated
  with check (coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin' and created_by = (select auth.uid()));
create policy "admins update papers" on public.exam_papers for update to authenticated
  using (coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin')
  with check (coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin');

create policy "published paper questions and admin drafts are readable" on public.exam_paper_questions
  for select to anon, authenticated using (
    exists (select 1 from public.exam_papers p where p.id = exam_paper_id and (p.status = 'published' or coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin'))
  );
create policy "admins create paper questions" on public.exam_paper_questions for insert to authenticated
  with check (coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin');
create policy "admins delete paper questions" on public.exam_paper_questions for delete to authenticated
  using (coalesce((select auth.jwt()) -> 'app_metadata' ->> 'role', '') = 'admin');

grant select on public.exam_papers, public.exam_paper_questions to anon, authenticated;
grant insert, update on public.exam_papers to authenticated;
grant insert, delete on public.exam_paper_questions to authenticated;

insert into public.exam_papers (subject_id, paper_number, title, description, duration_minutes, total_marks, status)
select id, 2, 'Database Skills Check', 'A short timed prototype assembled from the current original published question bank.', 15, 1, 'published'
from public.subjects where code = '2210';

insert into public.exam_paper_questions (exam_paper_id, question_id, position)
select p.id, q.id, 1
from public.exam_papers p
join public.subjects s on s.id = p.subject_id and s.code = '2210'
join public.questions q on q.status = 'published'
join public.topics t on t.id = q.topic_id and t.topic_number = '9'
where p.title = 'Database Skills Check'
order by q.created_at
limit 1;

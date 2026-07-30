create extension if not exists pgcrypto;
create type public.question_status as enum ('draft', 'reviewed', 'published', 'archived');
create type public.question_kind as enum ('mcq', 'structured', 'sql', 'pseudocode');

create table public.subjects (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  exam_board text not null default 'Cambridge',
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table public.topics (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  topic_number text not null,
  name text not null,
  sort_order integer not null,
  unique(subject_id, topic_number)
);
create table public.questions (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references public.topics(id) on delete restrict,
  question_type public.question_kind not null,
  marks smallint not null check (marks > 0),
  difficulty text not null check (difficulty in ('foundation', 'core', 'extended')),
  stem_blocks jsonb not null default '[]'::jsonb check (jsonb_typeof(stem_blocks) = 'array'),
  options jsonb,
  correct_answer jsonb,
  mark_scheme jsonb not null default '[]'::jsonb,
  model_answer jsonb,
  explanation text,
  status public.question_status not null default 'draft',
  version integer not null default 1,
  created_by uuid references auth.users(id),
  reviewed_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table public.question_assets (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.questions(id) on delete cascade,
  storage_path text not null unique,
  media_type text not null check (media_type in ('image', 'diagram')),
  alt_text text not null,
  caption text,
  width integer,
  height integer,
  created_at timestamptz not null default now()
);
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  exam_session text,
  created_at timestamptz not null default now()
);
create table public.attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references auth.users(id) on delete cascade,
  mode text not null check (mode in ('topic_test', 'full_mock')),
  started_at timestamptz not null default now(),
  submitted_at timestamptz,
  answers jsonb not null default '{}'::jsonb,
  score numeric(5,2),
  total_marks integer,
  per_topic_breakdown jsonb not null default '{}'::jsonb
);

create index questions_topic_status_idx on public.questions(topic_id, status);
create index questions_created_by_idx on public.questions(created_by);
create index questions_reviewed_by_idx on public.questions(reviewed_by);
create index question_assets_question_id_idx on public.question_assets(question_id);
create index attempts_student_started_idx on public.attempts(student_id, started_at desc);
alter table public.subjects enable row level security;
alter table public.topics enable row level security;
alter table public.questions enable row level security;
alter table public.question_assets enable row level security;
alter table public.profiles enable row level security;
alter table public.attempts enable row level security;

create policy "published subjects are readable" on public.subjects for select to anon, authenticated using (active);
create policy "topics are readable" on public.topics for select to anon, authenticated using (true);
create policy "published questions are readable" on public.questions for select to anon, authenticated using (status = 'published');
create policy "published question assets are readable" on public.question_assets for select to anon, authenticated
  using (exists (select 1 from public.questions q where q.id = question_id and q.status = 'published'));
create policy "students read own profile" on public.profiles for select to authenticated using ((select auth.uid()) = id);
create policy "students update own profile" on public.profiles for update to authenticated
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
create policy "students read own attempts" on public.attempts for select to authenticated using ((select auth.uid()) = student_id);
create policy "students create own attempts" on public.attempts for insert to authenticated with check ((select auth.uid()) = student_id);
create policy "students update own attempts" on public.attempts for update to authenticated
  using ((select auth.uid()) = student_id) with check ((select auth.uid()) = student_id);
grant select on public.subjects, public.topics, public.questions, public.question_assets to anon, authenticated;
grant select, insert, update on public.profiles, public.attempts to authenticated;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('question-media', 'question-media', true, 5242880, array['image/png','image/jpeg','image/webp','image/gif'])
on conflict (id) do update set public = excluded.public;
create policy "reviewers upload question media" on storage.objects for insert to authenticated
  with check (bucket_id = 'question-media' and coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') in ('reviewer', 'admin'));
create policy "reviewers update question media" on storage.objects for update to authenticated
  using (bucket_id = 'question-media' and coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') in ('reviewer', 'admin'))
  with check (bucket_id = 'question-media' and coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') in ('reviewer', 'admin'));

insert into public.subjects (code, name) values ('2210', 'O Level Computer Science');
insert into public.topics (subject_id, topic_number, name, sort_order)
select s.id, x.topic_number, x.name, x.sort_order from public.subjects s
cross join (values
  ('1','Data representation',1), ('2','Data transmission',2), ('3','Hardware',3),
  ('4','Software',4), ('5','The internet',5), ('6','Automated technologies',6),
  ('7','Algorithm design',7), ('8','Programming',8), ('9','Databases',9),
  ('10','Boolean logic',10)
) as x(topic_number, name, sort_order) where s.code = '2210';
insert into public.questions (topic_id, question_type, marks, difficulty, stem_blocks, options, correct_answer, mark_scheme, explanation, status)
select t.id, 'mcq', 1, 'core',
  '[{"type":"paragraph","text":"The STUDENT table contains the following data."},{"type":"table","caption":"STUDENT table","headers":["StudentID","Name","Score"],"rows":[["S01","Amina","72"],["S02","Ben","84"],["S03","Chen","68"]]},{"type":"paragraph","text":"Which SQL query returns the students with a score greater than 70, highest score first?"}]'::jsonb,
  '["SELECT * FROM STUDENT WHERE Score > 70 ORDER BY Score DESC","SELECT * FROM STUDENT ORDER BY Score > 70","SELECT * FROM STUDENT WHERE Score < 70 ORDER BY Score","SELECT Score FROM STUDENT DESC"]'::jsonb,
  '0'::jsonb, '[{"mark":1,"point":"Uses WHERE Score > 70 and ORDER BY Score DESC"}]'::jsonb,
  'WHERE filters the records and ORDER BY ... DESC puts the highest score first.', 'published'
from public.topics t join public.subjects s on s.id=t.subject_id where s.code='2210' and t.topic_number='9';

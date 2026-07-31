update public.exam_papers
set status = 'draft'::public.paper_status
where status = 'published' and total_marks <> 75;

create or replace function public.validate_exam_paper_publication()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.status = 'published'::public.paper_status and new.total_marks <> 75 then
    raise exception 'Published exam papers must total exactly 75 marks';
  end if;
  return new;
end
$$;

revoke all on function public.validate_exam_paper_publication() from public, anon, authenticated;

drop trigger if exists validate_exam_paper_publication_trigger on public.exam_papers;
create trigger validate_exam_paper_publication_trigger
before insert or update of status, total_marks on public.exam_papers
for each row execute function public.validate_exam_paper_publication();

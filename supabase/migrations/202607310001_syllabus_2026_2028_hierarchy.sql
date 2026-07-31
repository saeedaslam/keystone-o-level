create table public.syllabus_versions (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references public.subjects(id) on delete cascade,
  version_code text not null,
  exam_year_from smallint not null,
  exam_year_to smallint not null,
  document_version smallint not null,
  source_url text not null,
  is_current boolean not null default false,
  created_at timestamptz not null default now(),
  unique (subject_id, version_code),
  check (exam_year_to >= exam_year_from)
);

create table public.syllabus_subtopics (
  id uuid primary key default gen_random_uuid(),
  syllabus_version_id uuid not null references public.syllabus_versions(id) on delete cascade,
  topic_id uuid not null references public.topics(id) on delete cascade,
  code text not null,
  title text not null,
  sort_order integer not null,
  unique (syllabus_version_id, code)
);

create table public.syllabus_objectives (
  id uuid primary key default gen_random_uuid(),
  subtopic_id uuid not null references public.syllabus_subtopics(id) on delete cascade,
  code text not null,
  objective text not null,
  source_page smallint,
  sort_order integer not null,
  active boolean not null default true,
  unique (subtopic_id, code)
);

alter table public.questions
  add column syllabus_objective_id uuid references public.syllabus_objectives(id) on delete set null;

create index syllabus_versions_subject_current_idx on public.syllabus_versions(subject_id, is_current);
create index syllabus_subtopics_topic_idx on public.syllabus_subtopics(topic_id, sort_order);
create index syllabus_objectives_subtopic_idx on public.syllabus_objectives(subtopic_id, sort_order);
create index questions_syllabus_objective_idx on public.questions(syllabus_objective_id);

alter table public.syllabus_versions enable row level security;
alter table public.syllabus_subtopics enable row level security;
alter table public.syllabus_objectives enable row level security;

create policy "current syllabus versions are readable" on public.syllabus_versions
  for select to anon, authenticated using (is_current);
create policy "syllabus subtopics are readable" on public.syllabus_subtopics
  for select to anon, authenticated using (
    exists (select 1 from public.syllabus_versions v where v.id = syllabus_version_id and v.is_current)
  );
create policy "syllabus objectives are readable" on public.syllabus_objectives
  for select to anon, authenticated using (
    exists (
      select 1 from public.syllabus_subtopics st
      join public.syllabus_versions v on v.id = st.syllabus_version_id
      where st.id = subtopic_id and v.is_current
    )
  );

grant select on public.syllabus_versions, public.syllabus_subtopics, public.syllabus_objectives to anon, authenticated;

insert into public.syllabus_versions
  (subject_id, version_code, exam_year_from, exam_year_to, document_version, source_url, is_current)
select id, '2026-2028-v5', 2026, 2028, 5,
  'https://www.cambridgeinternational.org/Images/697287-2026-2028-syllabus.pdf', true
from public.subjects where code = '2210'
on conflict (subject_id, version_code) do update set
  document_version = excluded.document_version,
  source_url = excluded.source_url,
  is_current = excluded.is_current;

insert into public.syllabus_subtopics (syllabus_version_id, topic_id, code, title, sort_order)
select v.id, t.id, x.code, x.title, x.sort_order
from public.syllabus_versions v
join public.subjects s on s.id = v.subject_id and s.code = '2210'
join (values
  ('1.1','Number systems',101), ('1.2','Text, sound and images',102), ('1.3','Data storage and compression',103),
  ('2.1','Types and methods of data transmission',201), ('2.2','Methods of error detection',202), ('2.3','Encryption',203),
  ('3.1','Computer architecture',301), ('3.2','Input and output devices',302), ('3.3','Data storage',303), ('3.4','Network hardware',304),
  ('4.1','Types of software and interrupts',401), ('4.2','Programming languages, translators and IDEs',402),
  ('5.1','The internet and the world wide web',501), ('5.2','Digital currency',502), ('5.3','Cyber security',503),
  ('6.1','Automated systems',601), ('6.2','Robotics',602), ('6.3','Artificial intelligence',603),
  ('7.1','Algorithm design and problem-solving',701),
  ('8.1','Programming concepts',801), ('8.2','Arrays',802), ('8.3','File handling',803),
  ('9.1','Databases',901), ('10.1','Boolean logic',1001)
) x(code, title, sort_order) on true
join public.topics t on t.subject_id = s.id and t.topic_number = split_part(x.code, '.', 1)
where v.version_code = '2026-2028-v5'
on conflict (syllabus_version_id, code) do update set title = excluded.title, sort_order = excluded.sort_order;

with objective_data(subtopic_code, code, objective, source_page, sort_order) as (values
  ('1.1','1.1.1','Explain why computers represent every form of data in binary.',12,1),
  ('1.1','1.1.2a','Understand denary, binary and hexadecimal number systems.',12,2),
  ('1.1','1.1.2b','Convert positive integers between denary, binary and hexadecimal.',12,3),
  ('1.1','1.1.3','Explain why hexadecimal is useful in computer science.',12,4),
  ('1.1','1.1.4a','Add two positive 8-bit binary integers.',12,5),
  ('1.1','1.1.4b','Recognise and explain overflow in binary addition.',12,6),
  ('1.1','1.1.5','Perform logical binary shifts and explain their effect.',12,7),
  ('1.1','1.1.6','Represent positive and negative 8-bit integers using two''s complement.',12,8),
  ('1.2','1.2.1','Explain text representation using character sets, including ASCII and Unicode.',13,1),
  ('1.2','1.2.2','Explain digital sound representation and effects of sample rate and resolution.',13,2),
  ('1.2','1.2.3','Explain digital image representation and effects of resolution and colour depth.',13,3),
  ('1.3','1.3.1','Use standard units of data storage.',14,1),
  ('1.3','1.3.2','Calculate file sizes for bitmap images and digital sound.',14,2),
  ('1.3','1.3.3','Explain the purpose and need for data compression.',14,3),
  ('1.3','1.3.4','Describe lossy and lossless compression and select an appropriate method.',14,4),
  ('2.1','2.1.1a','Explain how data is divided into packets for transmission.',14,1),
  ('2.1','2.1.1b','Describe packet structure, including header, payload and trailer.',14,2),
  ('2.1','2.1.1c','Explain packet switching from sender to receiver.',14,3),
  ('2.1','2.1.2a','Describe serial, parallel, simplex, half-duplex and full-duplex transmission.',14,4),
  ('2.1','2.1.2b','Select a suitable transmission method for a given scenario.',14,5),
  ('2.1','2.1.3','Explain how a USB interface is used to transmit data.',14,6),
  ('2.2','2.2.1','Explain why transmitted data must be checked for errors and how errors arise.',15,1),
  ('2.2','2.2.2','Describe parity, checksum and echo-check error detection.',15,2),
  ('2.2','2.2.3','Explain check digits and their use in ISBNs and barcodes.',15,3),
  ('2.2','2.2.4','Explain automatic repeat query using acknowledgements and timeout.',15,4),
  ('2.3','2.3.1','Explain the need and purpose of encryption during data transmission.',15,1),
  ('2.3','2.3.2','Explain symmetric and asymmetric encryption, including public and private keys.',15,2),
  ('3.1','3.1.1a','Explain the role of the central processing unit.',16,1),
  ('3.1','3.1.1b','Explain what a microprocessor is.',16,2),
  ('3.1','3.1.2a','Explain the purpose of Von Neumann CPU components.',16,3),
  ('3.1','3.1.2b','Describe the fetch-decode-execute cycle and each component''s role.',16,4),
  ('3.1','3.1.3','Explain how cores, cache and clock speed affect CPU performance.',16,5),
  ('3.1','3.1.4','Explain the purpose and use of a CPU instruction set.',16,6),
  ('3.1','3.1.5','Describe embedded systems and identify common applications.',16,7),
  ('3.2','3.2.1','Explain what an input device is and why it is required.',17,1),
  ('3.2','3.2.2','Explain what an output device is and why it is required.',17,2),
  ('3.2','3.2.3a','Explain what sensors are and their purposes.',17,3),
  ('3.2','3.2.3b','Identify sensor data and select a suitable sensor for a context.',17,4),
  ('3.3','3.3.1','Explain primary storage, including the roles of RAM and ROM.',18,1),
  ('3.3','3.3.2','Explain secondary storage and why it is needed.',18,2),
  ('3.3','3.3.3','Describe magnetic, optical and solid-state storage technologies.',18,3),
  ('3.3','3.3.4','Explain how virtual memory is created, used and why it is needed.',18,4),
  ('3.3','3.3.5','Explain cloud storage.',18,5),
  ('3.3','3.3.6','Compare cloud storage with local storage.',18,6),
  ('3.4','3.4.1','Explain why a network interface card is needed.',19,1),
  ('3.4','3.4.2','Explain the purpose and structure of a MAC address.',19,2),
  ('3.4','3.4.3a','Explain the purpose of an IP address.',19,3),
  ('3.4','3.4.3b','Compare static and dynamic addresses and IPv4 with IPv6.',19,4),
  ('3.4','3.4.4','Describe the role of a router in a network.',19,5),
  ('4.1','4.1.1','Distinguish system software from application software and give examples.',19,1),
  ('4.1','4.1.2','Describe the role and basic functions of an operating system.',19,2),
  ('4.1','4.1.3','Explain how hardware, firmware and an operating system run applications.',20,3),
  ('4.1','4.1.4','Describe how hardware and software interrupts are generated and handled.',20,4),
  ('4.2','4.2.1','Compare high-level and low-level languages.',20,1),
  ('4.2','4.2.2','Explain assembly language, mnemonics and the role of an assembler.',20,2),
  ('4.2','4.2.3','Describe how compilers and interpreters translate code and report errors.',20,3),
  ('4.2','4.2.4','Compare the advantages and disadvantages of compilers and interpreters.',21,4),
  ('4.2','4.2.5','Explain the role and common functions of an IDE.',21,5),
  ('5.1','5.1.1','Distinguish the internet from the world wide web.',21,1),
  ('5.1','5.1.2','Explain the structure and purpose of a URL.',21,2),
  ('5.1','5.1.3','Describe the purpose and operation of HTTP and HTTPS.',21,3),
  ('5.1','5.1.4','Explain the purpose and functions of a web browser.',21,4),
  ('5.1','5.1.5','Describe how a web page is located, retrieved and displayed from a URL.',22,5),
  ('5.1','5.1.6','Explain session and persistent cookies and their uses.',22,6),
  ('5.2','5.2.1','Explain digital currency and how it is used.',22,1),
  ('5.2','5.2.2','Explain blockchain and its use in tracking digital-currency transactions.',22,2),
  ('5.3','5.3.1','Describe the processes and aims of common cyber-security threats.',22,1),
  ('5.3','5.3.2','Explain measures used to protect data from security threats.',23,2),
  ('6.1','6.1.1','Explain how sensors, microprocessors and actuators form automated systems.',23,1),
  ('6.1','6.1.2','Evaluate advantages and disadvantages of automated systems in context.',23,2),
  ('6.2','6.2.1','Explain what robotics means.',24,1),
  ('6.2','6.2.2','Describe the characteristics of a robot.',24,2),
  ('6.2','6.2.3','Explain robot roles and evaluate advantages and disadvantages of their use.',24,3),
  ('6.3','6.3.1','Explain what artificial intelligence means.',24,1),
  ('6.3','6.3.2','Describe AI characteristics, including reasoning, learning and adaptation.',24,2),
  ('6.3','6.3.3','Explain the basic operation of expert systems and machine learning.',24,3),
  ('7.1','7.1.1','Apply the analysis, design, coding and testing stages of the program development life cycle.',25,1),
  ('7.1','7.1.2a','Explain how systems are composed of nested subsystems.',25,2),
  ('7.1','7.1.2b','Decompose a problem into component parts.',25,3),
  ('7.1','7.1.2c','Design solutions using structure diagrams, flowcharts and pseudocode.',25,4),
  ('7.1','7.1.3','Explain the purpose and processes of a given algorithm.',25,5),
  ('7.1','7.1.4','Use linear search, bubble sort, totalling, counting and aggregate methods.',26,6),
  ('7.1','7.1.5a','Select and apply appropriate input validation checks.',26,7),
  ('7.1','7.1.5b','Select and apply visual and double-entry verification checks.',26,8),
  ('7.1','7.1.6','Select and apply normal, abnormal, extreme and boundary test data.',26,9),
  ('7.1','7.1.7','Complete a trace table to dry-run an algorithm.',26,10),
  ('7.1','7.1.8','Identify and correct errors in algorithms.',26,11),
  ('7.1','7.1.9','Write and amend precise algorithms using pseudocode, code and flowcharts.',26,12),
  ('8.1','8.1.1','Declare and use variables and constants.',27,1),
  ('8.1','8.1.2','Use integer, real, character, string and Boolean data types.',27,2),
  ('8.1','8.1.3','Use input and output.',27,3),
  ('8.1','8.1.4a','Use sequence.',27,4),
  ('8.1','8.1.4b','Use selection with IF and CASE statements.',27,5),
  ('8.1','8.1.4c','Use count-controlled, pre-condition and post-condition iteration.',27,6),
  ('8.1','8.1.4d','Use totalling and counting.',27,7),
  ('8.1','8.1.4e','Use string length, substring, upper and lower operations.',27,8),
  ('8.1','8.1.4f','Use arithmetic, relational and logical operators.',28,9),
  ('8.1','8.1.5','Use nested selection and iteration.',28,10),
  ('8.1','8.1.6a','Explain procedures, functions and parameters.',28,11),
  ('8.1','8.1.6b','Define and use procedures and functions with up to three parameters.',28,12),
  ('8.1','8.1.6c','Use local and global variables.',28,13),
  ('8.1','8.1.7','Use standard library routines.',28,14),
  ('8.1','8.1.8','Create maintainable programs using meaningful identifiers and suitable modularisation and comments.',29,15),
  ('8.2','8.2.1','Declare and use one-dimensional and two-dimensional arrays.',29,1),
  ('8.2','8.2.2','Explain appropriate uses of arrays.',29,2),
  ('8.2','8.2.3','Read and write array values using iteration.',29,3),
  ('8.3','8.3.1','Explain why programs store data in files.',29,1),
  ('8.3','8.3.2','Open, close, read from and write to files.',29,2),
  ('9.1','9.1.1','Define a single-table database from storage requirements.',30,1),
  ('9.1','9.1.2','Select suitable basic data types for database fields.',30,2),
  ('9.1','9.1.3','Explain primary keys and select a suitable key.',30,3),
  ('9.1','9.1.4','Read, complete and interpret SQL queries for a single table.',30,4),
  ('10.1','10.1.1','Identify and use standard logic-gate symbols.',31,1),
  ('10.1','10.1.2','Define and explain NOT, AND, OR, NAND, NOR and XOR gates.',31,2),
  ('10.1','10.1.3a','Create logic circuits from statements, expressions and truth tables.',31,3),
  ('10.1','10.1.3b','Complete truth tables from statements, expressions and circuits.',31,4),
  ('10.1','10.1.3c','Write logic expressions from statements, circuits and truth tables.',31,5)
)
insert into public.syllabus_objectives (subtopic_id, code, objective, source_page, sort_order)
select st.id, d.code, d.objective, d.source_page, d.sort_order
from objective_data d
join public.syllabus_subtopics st on st.code = d.subtopic_code
join public.syllabus_versions v on v.id = st.syllabus_version_id and v.version_code = '2026-2028-v5'
join public.subjects s on s.id = v.subject_id and s.code = '2210'
on conflict (subtopic_id, code) do update set
  objective = excluded.objective,
  source_page = excluded.source_page,
  sort_order = excluded.sort_order,
  active = true;

update public.questions q
set syllabus_objective_id = o.id
from public.syllabus_objectives o
join public.syllabus_subtopics st on st.id = o.subtopic_id
join public.syllabus_versions v on v.id = st.syllabus_version_id
join public.subjects s on s.id = v.subject_id
where q.topic_id = st.topic_id
  and s.code = '2210'
  and o.code = '9.1.4'
  and q.syllabus_objective_id is null
  and q.stem_blocks::text ilike '%SQL%';

with seed(paper_number, seed_order, objective_code, concept, correct_fact, distractor_1, distractor_2, distractor_3) as (values
  (1,1,'1.1.1','binary representation','Binary has two states that electronic circuits can represent reliably.','Binary is used because it stores every value in one bit.','Binary removes the need for character encoding.','Binary is understood directly by every human user.'),
  (1,2,'1.1.2b','number-base conversion','The denary value 15 is represented as 1111 in binary.','The denary value 15 is represented as 1010 in binary.','The hexadecimal value F is equal to denary 16.','A binary place value is multiplied by ten at each position.'),
  (1,3,'1.2.1','character sets','A character set assigns a numeric code to each supported character.','A character set stores every character as an image.','ASCII supports more characters than Unicode in every implementation.','Character sets are used only when data is printed.'),
  (1,4,'1.2.2','digital sound','A higher sample rate records the sound wave more frequently.','A higher sample rate always makes the recording shorter.','Sample resolution controls how many times per second sound is sampled.','Digital sound is stored without any numeric values.'),
  (1,5,'1.3.4','data compression','Lossless compression allows the original data to be reconstructed exactly.','Lossy compression always produces a larger file.','Lossless compression permanently removes repeated data.','Compression changes every file into an image format.'),
  (1,6,'2.1.1b','packet structure','A packet header can contain source, destination and sequence information.','A packet header contains only the user''s message.','Every packet must follow a different route.','The packet trailer always contains the destination address.'),
  (1,7,'2.1.2a','duplex transmission','Full-duplex transmission allows data to travel in both directions at the same time.','Simplex transmission sends data both ways at the same time.','Half-duplex transmission permits data in only one direction forever.','Parallel transmission sends one bit after another on one wire.'),
  (1,8,'2.2.2','parity checking','A parity bit can reveal that an odd number of bits changed in a transmitted byte.','A parity bit corrects every transmission error automatically.','Even parity means every byte contains an odd number of 1 bits.','Parity checking encrypts the transmitted data.'),
  (1,9,'2.2.4','automatic repeat query','ARQ can request retransmission after a timeout or negative acknowledgement.','ARQ compresses a packet before it is sent.','ARQ prevents interference from occurring.','ARQ replaces packet headers with check digits.'),
  (1,10,'2.3.2','asymmetric encryption','Asymmetric encryption uses a related public key and private key.','Asymmetric encryption requires both users to publish their private keys.','Asymmetric encryption uses no keys.','The same public key must remain secret from everyone.'),
  (1,11,'3.1.1a','the CPU','The CPU executes instructions and processes data.','The CPU provides permanent optical storage.','The CPU is used only to display pixels.','The CPU assigns internet domain names.'),
  (1,12,'3.1.2b','the fetch-decode-execute cycle','The program counter holds the address of the next instruction.','The program counter stores every file on the computer.','The accumulator always holds the address of the next instruction.','The address bus carries only sound samples.'),
  (1,13,'3.2.3b','sensor selection','A temperature sensor is suitable for monitoring heat in a greenhouse.','A microphone is the best sensor for measuring soil moisture.','A pressure sensor directly measures light intensity.','An actuator is a sensor that collects humidity data.'),
  (1,14,'3.3.3','secondary storage','An SSD stores data using flash memory and has no moving read head.','An SSD reads pits and lands using a laser.','A magnetic disk stores data only while power is supplied.','Optical media uses floating-gate transistors.'),
  (1,15,'3.4.4','routers','A router forwards packets towards their destination between networks.','A router converts every website into machine code.','A router is required to print a local document.','A router stores the CPU instruction set.'),
  (1,16,'4.1.2','operating systems','An operating system manages memory, files, peripherals and running applications.','An operating system is an application used only for spreadsheets.','An operating system replaces all hardware components.','An operating system translates every URL into HTML.'),
  (1,17,'4.1.4','interrupts','An interrupt causes the processor to pause its current task and run a service routine.','An interrupt permanently deletes the currently running program.','Only software can generate an interrupt.','Interrupts are used exclusively for data compression.'),
  (1,18,'4.2.3','compilers','A compiler translates the whole source program and can produce an executable file.','A compiler translates and executes one line at a time without an executable.','A compiler is a physical CPU component.','A compiler can translate only machine code into English.'),
  (1,19,'4.2.3','interpreters','An interpreter normally translates and executes source code one statement at a time.','An interpreter always produces a separate executable before running.','An interpreter is used to route packets.','An interpreter stores data permanently in ROM.'),
  (1,20,'4.2.5','integrated development environments','An IDE can provide a code editor, translator and error diagnostics.','An IDE is a network address assigned by a router.','An IDE is used only to compress images.','An IDE replaces the programming language.'),
  (1,21,'5.1.1','the internet and web','The internet is network infrastructure, while the web is a service using that infrastructure.','The web is the physical cabling and the internet is one web page.','The internet and web are two names for exactly the same component.','The web can operate without any network infrastructure.'),
  (1,22,'5.1.5','domain name resolution','DNS finds the IP address associated with a domain name.','DNS encrypts every file stored on a web server.','DNS renders HTML on the user''s screen.','DNS is a type of persistent cookie.'),
  (1,23,'5.3.2','cyber-security protection','Two-step verification requires an additional proof of identity beyond a password.','A firewall guarantees that users can never make mistakes.','Phishing is prevented by increasing image resolution.','A proxy server is a type of computer virus.'),
  (1,24,'6.1.1','automated systems','An automated control system can use sensor input, processor decisions and actuator output.','An automated system cannot receive data from its surroundings.','A sensor changes the physical environment directly.','An actuator performs every calculation in the system.'),
  (1,25,'6.3.3','artificial intelligence systems','An expert system uses a knowledge base, rules and an inference engine.','An expert system requires no stored knowledge.','Machine learning means a human rewrites every rule after each input.','Artificial intelligence is another name for secondary storage.'),
  (2,1,'7.1.1','the program development life cycle','Analysis identifies the problem, requirements, inputs, processes and outputs.','Testing must be completed before the problem is analysed.','Coding is the stage where requirements are first discovered.','Design is limited to choosing a computer brand.'),
  (2,2,'7.1.2b','decomposition','Decomposition breaks a complex problem into smaller manageable parts.','Decomposition combines every subsystem into one instruction.','Decomposition removes the need for testing.','Decomposition is a method of encrypting a program.'),
  (2,3,'7.1.5a','validation','A range check tests whether input lies between permitted limits.','A range check confirms that two entered copies are identical.','A presence check proves that a value has the correct meaning.','Validation guarantees that entered data is factually correct.'),
  (2,4,'7.1.5b','verification','Double entry compares two independently entered copies of the same data.','Verification guarantees that the original source data is true.','A visual check is performed only by the CPU.','Verification replaces all validation checks.'),
  (2,5,'7.1.6','test data','Boundary testing includes accepted limits and the nearest rejected values.','Normal test data must always be rejected.','Abnormal data is valid data in the middle of a range.','Extreme data is always outside the allowed range.'),
  (2,6,'7.1.7','trace tables','A trace table records variable values and outputs as an algorithm is dry-run.','A trace table automatically corrects syntax errors.','A trace table stores only the final output.','A trace table is used to encrypt source code.'),
  (2,7,'7.1.4','linear search','A linear search checks items in sequence until the target is found or the list ends.','A linear search requires the data to be sorted into pairs.','A linear search always checks exactly one item.','A linear search swaps adjacent out-of-order values.'),
  (2,8,'7.1.4','bubble sort','A bubble sort repeatedly compares adjacent values and swaps those in the wrong order.','A bubble sort finds a value without changing the list.','A bubble sort requires a database primary key.','A bubble sort can process only Boolean values.'),
  (2,9,'7.1.9','precise algorithms','A comparison should state a precise condition such as Score >= 50.','A precise algorithm can replace every condition with the word maybe.','Variable values do not need to be updated in an algorithm.','Flowcharts cannot represent selection.'),
  (2,10,'8.1.1','variables and constants','A variable can change while a constant should retain its defined value.','A constant must change after every loop iteration.','A variable is always a text value.','Constants cannot be given meaningful identifiers.'),
  (2,11,'8.1.2','data types','A Boolean variable stores one of two logical values.','An integer must contain a decimal fraction.','A string can store only one character.','A real value can store only TRUE or FALSE.'),
  (2,12,'8.1.4b','selection','An IF statement chooses which statements execute according to a condition.','Selection repeats statements a fixed number of times.','Selection stores multiple items under one identifier.','An IF statement cannot contain an ELSE branch.'),
  (2,13,'8.1.4c','iteration','A post-condition loop executes its body before testing the condition.','A post-condition loop can never execute its body.','A count-controlled loop has no control variable.','Iteration means selecting exactly one branch.'),
  (2,14,'8.1.4e','string handling','A substring operation extracts part of a string.','The length operation converts a string into an array.','Upper changes every numeric value into text.','String handling can be performed only on single characters.'),
  (2,15,'8.1.4f','operators','MOD returns the remainder after integer division.','DIV returns the remainder after integer division.','AND is an arithmetic multiplication operator.','The relational operator > means not equal to.'),
  (2,16,'8.1.6b','procedures and functions','A function returns a value to the point from which it was called.','A procedure must always return exactly one value.','Parameters can be used only by global variables.','A function cannot contain selection or iteration.'),
  (2,17,'8.1.6c','variable scope','A local variable is accessible within the procedure or function where it is declared.','A local variable is automatically accessible everywhere.','A global variable can be read only inside one loop.','Scope determines the number of bits in a character.'),
  (2,18,'8.2.1','arrays','A two-dimensional array can be addressed using a row index and a column index.','A one-dimensional array requires three indexes.','Every array element must have a different identifier.','Arrays cannot be processed using iteration.'),
  (2,19,'8.3.2','file handling','A program should open a file before reading it and close it when finished.','Closing a file erases all data stored in it.','A file can be read only one character in total.','Opening a file always prints its contents.'),
  (2,20,'8.1.8','maintainable programs','Meaningful identifiers and modular procedures make code easier to understand and maintain.','Maintainable code avoids all indentation and comments.','A maintainable program must place all statements in one procedure.','Identifier names should never describe their purpose.'),
  (2,21,'9.1.1','database records and fields','A record contains the fields describing one entity instance.','A field is the complete collection of every table.','A record is always the primary key only.','A database table cannot contain multiple records.'),
  (2,22,'9.1.3','primary keys','A primary key uniquely identifies each record in a table.','A primary key must contain the same value in every record.','A primary key is used only to sort records alphabetically.','Every field in a table must be the primary key.'),
  (2,23,'9.1.4','SQL filtering','A WHERE clause selects records that meet a condition.','A FROM clause arranges results in descending order.','ORDER BY removes every duplicate field.','SELECT specifies the file name used by the operating system.'),
  (2,24,'9.1.4','SQL aggregation','COUNT returns the number of records selected by a query.','SUM arranges text fields alphabetically.','COUNT changes every value into an integer data type.','WHERE calculates the total of a numeric field.'),
  (2,25,'10.1.2','logic gates','An XOR gate outputs 1 when its two inputs are different.','An AND gate outputs 1 when either input is 1.','A NOT gate requires two inputs.','A NOR gate always produces the same output as OR.')
), variants(variant) as (values (1),(2),(3)), prepared as (
  select seed.*, variants.variant,
    case variants.variant when 1 then 'Which statement about ' || concept || ' is correct?'
      when 2 then 'A student is revising ' || concept || '. Which note is accurate?'
      else 'Select the correct description of ' || concept || '.' end as stem,
    case variants.variant when 1 then jsonb_build_array(correct_fact,distractor_1,distractor_2,distractor_3)
      when 2 then jsonb_build_array(distractor_1,correct_fact,distractor_2,distractor_3)
      else jsonb_build_array(distractor_1,distractor_2,correct_fact,distractor_3) end as options,
    variants.variant - 1 as answer
  from seed cross join variants
)
insert into public.questions (topic_id, syllabus_objective_id, question_type, marks, difficulty, stem_blocks, options, correct_answer, mark_scheme, explanation, status)
select st.topic_id, o.id, 'mcq', 1,
  case when p.variant=1 then 'foundation' when p.variant=2 then 'core' else 'extended' end,
  jsonb_build_array(jsonb_build_object('type','paragraph','text',p.stem)), p.options, to_jsonb(p.answer),
  jsonb_build_array(jsonb_build_object('mark',1,'point',p.correct_fact)),
  '[Original bank 2026 v1] ' || p.correct_fact, 'draft'
from prepared p
join public.syllabus_objectives o on o.code=p.objective_code
join public.syllabus_subtopics st on st.id=o.subtopic_id
join public.syllabus_versions sv on sv.id=st.syllabus_version_id and sv.version_code='2026-2028-v5';

insert into public.exam_papers (subject_id, paper_number, title, description, duration_minutes, total_marks, status)
select s.id, p.paper_number, p.title, p.description, 105, 75, 'draft'
from public.subjects s cross join (values
  (1,'Paper 1 Complete Practice – Review Draft','75 original one-mark questions covering Topics 1–6. Human review is required before publication.'),
  (2,'Paper 2 Complete Practice – Review Draft','75 original one-mark questions covering Topics 7–10. Human review is required before publication.')
) p(paper_number,title,description) where s.code='2210';

with ranked as (
  select p.id as paper_id, q.id as question_id,
    row_number() over (partition by p.id order by t.sort_order, o.code, q.id)::smallint as position
  from public.exam_papers p
  join public.subjects s on s.id=p.subject_id and s.code='2210'
  join public.questions q on q.explanation like '[Original bank 2026 v1]%'
  join public.topics t on t.id=q.topic_id
  join public.syllabus_objectives o on o.id=q.syllabus_objective_id
  where p.title like '%Review Draft'
    and ((p.paper_number=1 and t.sort_order between 1 and 6) or (p.paper_number=2 and t.sort_order between 7 and 10))
)
insert into public.exam_paper_questions (exam_paper_id, question_id, position)
select paper_id, question_id, position from ranked;

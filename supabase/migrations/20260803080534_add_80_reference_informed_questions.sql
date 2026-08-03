-- Original 2026-2028 questions informed by the topic coverage of the supplied
-- revision PDFs. No source question wording, answers, or artwork is reproduced.
with seed(
  objective_code, visual_url,
  q1, c1, w11, w12, w13,
  q2, c2, w21, w22, w23
) as (values
-- Data representation (12)
('1.1.2a','/question-media/binary-grid.svg','Which hexadecimal digit represents denary 13?','D','B','E','F','What is binary 101101 in denary?','45','43','44','46'),
('1.1.3',null,'Why is hexadecimal often used when displaying machine values?','It represents long binary patterns compactly','It stores negative numbers without encoding','It removes the need for binary','It can represent only letters','How many binary bits correspond to one hexadecimal digit?','4','2','8','16'),
('1.1.4b',null,'Why does 11110000 + 00110000 overflow an 8-bit register?','The result requires a ninth bit','Both numbers begin with 1','The answer contains zeros','The register uses hexadecimal','What is the maximum unsigned denary value in eight bits?','255','256','127','128'),
('1.1.5','/question-media/binary-grid.svg','What is 00110110 after a logical left shift by one place?','01101100','00011011','10110110','01101101','What usually happens to a positive unsigned value after one logical right shift?','It is divided by two, discarding any remainder','It is multiplied by two','Its sign is inverted','Eight is added'),
('1.3.1',null,'How many bits are in three bytes?','24','3','8','32','Which unit is most suitable for the capacity of a modern solid-state drive?','Terabyte','Bit','Nibble','Hertz'),
('1.3.4',null,'Which compression is suitable for a program source file?','Lossless','Lossy','Analogue','Parity','Why is lossy compression often acceptable for streamed music?','Small removed details may be imperceptible','The original is always reconstructed exactly','It increases the sample rate','It prevents unauthorised access'),

-- Communication (8)
('2.1.1a','/question-media/packet-routes.svg','What is the main benefit of dividing a large message into packets?','Network links can be shared efficiently','Every packet becomes analogue','The receiver needs no address','Errors become impossible','Which part of a packet contains the user data being transmitted?','Payload','Header','Trailer only','Sequence number'),
('2.1.2b',null,'Which method is most suitable for a long-distance connection using one data channel?','Serial transmission','Parallel transmission','Full-parallel duplex only','Optical storage','Why is parallel transmission more prone to skew over long distances?','Bits on separate wires may arrive at different times','It sends only one bit','It cannot include a clock','It always uses radio'),
('2.2.3',null,'What is the purpose of a check digit on a barcode?','Detect data-entry or scanning errors','Encrypt the product price','Compress the product code','Route the product online','A recalculated check digit differs from the transmitted digit. What should happen?','Reject or request the data again','Accept it without warning','Change it into a password','Delete the validation rule'),
('2.3.1',null,'Why is data encrypted before transmission on a public network?','To make intercepted content unreadable without the key','To guarantee packets never get lost','To reduce every file size','To remove the destination address','What is plaintext?','Data before encryption or after successful decryption','An encryption key stored in hardware','A packet header','Compressed binary only'),

-- Hardware (12)
('3.1.1b','/question-media/cpu-buses.svg','What is a microprocessor?','A CPU implemented on an integrated circuit','A mechanical storage disk','A network protocol','A screen input device','Why are microprocessors used in many embedded products?','They can execute stored control programs compactly','They require no power','They are always general-purpose desktop computers','They contain only ROM'),
('3.1.4',null,'What is an instruction set?','The machine operations a processor can execute','All files stored by a user','A list of website addresses','A collection of sensor readings','Why must compiled machine code match the target CPU instruction set?','Different processor families may encode operations differently','Every CPU uses identical opcodes','The instruction set is stored in the monitor','Only interpreters execute instructions'),
('3.1.5',null,'Which device most clearly contains an embedded system?','A microwave controller','A removable optical disc','A passive network cable','A printed worksheet','What distinguishes an embedded system from a general-purpose computer?','It is designed for a specific control function','It cannot contain software','It has unlimited storage','It must use a keyboard'),
('3.2.1',null,'Which device converts a paper photograph into digital input?','Scanner','Projector','Speaker','Actuator','Why is a microphone an input device?','It converts sound into data for processing','It produces printed output','It stores files permanently','It routes packets'),
('3.2.2',null,'Which output device is suitable for producing a physical prototype?','3D printer','Barcode reader','Touch sensor','Microphone','Why might a projector be chosen instead of a monitor?','It can display a large image to an audience','It permanently stores the image','It provides biometric input','It executes the application'),
('3.3.3',null,'Which storage technology uses a laser to read pits and lands?','Optical','Magnetic','Solid-state','Cloud protocol','Which storage medium has no moving parts and uses electronic memory cells?','Solid-state drive','Magnetic tape','Optical disc','Hard disk platter'),

-- Software and languages (8)
('4.1.3',null,'What is firmware?','Software stored in non-volatile memory that controls hardware','A user-created spreadsheet','A temporary web cookie','An external hard disk','What normally loads the operating system after firmware completes its startup checks?','Boot process','Compiler debugger','DNS server','Image editor'),
('4.2.1',null,'Which feature is typical of a high-level language?','Human-readable statements and portability','Only numeric opcodes','Direct execution with no translation','Dependence on one memory address','Why can low-level code offer precise hardware control?','Instructions closely match processor operations','It is written as natural-language paragraphs','It never uses registers','It is independent of the CPU'),
('4.2.2',null,'What does an assembler translate?','Assembly language into machine code','Machine code into a photograph','HTML into an IP address','User data into firmware','What is a mnemonic in assembly language?','A short symbolic name for an instruction','A type of logic gate','A storage unit','An error-detection bit'),
('4.2.4',null,'Why is compiled software often faster during repeated execution?','Translation was completed before running','Each statement is translated again every time','It contains no machine instructions','It bypasses the CPU','Why can an interpreter be convenient while debugging?','A program can stop near the statement containing an error','It always hides all errors','It creates hardware automatically','It removes the source code'),

-- Internet and security (8)
('5.1.4',null,'Which browser function converts HTML and CSS into a visible page?','Rendering','Encryption key generation','Packet switching','File defragmentation','What is the purpose of browser history?','Record previously visited pages','Store every website permanently','Replace DNS','Detect parity errors'),
('5.2.2',null,'Why are blocks linked using cryptographic hashes?','Changing an earlier block becomes detectable','Hashes reveal private keys','Every block becomes editable anonymously','No copies of the ledger are needed','What does a distributed blockchain ledger mean?','Multiple participants keep synchronised copies','Only one secret computer stores it','It is printed on paper','It contains no transaction order'),
('5.3.1',null,'Malware encrypts a victim''s files and demands payment. What is it?','Ransomware','Phishing','Firewall','Cookie','What does a denial-of-service attack attempt to do?','Overload a service so legitimate users cannot access it','Improve server response time','Encrypt a user''s backup','Validate every input'),
('5.3.2',null,'Why should operating systems receive security updates?','To fix known vulnerabilities','To reduce all file sizes','To change every IP address permanently','To disable authentication','Which practice best protects an account if its password is stolen?','Multi-factor authentication','Reusing the password elsewhere','Disabling encryption','Opening every email attachment'),

-- Algorithms (12)
('7.1.1',null,'During which development stage are required inputs and outputs identified?','Analysis','Coding','Installation only','Maintenance only','During which stage is pseudocode normally produced before implementation?','Design','Evaluation after retirement','Data entry','Hardware disposal'),
('7.1.2a',null,'What is a subsystem?','A smaller system that contributes to a larger system','An invalid test value','A single binary digit','A compiler error','Why can a subsystem contain further subsystems?','Complex systems can be decomposed at several levels','Only hardware can be decomposed','A subsystem cannot have inputs','Every system has one task'),
('7.1.3','/question-media/flowchart-loop.svg','What is the purpose of an algorithm?','Provide a finite sequence of steps to solve a problem','Store data permanently','Draw a user interface only','Replace all testing','Why should an algorithm be unambiguous?','Each step must have one clear interpretation','It should produce random instructions','It must avoid inputs','It should never terminate'),
('7.1.5b',null,'What does double-entry verification compare?','Two independently entered copies','A value with a permitted range','A barcode with a check digit','A password with a public key','What is visual verification?','A person compares entered data with the original source','The CPU proves data is true','A sensor performs a range check','A compiler checks syntax'),
('7.1.8',null,'A loop condition never becomes false. What type of error is this?','Logic error','Transmission parity error','Hardware address error','Compression error','Which debugging action best helps locate an incorrect variable update?','Trace variable values step by step','Increase image resolution','Change the file extension','Disable all tests'),
('7.1.9',null,'Which pseudocode assignment correctly increases Count by one?','Count ← Count + 1','Count = 1 only','Count + 1 ← Count','OUTPUT Count + 1 only','Why should identifier names be meaningful?','They make the algorithm easier to understand and maintain','They make variables global','They remove the need for data types','They encrypt values'),

-- Programming and arrays (12)
('8.1.2',null,'Which data type should store the value 18.75?','REAL','INTEGER','BOOLEAN','CHAR only','Which data type should store one letter such as Y?','CHAR','REAL','BOOLEAN','ARRAY only'),
('8.1.3',null,'Which statement obtains a value from the user in Cambridge pseudocode?','INPUT Value','OUTPUT Value','DECLARE Value','CLOSEFILE Value','What does OUTPUT Total do?','Displays or returns the current value of Total','Reads Total from a file automatically','Declares Total as an integer','Makes Total constant'),
('8.1.4d',null,'Which variable should be initialised to zero before totalling values?','Total','LastInput only','Maximum as text','Loop condition as a file','How does a counting algorithm differ from a totalling algorithm?','Counting adds one per qualifying item; totalling adds item values','Counting cannot use iteration','Totalling stores only Boolean values','They are always identical'),
('8.1.5',null,'What is nested selection?','An IF or CASE inside another selection','A variable inside a string','Two files with the same name','A loop with no body','Why might nested loops process a two-dimensional array?','One loop can traverse rows and another columns','Arrays have no indexes','Each loop deletes a dimension','Nested loops execute once only'),
('8.2.2','/question-media/array-grid.svg','Why is an array suitable for storing 30 daily temperatures?','Related values of one type can share one identifier and indexes','Every value needs a different data type','Arrays prevent iteration','The values become constants','When is a two-dimensional array appropriate?','Representing rows and columns such as a seating grid','Storing one isolated Boolean','Holding one character only','Replacing every procedure'),
('8.3.1',null,'Why should a program use a file for customer records?','Data can persist after the program ends','Files are always faster than CPU cache','A file cannot contain text','Files make validation unnecessary','Which data is most suitable for temporary storage in a variable rather than a file?','A running total used only during one execution','A permanent list of accounts','Archived annual results','Saved configuration settings'),

-- Databases (4)
('9.1.4',null,'Which condition selects employees in Department 3 with Salary above 50000?','WHERE Department = 3 AND Salary > 50000','WHERE Department = 3 OR Salary < 50000','ORDER BY Department AND Salary','SELECT Department > Salary','What does ORDER BY Name ASC do?','Sorts names alphabetically from A to Z','Selects names beginning with ASC','Counts the name records','Deletes duplicate names'),
('9.1.2',null,'Which database type is suitable for whether an item is in stock?','Boolean','Real','Date','Image only','Which type is suitable for a calendar value such as 2027-06-15?','Date','Boolean','Character only','Integer arithmetic only'),

-- Boolean logic (4)
('10.1.3a','/question-media/logic-circuit.svg','A security light turns on when Motion is detected AND it is NOT Daylight. Which circuit is required?','AND gate combining Motion with NOT Daylight','OR gate combining Motion and Daylight','NOT Motion only','XOR with two Daylight inputs','An alarm sounds if DoorOpen OR WindowOpen. Which gate combines the sensors?','OR','AND','NOT','NAND used as an inverter only'),
('10.1.3b',null,'For Q = A AND (NOT B), what is Q when A=1 and B=0?','1','0','A','B','For Q = A XOR B, what is Q when A=1 and B=1?','0','1','2','Undefined')
), expanded as (
  select objective_code, visual_url, item_no, stem, correct, wrong1, wrong2, wrong3
  from seed cross join lateral (values
    (1,q1,c1,w11,w12,w13),(2,q2,c2,w21,w22,w23)
  ) x(item_no,stem,correct,wrong1,wrong2,wrong3)
), prepared as (
  select e.*, o.id objective_id, st.topic_id,
    case when item_no=1 then jsonb_build_array(correct,wrong1,wrong2,wrong3)
      else jsonb_build_array(wrong1,correct,wrong2,wrong3) end answer_options,
    case when item_no=1 then 0 else 1 end answer_index
  from expanded e
  join public.syllabus_objectives o on o.code=e.objective_code
  join public.syllabus_subtopics st on st.id=o.subtopic_id
  join public.syllabus_versions sv on sv.id=st.syllabus_version_id
    and sv.version_code='2026-2028-v5'
)
insert into public.questions (
  topic_id, syllabus_objective_id, question_type, marks, difficulty,
  stem_blocks, options, correct_answer, mark_scheme, explanation, status
)
select topic_id, objective_id, 'mcq', 1,
  case when item_no=1 then 'core' else 'extended' end,
  case when visual_url is null then
    jsonb_build_array(jsonb_build_object('type','paragraph','text',stem))
  else jsonb_build_array(
    jsonb_build_object('type','image','url',visual_url,'alt','Original technical diagram supplied for this question'),
    jsonb_build_object('type','paragraph','text',stem)) end,
  answer_options, to_jsonb(answer_index),
  jsonb_build_array(jsonb_build_object('mark',1,'point',correct)),
  '[Reference-informed bank 2026 v3] ' || correct,
  'published'
from prepared;

do $$
declare bank_count integer; distinct_stems integer;
begin
  select count(*), count(distinct stem_blocks::text)
  into bank_count, distinct_stems from public.questions
  where explanation like '[Reference-informed bank 2026 v3]%';
  if bank_count <> 80 or distinct_stems <> 80 then
    raise exception 'Expected 80 distinct v3 questions, found % rows and % stems', bank_count, distinct_stems;
  end if;
end $$;

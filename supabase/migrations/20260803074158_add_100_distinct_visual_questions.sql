-- One hundred original, syllabus-mapped knowledge checks for the 2026-2028 syllabus.
-- Each seed row contains two different checks of the same objective (not wording variants).
-- Technical artwork is original project-owned SVG stored under public/question-media.

with seed(
  objective_code, visual_url,
  q1, c1, w11, w12, w13,
  q2, c2, w21, w22, w23
) as (values
-- Topic 1: Data representation
('1.1.2b','/question-media/binary-grid.svg','What denary value is shown by the 8-bit register?','90','74','106','122','What is denary 90 written in hexadecimal?','5A','A5','59','6A'),
('1.1.4a','/question-media/binary-grid.svg','What is 00110101 + 00001011 in binary?','01000000','00111110','01010000','00110000','Which calculation gives the binary result 11110000?','10100000 + 01010000','10000000 + 00100000','11100000 + 00100000','11000000 + 00110000'),
('1.1.6',null,'What is -5 as an 8-bit two''s-complement value?','11111011','10000101','11111010','00000101','What denary value is represented by 11110110 in 8-bit two''s complement?','-10','-118','10','246'),
('1.2.2',null,'A sound clip is recorded for 10 seconds at 8 000 samples per second and 8 bits per sample. What is its size?','640 000 bits','80 000 bits','64 000 bits','6 400 000 bits','Which change normally gives a digital recording a more accurate amplitude measurement?','Increase the sample resolution','Decrease the sample rate','Use fewer bits per sample','Shorten the recording'),
('1.2.3',null,'A 100 by 50 pixel image uses 8-bit colour. What is its uncompressed size?','40 000 bits','5 000 bits','400 000 bits','800 bits','What is the main effect of increasing colour depth?','More colours can be represented','The image has more pixels','The file always becomes lossless','The display becomes physically larger'),

-- Topic 2: Data transmission
('2.1.1c','/question-media/packet-routes.svg','Why can two packets from one message take different routes from S to R?','Routers select routes independently using current conditions','Every packet has a different destination','Packets cannot pass through the same router','The sender fixes one route for the entire internet','Why are sequence numbers included in packets?','To rebuild the message in the correct order','To encrypt the payload','To identify the transmission medium','To calculate the sender''s password'),
('2.1.2a',null,'A walkie-talkie allows either person to speak, but not both simultaneously. Which mode is used?','Half-duplex','Simplex','Full-duplex','Parallel simplex','Which method sends several bits simultaneously along separate wires?','Parallel transmission','Serial transmission','Simplex transmission','Packet switching'),
('2.2.2',null,'A byte contains five 1 bits. Which parity bit gives even parity?','1','0','5','8','Why might a parity check fail to detect an error?','An even number of bits may change','The receiver knows the parity rule','Only one bit changes','The parity bit is transmitted'),
('2.2.4','/question-media/packet-routes.svg','A sender receives no acknowledgement before its timer expires. What should ARQ do?','Retransmit the packet','Delete the whole file','Change to simplex mode','Remove the checksum','What does a positive acknowledgement tell the sender?','The expected data arrived successfully','The receiver has encrypted the data','The route contains no routers','The message needs compression'),
('2.3.2',null,'Which key should a sender use to encrypt a confidential message for Noor using asymmetric encryption?','Noor''s public key','Noor''s private key','The sender''s private key only','A published password','Why must Noor keep her private key secret?','It can decrypt data protected with her public key','It is required by everyone who sends to her','It contains the public website address','It prevents packets being divided'),

-- Topic 3: Hardware
('3.1.2a','/question-media/cpu-buses.svg','Which register holds the address of the memory location currently being accessed?','MAR','MDR','ACC','CIR','Which bus carries the actual instruction or data between memory and the CPU?','Data bus','Address bus','Control bus','Universal serial bus'),
('3.1.2b','/question-media/cpu-buses.svg','During fetch, which register supplies the address of the next instruction?','Program counter','Accumulator','Memory data register','Current instruction register','What happens immediately after an instruction is copied to the current instruction register?','The control unit decodes it','The hard disk formats it','The router transmits it','The accumulator deletes it'),
('3.1.3',null,'Why can a larger CPU cache improve performance?','Frequently needed data can be accessed faster','It permanently stores every user file','It increases monitor resolution','It replaces the instruction set','Why does doubling clock speed not always double real performance?','Other components and instruction workloads can limit performance','Clock speed controls only storage capacity','A faster clock disables multiple cores','Programs stop using RAM'),
('3.3.1',null,'Which memory loses its contents when power is removed?','RAM','ROM','Flash storage','Optical storage','Why is ROM suitable for bootstrap instructions?','It retains instructions without power','It can be rewritten every processor cycle','It is always larger than secondary storage','It stores only user documents'),
('3.4.4','/question-media/network-topology.svg','Which device forwards packets between the school network and the internet?','Router','Switch','Printer','Network interface card','What does the switch primarily use to forward a frame within the local network?','Destination MAC address','Website domain name','File extension','CPU clock speed'),

-- Topic 4: Software
('4.1.1',null,'Which item is system software?','A device driver','A presentation document','A photograph editor project','A spreadsheet workbook','Which application is most suitable for calculating a class average from rows of marks?','Spreadsheet software','Firmware','Assembler','Operating system kernel'),
('4.1.2',null,'Which operating-system function prevents two programs from using the same memory area incorrectly?','Memory management','Domain-name resolution','Lossy compression','Source-code translation','What is the purpose of a user interface supplied by an operating system?','To let users interact with the computer','To manufacture processor cores','To create network cables','To replace application software'),
('4.1.4',null,'A key is pressed while a program is running. What mechanism alerts the CPU?','An interrupt','A compiler pass','A checksum','A logic shift','Why does the CPU save its current state before servicing an interrupt?','So it can resume the interrupted task','So the program is permanently deleted','So RAM becomes non-volatile','So the clock speed increases'),
('4.2.3',null,'A program must be translated and run one statement at a time during development. Which translator is suitable?','Interpreter','Compiler','Assembler only','Device driver','What does a compiler usually report after analysing the complete source program?','A list of detected translation errors','The user''s browsing history','The computer''s MAC address','The binary value of every image'),
('4.2.5',null,'Which IDE feature allows execution to pause at a selected line?','Breakpoint','Pretty printing','Auto-save','File compression','What information does a debugger watch window provide?','Current values of selected variables','Available cloud-storage capacity','The keyboard scan code only','The public encryption key'),

-- Topic 5: The internet and its uses
('5.1.2',null,'In https://school.example.org/results, which part identifies the protocol?','https','school','example.org','results','Which part of a URL identifies a resource path on the server?','/results','https','org','school'),
('5.1.3',null,'What extra protection does HTTPS provide compared with HTTP?','Encrypted communication and server authentication','Automatic lossless image compression','A permanent IP address','Removal of all cookies','Why does a browser check a website''s digital certificate?','To help verify the server''s identity','To increase the CPU clock speed','To assign a MAC address','To create a blockchain'),
('5.1.5','/question-media/network-topology.svg','After a domain name is entered, what service finds the corresponding IP address?','DNS','HTML','USB','ASCII','What does the browser do after receiving HTML from the web server?','Interprets it and renders the page','Compiles it into a device driver','Stores it permanently in ROM','Uses it as an encryption key'),
('5.1.6',null,'Which cookie normally disappears when the browser session ends?','Session cookie','Persistent cookie','Tracking pixel','Digital certificate','Why might an online shop use a persistent cookie?','To remember preferences between visits','To replace the customer''s password','To route every internet packet','To increase image colour depth'),
('5.3.1',null,'An email asks a user to enter bank details on a convincing fake site. What is this attack?','Phishing','Brute-force compilation','Packet switching','Defragmentation','Which malware secretly records a user''s keyboard input?','Keylogger','Firewall','Proxy server','Hypertext'),

-- Topic 6: Automated and emerging technologies
('6.1.1','/question-media/automated-greenhouse.svg','What does the temperature sensor provide to the microprocessor?','Input data about the environment','A physical cooling action','A permanent program update','A public encryption key','What component changes the greenhouse environment when cooling is required?','Fan actuator','Temperature sensor','Knowledge base','Data bus'),
('6.1.2','/question-media/automated-greenhouse.svg','What is one advantage of automating greenhouse temperature control?','It can respond continuously without fatigue','It guarantees sensors never fail','It removes the need for electricity','It makes every crop identical','What is one risk of this automated system?','A faulty sensor may cause incorrect control actions','The processor cannot compare numbers','Actuators can never be replaced','Automation prevents data collection'),
('6.2.2',null,'Which combination best characterises a robot?','Programmable, sensing its environment and able to act','A static machine with no processor','Any spreadsheet containing a macro','A storage device connected by USB','Why is a washing machine described as an embedded system rather than necessarily a robot?','It performs a dedicated control task inside a larger product','It has no electronic components','It can only use cloud storage','It always works without input'),
('6.3.2',null,'An AI system changes its predictions after analysing new labelled examples. Which characteristic is shown?','Learning','Optical storage','Packet sequencing','Parity checking','An AI navigation system selects a new route after a road closes. Which characteristic is shown?','Adaptation','Character encoding','Compilation','File compression'),
('6.3.3',null,'Which expert-system component stores facts about a specialist domain?','Knowledge base','Actuator','Router table','Accumulator','What does an inference engine do?','Applies rules to known facts to reach conclusions','Collects physical data directly','Draws every user-interface screen','Encrypts all training data'),

-- Topic 7: Algorithm design and problem-solving
('7.1.2c','/question-media/flowchart-loop.svg','Which flowchart shape is used for the decision Number = 0?','Diamond','Rectangle','Parallelogram','Terminator oval','Which shape represents INPUT Number?','Parallelogram','Diamond','Rectangle','Circle connector only'),
('7.1.4',null,'A list contains 12, 7, 19, 4. After one left-to-right bubble-sort pass into ascending order, what is the list?','7, 12, 4, 19','4, 7, 12, 19','12, 7, 4, 19','19, 12, 7, 4','A linear search looks for 9 in [4, 6, 9, 12]. How many comparisons are made?','3','1','2','4'),
('7.1.5a',null,'A quantity must be from 1 to 20 inclusive. Which validation is most appropriate?','Range check','Presence check only','Check digit','Double-entry verification','A product code must contain exactly eight characters. Which validation is most appropriate?','Length check','Range check','Visual verification','Parity check'),
('7.1.6',null,'For an accepted range 10 to 50 inclusive, which value is abnormal test data?','51','10','25','50','Which pair tests the lower boundary and the nearest invalid value?','10 and 9','10 and 50','11 and 49','25 and 26'),
('7.1.7','/question-media/flowchart-loop.svg','The inputs to the flowchart are 4, 3, 0. What is output?','7','4','3','0','Why is the final zero included in Total without changing its value?','The addition occurs before the zero test','The test occurs before every input','Zero terminates before it is read','Total is reset after each input'),

-- Topic 8: Programming
('8.1.4b',null,'What is output when Score is 67? IF Score >= 70 THEN OUTPUT "A" ELSE OUTPUT "B" ENDIF','B','A','67','No output','Which CASE branch runs when Choice has value 3?','The branch labelled 3','Every branch','Only the OTHERWISE branch','The branch labelled 2'),
('8.1.4c',null,'How many times does FOR Index ← 1 TO 5 execute its body?','5','4','6','1','Which loop is guaranteed to execute its body at least once?','A post-condition REPEAT loop','A pre-condition WHILE loop','A zero-length FOR loop','No loop can do this'),
('8.1.6b',null,'A function Square receives 6 and returns Number * Number. What value is returned?','36','12','6','0','Why are parameters useful in a procedure?','They allow values to be supplied for each call','They make every variable global','They prevent the procedure being reused','They replace all return values'),
('8.2.1','/question-media/array-grid.svg','What value is stored at Seats[2,3]?','G','F','H','K','Which index pair accesses the value J?','[3,2]','[2,3]','[3,3]','[2,2]'),
('8.3.2',null,'Which operation should occur before a program reads records from a text file?','Open the file for reading','Delete the file','Close the file','Sort RAM','Why should a program close a file after writing?','To ensure buffered data is saved and resources are released','To erase the saved records','To convert it automatically to machine code','To make RAM permanent'),

-- Topic 9: Databases
('9.1.1',null,'In a STUDENT table, what does one row represent?','One student record','One field name','The entire database system','One data type','Which term describes a column such as DateOfBirth?','Field','Record','Query result only','Primary storage'),
('9.1.2',null,'Which data type is most suitable for a price such as 19.95?','Real','Boolean','Character','Date','Why should a telephone number usually be stored as text rather than integer?','It is not used in arithmetic and may start with zero','Text always uses fewer bits','Integers cannot contain digits','Telephone numbers are Boolean'),
('9.1.3',null,'Which field is the best primary key for a STUDENT table?','StudentID','FirstName','Age','ClassName','Why is DateOfBirth alone usually unsuitable as a primary key?','More than one student may share it','Dates cannot be stored in a database','It always changes every day','It contains no numeric values'),
('9.1.4',null,'Which query returns every BOOK record costing less than 20?','SELECT * FROM BOOK WHERE Price < 20','SELECT Price < 20 FROM BOOK','SELECT BOOK WHERE Price > 20','FROM BOOK SELECT ALL Price','Which clause sorts selected records by Surname from Z to A?','ORDER BY Surname DESC','WHERE Surname DESC','ORDER Surname ASC','GROUP BY Surname Z-A'),
('9.1.4',null,'What does SELECT COUNT(*) FROM MEMBER return?','The number of records in MEMBER','The total of every numeric field','The first MEMBER record','All field names','Which query displays only Name and Score from RESULT?','SELECT Name, Score FROM RESULT','SELECT * Name Score RESULT','FROM RESULT WHERE Name, Score','DISPLAY Name AND Score IN RESULT'),

-- Topic 10: Boolean logic
('10.1.1','/question-media/logic-circuit.svg','Which gate in the lower branch has one input and a small inversion circle?','NOT','AND','OR','XOR','Which gate combines A and B in the upper branch?','AND','NOR','NOT','XOR'),
('10.1.2',null,'What is the output of NAND when both inputs are 1?','0','1','2','Undefined','What is the output of NOR when both inputs are 0?','1','0','2','Undefined'),
('10.1.2',null,'Which gate outputs 1 only when its two inputs are different?','XOR','AND','NOR','NOT','Which gate outputs the inverse of its single input?','NOT','OR','NAND with no inputs','XOR'),
('10.1.3b','/question-media/logic-circuit.svg','For the shown circuit, what is Q when A=1, B=1 and C=1?','1','0','C','Undefined','For the shown circuit, what is Q when A=0, B=1 and C=1?','0','1','B','Undefined'),
('10.1.3c','/question-media/logic-circuit.svg','Which expression represents the shown circuit?','Q = (A AND B) OR NOT C','Q = A AND (B OR C)','Q = NOT (A OR B) AND C','Q = A XOR B XOR C','Which expression is 1 only when A is 1 and B is 0?','A AND NOT B','A OR B','NOT A AND B','A XOR NOT B')
), expanded as (
  select objective_code, visual_url, item_no, stem, correct, wrong1, wrong2, wrong3
  from seed
  cross join lateral (values
    (1, q1, c1, w11, w12, w13),
    (2, q2, c2, w21, w22, w23)
  ) q(item_no, stem, correct, wrong1, wrong2, wrong3)
), prepared as (
  select e.*, o.id as objective_id, st.topic_id,
    case when e.item_no = 1 then
      jsonb_build_array(e.correct,e.wrong1,e.wrong2,e.wrong3)
    else
      jsonb_build_array(e.wrong1,e.correct,e.wrong2,e.wrong3)
    end as answer_options,
    case when e.item_no = 1 then 0 else 1 end as answer_index
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
  else
    jsonb_build_array(
      jsonb_build_object('type','image','url',visual_url,'alt','Original technical diagram supplied for this question'),
      jsonb_build_object('type','paragraph','text',stem)
    )
  end,
  answer_options, to_jsonb(answer_index),
  jsonb_build_array(jsonb_build_object('mark',1,'point',correct)),
  '[Original bank 2026 v2] ' || correct,
  'published'
from prepared;

do $$
declare
  bank_count integer;
  distinct_stems integer;
  visual_count integer;
begin
  select count(*), count(distinct stem_blocks::text),
    count(*) filter (where stem_blocks @> '[{"type":"image"}]'::jsonb)
  into bank_count, distinct_stems, visual_count
  from public.questions
  where explanation like '[Original bank 2026 v2]%';

  if bank_count <> 100 or distinct_stems <> 100 then
    raise exception 'Expected 100 distinct v2 questions, found % rows and % stems', bank_count, distinct_stems;
  end if;
  if visual_count < 10 then
    raise exception 'Expected at least 10 visual questions, found %', visual_count;
  end if;
end
$$;

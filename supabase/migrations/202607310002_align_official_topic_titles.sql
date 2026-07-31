update public.topics t
set name = x.name
from public.subjects s
join (values
  ('1','Data representation'),
  ('2','Data transmission'),
  ('3','Hardware'),
  ('4','Software'),
  ('5','The internet and its uses'),
  ('6','Automated and emerging technologies'),
  ('7','Algorithm design and problem-solving'),
  ('8','Programming'),
  ('9','Databases'),
  ('10','Boolean logic')
) x(topic_number, name) on true
where t.subject_id = s.id
  and s.code = '2210'
  and t.topic_number = x.topic_number;

update faculty set fname = 'Kevin' where fid = 4756; -- updating
select * from dm_schema.faculty; -- select statement

select sid, sname
from student where sid < 50000;

select cid, cname
from course where cname = 'syst design'; -- select statement with conditions using where clause

select fid, fname
from faculty where fid > 3000 or 5000;

select fid, cid, date_qualified, year(date_qualified), extract(day from date_qualified) -- extract function and year function
from qualification;

select *
from performance;

select * from qualification
where cid like 'ISM 4_1_%'; -- the underscore and percentage sign are for string matching

select *
from course where cname like '%data%'; -- nothing in sql is case sensitive

select *
from faculty where fname like '%a%';

select *
from qualification where cid in ('ISM 3112', 'ISM 3113') and month(date_qualified) = 9; -- use in to select rows that involve the values specified
-- when you want to do pattern matching using wild card use like

select avg(mark), min(mark), max(mark), sum(mark), count(*), sum(mark)/count(*) -- important math functions
from performance;
-- count(*) counts all the values, count(a) count all non- null values, count(distinct a) counts all the distinct non- null values

select avg(mark) as avg_mark -- can use as to rename columns
from performance;

select count(distinct sid), count(*), count(sid)
from registration where cid = 'ism 4212' and semester = 'i-2001';

select count(distinct sid) -- in order to count the different number of students
from registration where semester = 'i-2001';

select fid as fid, count(distinct cid) as CoursesCanTeach
from qualification
group by fid;

select sid, semester, count(distinct cid) as CoursesTaken
from registration
group by sid, semester;

select type, count(*) as TotalCount
from room
group by type;

select type, min(capacity), max(capacity)
from room
group by type;
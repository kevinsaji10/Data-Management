 
 -- Question 3
insert into student values (65798, 'Lopez');

delete from student where (sid = 65798 and sname = 'Lopez');

update faculty set fname = 'Collin' where fid = 4756;

select aname
from assessment
where weight > 0.3;

select sid, sname
from student
where sid < 50000;

select fname
from faculty
where fid = 4756;

select fid, cid, date_qualified
from qualification
where extract(year from date_qualified) >= 1993;

select fname
from faculty
where fname like '%a%';

select cid, cname
from course
where cid like "ISM%";

select min(mark)
from performance
where sid = 54907;

select count(sid)
from registration
where (cid = 'ism 4212' and semester = 'i-2001');

select count(distinct sid)
from registration
where (semester = 'i-2001');

select fid, cid, date_qualified
from qualification
where cid = (('ism 3112' or cid = 'ism 3113')and month(date_qualified) = 11)
group by fid, cid, date_qualified;

select distinct cid
from registration
where semester = "i-2001";

select sid, sname
from student
group by sname, sid;

select sid, max(mark)
from performance
group by sid;

select type, count(distinct rid)
from room
group by type;

select cid, count(distinct fid)
from qualification
group by cid;

select sid, count(distinct cid)
from registration
group by sid;

select p.aid, avg(mark), min(mark), max(mark)
from performance as p, assessment
where cid = 'ism 4212'
group by p.aid;

select cid, p.aid, max(mark), min(mark), avg(mark)
from performance as p
group by cid, p.aid;

select cid, p.aid, max(mark), min(mark), avg(mark)
from performance as p
where(cid != 'ism 4212')
group by cid, p.aid;

select cid, count(fid)
from qualification
group by cid
having (count(fid) >=2);












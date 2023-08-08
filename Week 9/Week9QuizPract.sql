select sid, sname
from student
where sid < 50000;

alter table student add spouse varchar(15) not null;

alter table student drop spouse;

select fid, cid, date_qualified
from qualification
where extract(year from date_qualified) > 1993; 

select fname
from faculty
where fname like '%a%';

select fid, date_qualified
from qualification
where (cid = 'ism 3112' or cid = 'ism 3113') and month(date_qualified) = 9;

select count(sid)
from registration
where cid = 'ism 4212' and semester = 'i-2001';

select count(distinct sid)
from registration 
where semester = 'i-2001';

select type, count(type)
from room
group by type;

select type, count(type)
from room
group by type
having count(type) >=2;

select type, min(capacity), max(capacity)
from room
group by type;

select s.sid, sname, r.cid
from registration as r inner join student as s
on s.sid = r.sid and semester = 'i-2001';

select f.fid, fname
from qualification as q inner join faculty as f
on q.fid = f.fid and year(date_qualified) = 1995;

select distinct f.fid, fname
from qualification as q, faculty as f
where f.fid = q.fid
order by fname asc;

select f.fid, fname, q.cid
from faculty as f left outer join qualification as q
on f.fid = q.fid;

select f.fid, fname, cname
from faculty as f left outer join qualification as q
on f.fid = q.fid left outer join course as c
on c.cid = q.cid;

select f.fid, fname,count(q.cid)
from faculty as f left outer join qualification as q
on f.fid = q.fid
group by f.fid, f.fname;

select s.sid, sname, count(r.cid)
from student as s left outer join registration as r
on s.sid = r.sid and semester = 'i-2002'
group by s.sid, sname;

select c.cid, cname, count(r.sid) as StudentCount
from course as c left outer join registration as r
on c.cid = r.cid and semester = 'i-2002'
group by c.cid, cname;

select sid
from registration as r inner join course as c
on r.cid = c.cid and (c.cname = 'database' or c.cname = 'networking')
group by sid
having count(c.cid) = 2;

select f.fid
from faculty as f inner join qualification as q
on f.fid = q.fid inner join course as c on q.cid = c.cid and (cname = 'syst analysis' or cname = 'syst design')
group by f.fid
having count(c.cid) = 1;

select q1.fid as fid1,q2.fid as fid2, c1.cname
from (qualification as q1
inner join course as c1 on q1.cid = c1.cid)
inner join (qualification as q2 inner join course as c2
on q2.cid = c2.cid)
on c1.cid = c2.cid
group by fid1, fid2, cname
having fid1 < fid2;

select r1.rid as RID1, r2.rid as RID2, r1.type, r1.capacity
from room as r1 inner join room as r2
on r1.capacity = r2.capacity and r1.type = r2.type
and r1.rid <r2.rid;









select sid, sname, cid
from student, course;

select q.fid, fname, date_qualified
from faculty as f, qualification as q
where year(date_qualified) = 1995;

select q.cid, cname
from qualification as q inner join course as c
on q.cid = c.cid inner join faculty as f on q.fid = f.fid
where fname = 'ama'
order by cid desc;

select q.fid, fname
from qualification as q inner join faculty as f
on q.fid = f.fid
group by q.fid, fname
order by fname asc;

select r.sid, sname
from registration as r inner join course as c
on r.cid = c.cid inner join student as s on s.sid = r.sid
where (semester = 'i-2001' and cname = 'syst analysis');

select r.cid, sname, cname
from registration as r inner join course as c
on r.cid = c.cid inner join student as s 
on s.sid = r.sid
where sname like 'a%';

select distinct s.sid, sname
from qualification as q inner join registration as r
on q.cid = r.cid inner join student as s
on r.sid = s.sid inner join faculty as f 
on f.fid = q.fid
where (fname = "Berry");

select f.fid, fname, q.cid
from faculty as f left outer join qualification as q
on f.fid = q.fid;

select f.fid, fname, c.cname
from faculty as f left outer join qualification as q
on f.fid = q.fid
left outer join course as c on q.cid = c.cid;

select f.fid, fname, count(distinct c.cid)
from faculty as f left outer join qualification as q
on f.fid = q.fid
left outer join course as c on q.cid = c.cid
group by fid, fname;

select s.sid, sname, count(distinct r.cid)
from student as s left outer join registration as r
on s.sid = r.sid and semester = 'i-2002'
group by s.sid;

select c.cid, c.cname, count(r.sid)
from course as c left outer join registration as r
on c.cid = r.cid and semester = 'i-2002'
group by c.cid, c.cname;

select sid, fid, fname
from student as s, faculty as f
where s.sname = f.fname;

select sid, sname, fid, fname
from student as s, faculty as f
where s.sname <> f.fname;

select cid, sid, sum(weight * mark) as finalMark
from performance as p left outer join assessment as a
on p.aid = a.aid
group by cid, sid;

select sid from  registration r, course c
where c.cid = r.cid
and cname in ('Database', 'Networking')
group by sid 
having count(distinct c.cid) = 2;

select fid from course c, qualification q
where c.cid = q.cid
and cname in ('Syst Analysis', 'Syst Design')
group by fid
having count(distinct cname) = 1;

select distinct q.fid, q1.fid, cname
from qualification as q inner join qualification as q1
on q.cid = q1.cid and q.fid <q1.fid inner join course as c
on q.cid = c.cid;

select distinct r.rid, r1.rid, r.type, r.capacity
from room as r inner join room as r1
on r.type = r1.type and r.capacity = r1.capacity and r.rid <r1.rid;

select s.sname, s1.sname, cname, r.semester
from (registration as r inner join student as s
on r.sid = s.sid) inner join (registration as r1 inner join
student as s1 on r1.sid = s1.sid) on r.sid < r1.sid and r.cid = r1.cid and r.semester = r1.semester
inner join course as c on c.cid = r.cid;









































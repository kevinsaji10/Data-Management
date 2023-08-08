-- non subquery version
select sname
from student as s, registration as r
where s.sid = r.sid and cid = 'ism 3113' and semester = 'i-2001';

-- subquery version
select sname
from student
where sid in (select sid -- no need alias to disambiguate in the inner query
from registration where cid = 'ism 3113' and semester = 'i-2001');

-- non subquery version
select f.fid, f.fname
from faculty f inner join qualification q
on f.fid = q.fid
group by f.fid, f.fname
having count(cid) >=2;

-- subquery version
select fid, fname
from faculty
where fid in (select fid
from qualification
group by fid
having count(cid) >= 2);

-- subquery version
select fid, fname
from faculty
where fid in (select fid
from qualification
group by fid
having count(cid) >= 2)
or fid in (select fid from qualification where year(date_qualified) > 1990);

select f.fid, fname
from qualification q, faculty f
where q.fid = f.fid
group by f.fid, fname
having count(cid) >=1
or f.fid in (select f.fid
from qualification q, faculty f
where q.fid = f.fid and year (Date_qualified) = 1990);

-- subquery version
select sid, sname
from student
where sid in (select sid
from registration r, course c
where r.cid = c.cid and cname = 'Database')
and sid in (select sid
from registration r, course c
where r.cid = c.cid and cname = 'Networking');

select fid
from faculty
where fid in (select fid
from qualification q, course c
where q.cid = c.cid and cname in ('syst analysis', 'syst design'));

select sid, sname
from student where sid in (select sid
from registration r, course c
where r.cid = c.cid and cname in ('syst analysis'))
xor sid in (select sid
from registration r, course c
where r.cid = c.cid and cname in ('syst design'));

select sid, sname
from student 
where sid in (select sid
from registration r, course c
where r.cid = c.cid and cname in ('database'))
and sid not in (select sid
from registration r, course c
where r.cid = c.cid and cname <> 'database');

select fid, fname
from faculty
where fid in (select fid
from qualification q, course c
where q.cid = c.cid and cname in ('syst design'))
and fid not in (select fid
from qualification q, course c
where q.cid = c.cid and cname <> 'syst design');

select sid
from registration r
group by sid
having count(*) = (select count(*)
from course);

select f.fid, count(*)
from qualification q, faculty f where f.fid = q.fid and fname <> 'berry'
group by fid
having count(*) = (select count(*)
from faculty f, qualification q
where f.fid = q.fid and fname = 'berry');
















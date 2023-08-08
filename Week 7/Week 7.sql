
select s.sid, s.sname, r.cid -- remember the code is not top down like other languages
from student s inner join registration r -- when you are using the inner join must have on
on s.sid = r.sid and r.semester = 'I-2001';

select f.fid, f.fname
from faculty f inner join qualification q
on f.fid = q.fid and extract(year from date_qualified) = '1995';

select c.cname, c.cid
from qualification q inner join course c on q.cid = c.cid
	inner join faculty f on q.fid = f.fid
where fname = 'ama'
order by c.cid desc;

select distinct f.fid, f.fname -- can select distinct to remove duplicates
from qualification q, faculty f
where f.fid = q.fid
-- can use group by f.fid, f.fname here instead of using the distinct keyword in possible
order by f.fname asc;

select q.fid
from qualification q inner join course c
on q.cid = c.cid and cname = 'syst analysis' or cname = 'syst design'
group by q.fid
having count(c.cid) = 1;

select q1.fid as fid1, q2.fid as fid2, c.cname
from qualification q1 inner join qualification q2 inner join course as c
on q1.cid = c.cid and q2.cid = c.cid and q1.fid < q2.fid;

select sname
from student
where sid in (select sid
from registration
where cid = 'ism 3113' and semester = 'i-2001');

select fid, fname
from faculty
where fid in (select fid
from qualification 
group by fid
having count(cid) >= 2);



select fid, fname
from faculty
where fid in (select fid
from qualification 
group by fid
having count(cid) >= 2) or fid in (select fid
from qualification
where year(date_qualified) >1990);

select sid, sname
from student
where sid in (
select sid
from course c, registration r
where r.cid = c.cid and cname = 'Networking'
) and sid in (select sid
from course c, registration r
where r.cid = c.cid and cname = 'Database'
);

select sid, sname
from student
where sid in (
select sid
from course c, registration r
where r.cid = c.cid and cname = 'Syst Analysis'
) or sid in (select sid
from course c, registration r
where r.cid = c.cid and cname = 'Syst Design'
);

select sid, sname
from student
where sid in (
select sid
from course c, registration r
where r.cid = c.cid and cname = 'Syst Analysis'
) xor sid in (select sid
from course c, registration r
where r.cid = c.cid and cname = 'Syst Design'
);


select sid, sname
from student
where sid in (select sid
from registration
where sid in (select r.sid
from registration r, course c
where r.cid = c.cid and cname = 'Database')
group by sid
having count(distinct cid) = 1); -- check ans for better solution (can 'and' 2 subqueries that check for database, and the other checks for 1 course only

select fid, fname
from faculty
where fid in (select fid
from qualification q
group by fid
having count(distinct cid) = 1) and fid in 
(select fid
from qualification q, course c
where cname = 'Syst Design');

select cid, cname
from course
where cid in (select cid
from registration r, student s
where r.sid = s.sid and sname = 'Bob')and cid not in 
(select cid
from registration r, student s
where r.sid = s.sid and sname <> 'Bob');


select fid, fname
from faculty
where fid in (select fid
from qualification q, course c
where q.cid = c.cid and cname in ('syst design', 'syst analysis')
group by fid
having count(distinct q.cid) = 2) and fid not in 
(select fid
from qualification q, course c
where q.cid = c.cid and cname not in ('syst analysis','syst design'));

select sname, r.sid
from registration r, student s
where r.sid = s.sid
group by r.sid
having count(r.sid) = 
(select count(cid)
from course);


select rid, capacity
from room
where capacity >=
(select max(enrollment) from
(select cid, count(distinct sid) as enrollment
from registration
where semester = 'i-2001'
group by cid)as temp);


select fname, fid
from faculty
where fid in (select fid
from qualification q1, (select cid
from qualification q, faculty f
where q.fid = f.fid and fname = 'Berry') as temp
where q1.cid = temp.cid) and fname <>'berry';

-- why does this code not work properly
select rid, capacity
from room
where capacity >=
(select max(enrollment) from
(select count(distinct sid) as enrollment
from registration r1, (select cid
from registration r, student s
where r.sid = s.sid and sname = 'bob' and semester = 'i-2001') as bobcourses
where bobcourses.cid = r1.cid) as numstudents);

select allenrollment.cid
from 
(select r.cid, count(r.sid) as enrollmentcount
from registration r, course c
where r.cid = c.cid and semester = 'i-2001'
group by r.cid) as allenrollment inner join (select r.cid, count(r.sid) as networkingcount
from registration r, course c
where r.cid = c.cid and semester = 'i-2001' and cname = 'networking'
group by r.cid) as networkingenrollment
on allenrollment.enrollmentcount > networkingenrollment.networkingcount
group by allenrollment.cid;

select cname
from registration r, course c
where r.cid = c.cid and semester = 'i-2001'
group by cname
having count(sid) = (
select max(enrollment)
from (
select c.cname, count(sid) as enrollment
from registration r, course c
where r.cid = c.cid and semester = 'i-2001'
group by c.cname
) as temp);

select course, max(final_mark)
from
(select r.cid as course,r.sid, sum(weight * mark) as final_mark
from performance p, assessment a, registration r
where p.aid = a.aid and p.sid = r.sid and p.cid = r.cid and semester = 'i-2001'
group by r.cid, r.sid) as temp
group by course;

select student, max(final_mark)
from
(select student as student,course, final_mark
from
(select r.cid as course,r.sid as student, sum(weight * mark) as final_mark
from performance p, assessment a, registration r
where p.aid = a.aid and p.sid = r.sid and p.cid = r.cid and semester = 'i-2001'
group by r.cid, r.sid) as temp
group by student, course) as temp1
group by student;

select fname, count(distinct cid) as coursescanteach
from qualification q, faculty f
where q.fid = f.fid
group by fname
having coursescanteach = 
(select max(cidcount)
from
(select fname as faqname, count(distinct cid) as cidcount
from qualification q, faculty f
where q.fid = f.fid
group by fname) as temp);

select r.sid, sname
from registration r, student s
where r.sid = s.sid
group by r.sid, sname
having count(distinct cid) = 
(select max(coursescount)
from
(select sname as studentname, count(distinct cid) as coursescount
from registration r, student s
where r.sid = r.sid
group by sname) as temp);


select q.fid, fname
from qualification q, faculty f
where q.fid = f.fid
group by q.fid, fname
having count(distinct cid) = 
(select min(cidcount)
from
(select fname as faqname, count(distinct cid) as cidcount
from qualification q, faculty f
where q.fid = f.fid
group by fname) as temp);

select c.cid, cname, davesem
from course c left outer join (select semester as davesem, cid
from registration r, student s
where s.sid = r.sid and sname = 'Dave') as temp
on temp.cid = c.cid;

select r1.cid, r2.cid, r1.semester, r1.studentno
from
(select cid, count(sid) as studentno, semester
from registration
group by cid,semester) as r1 inner join (select cid, count(sid) as studentno, semester
from registration
group by cid,semester) as r2 
on r1.semester = r2.semester and r1.studentno = r2.studentno and r1.cid < r2.cid;

# difficult question (part x of EE6)

select t1.sid1, t1.sid2, t1.semester from 
#gets the number of common courses shared by pair of students
(select r1.sid as sid1, r2.sid as sid2, r1.semester, count(distinct r1.cid) as num1 from registration r1, registration r2
where r1.sid < r2.sid and r1.cid = r2.cid and r1.semester=r2.semester
group by r1.sid, r2.sid, semester) as t1, 
#gets the number of courses  student sid1 takes
(select sid, semester, count(cid) as num2 from registration group by sid, semester) as t2,
#gets the number of courses  student sid2 takes
(select sid, semester, count(cid) as num2 from registration group by sid, semester) as t3
where t1.sid1 = t2.sid and t1.num1=t2.num2 and t1.semester=t2.semester and 
t1.sid2=t3.sid and t1.num1=t3.num2 and t1.semester=t3.semester;


































use VMS;
-- EE6 Re Attempt
#n
select rid, capacity
from room
having capacity >= (select max(studentcount)
from (select coursename, count(sid) as studentcount
from registration r, (select cid as coursename
from registration r inner join student s
on r.sid = s.sid and s.sname = 'bob' and r.semester = 'i-2001'
group by coursename) as temp
where temp.coursename = r.cid and r.semester = 'i-2001'
group by temp.coursename) as temp2);

#p
select r.cid
from registration r
where r.semester = 'i-2001'
group by r.cid
having count(r.sid) > (select count(r.sid) as NetworkingCount
from registration r, course c
where r.cid = c.cid and c.cname = "Networking" and r.semester = 'i-2001');


#q
select cid, max(finalmark)
from (select r.sid,r.cid, sum(weight * mark) as finalmark
from performance p, assessment a, registration r
where p.aid = a.aid and p.sid = r.sid and r.cid = p.cid and r.semester = 'i-2001'
group by sid, cid) as temp
group by cid;

#Find all pairs of students who have registered for the same course in the same semester. The
#output is in (SNAME1, SNAME2, CNAME, SEMESTER) format without any duplication.
use dm_schema;

select r1.sid, r2.sid, c.cname, r1.semester
from registration r1, registration r2, course c
where r1.sid > r2.sid and r1.semester = r2.semester and r1.cid = r2.cid and c.cid = r1.cid;

-- VMS Database Practice
#Retrieve all user information from the "user" table.

select *
from user;

# Find all users who are registered for a specific activity (given an activity name and date).

DELIMITER $$ 
CREATE PROCEDURE user_selector (IN ActivityName varchar (100), IN Date date) 
BEGIN

select u.name
from register r, user u
where r.acctname = u.acctname and
r.name = activityname and r.date = Date;

END $$ 

DELIMITER ;

call user_selector("Animal Run", cast("2021-04-10" as date));

# select name from vo table
select name
from vo;

# Find all activities organized by a specific VO (given the VO's ID).
DELIMITER $$ 
CREATE PROCEDURE activities (IN id int) 
BEGIN

select name
from a_organize
where void = id;

END $$ 

DELIMITER ;

call activities(118);
drop procedure activities;

#List all the Registered Users (RU) along with their highest education qualification.

select u.name, r.highestedqual
from ru r,user u
where r.acctname = u.acctname;

# Display the names of all courses and their descriptions.
select name, description
from course;

# Retrieve all activities that fall under a specific category (given the category name)
delimiter $$
create procedure cat_activities(IN catname varchar (30))

begin
select name
from act_category
where category = catname;

end$$

delimiter ;

call cat_activities("Animals");

#List all the award types and the number of awards for each type.
select type, count(name)
from award
group by type;

#Find the total number of hours a specific Registered User (given AcctName) has spent on registered activities.

delimiter $$

create procedure ru_hours(In acct varchar (30), out totalHrs int)

begin
set totalhrs = (select sum(numHrs)
from register r
where r.acctname = acct and completed = 1
group by acctname);
end $$

delimiter ;

call ru_hours("amy.garcia.871", @inthrs);
select @inthrs;
drop procedure ru_hours;

# Retrieve the names and dates of all activities that a specific user (given AcctName) has completed.

delimiter $$

create procedure user_comp(In acct varchar (30))

begin
select distinct(name), date
from register r
where r.acctname = acct and completed = 1;
end $$

delimiter ;

call user_comp("amy.garcia.871");
drop procedure user_comp;

# List all the courses that are endorsed by a specific VOA (given the VOA's AcctName).

delimiter $$

create procedure vo_endorse(In voaname varchar (40))

begin
select c.name
from endorsement e, course c
where e.id = c.id and e.endorser = voaname;
end $$

delimiter ;

call vo_endorse("tim.johnson.858");
drop procedure vo_endorse;

# find the total number of users who have volunteered for more than the average number of hours

select count(acct)
from (select acctname as acct,sum(numhrs) as hours
from register
where completed = 1
group by acctname) as temp1
where temp1.hours >= (select avg(hours)
from (select sum(numhrs) as hours
from register
where completed = 1
group by acctname)as temp);


# List the activities that have the highest number of registered volunteers.

select *
from (select name, date, count(acctname) as number
from register a
group by name, date) as temp
where temp.number = (select max(number) as target
from (select name, count(acctname) as number
from register a
group by name) as temp);

# Find the top 3 VOs (Volunteer Organizations) with the highest average hours per activity.
select v, avg(totalhr)
from (select void as v, name as n, date as d, sum(numhrs) as totalhr
from register
where completed = 1
group by void, name) as temp
group by v
order by avg(totalhr) desc
limit 3;

select *
from register;

select void as v, name as n, date as d, sum(numhrs) as totalhr
from register
where completed = 1
group by void, name, date;



#List all users who have completed at least one activity in every category.
select name, count(cat)
from (select distinct(acctname) as name, category as cat
from act_category a, register r
where a.name = r.name and r.completed = 1) as temp
group by name
having count(cat) = (select count(distinct category)
from act_category);

SELECT v.VOID, v.Name, AVG(ActivityHours.TotalHours) as AvgHours
FROM vo v
JOIN a_organize ao ON v.VOID = ao.VOID
JOIN (
    SELECT r.Name, r.Date, SUM(r.NumHrs) as TotalHours
    FROM register r
    GROUP BY r.Name, r.Date
) as ActivityHours ON ao.Name = ActivityHours.Name AND ao.Date = ActivityHours.Date
GROUP BY v.VOID, v.Name
ORDER BY AvgHours DESC
LIMIT 3;


SELECT ru.AcctName
FROM ru
WHERE NOT EXISTS (
    SELECT ac.Category
    FROM act_category ac
    WHERE NOT EXISTS (
        SELECT r.Name, r.Date
        FROM register r
        WHERE r.AcctName = ru.AcctName AND r.Name = ac.Name AND r.Date = ac.Date AND r.Completed = 1
    )
);








 










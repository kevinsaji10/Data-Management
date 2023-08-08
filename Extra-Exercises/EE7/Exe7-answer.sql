ALTER TABLE REGISTRATION ADD final_mark decimal(5,2);
Insert into course values ('ISM 5555', 'Course 5');
Insert into course values ('ISM 6666', 'Course 6');


# a.	Write a stored procedure sp_get_SCfinalmarks( IN studsid int, IN regcid char(8), 
#       OUT finalmarks decimal(5,2) ) to obtain the final mark for a given student sid and a 
#       given course cid that he has registered. Eg: Final Mark for SID 38214 of 
#       CID ISM 4212 is 74.80 (64*0.3 + 79*0.4 + 80*0.3).

#DROP PROCEDURE if exists sp_get_SCfinalmarks;


CREATE PROCEDURE sp_get_SCfinalmarks( IN studsid int, IN regcid char(8), OUT finalmarks decimal(5,2) ) 
	select sum(mark * weight) into finalmarks from performance p, assessment a 
    where p.aid = a.aid and sid = studsid and cid = regcid; 

CALL sp_get_SCfinalmarks(38214, 'ISM 4212', @final); 
SELECT @final; 


#-------------------------------------------------------------------------------------------------------
# b.	Write a stored procedure sp_populate_finalmarks() to populate the final mark column 
#       for all records in table REGISTRATION using stored procedure sp_get_SCfinalmarks.
#		(Hint: Use clause limit offset) 

#DROP PROCEDURE if exists sp_populate_finalmarks;


delimiter $$
CREATE PROCEDURE sp_populate_finalmarks()
BEGIN

	declare totalcount int;
    declare counter int;
    declare tmpsid int;
    declare tmpcid char(8);
    declare tmpmarks decimal(5,2);
    set counter = 0;
    select count(*) into totalcount from registration;
    
    while (counter < totalcount) do
		-- note order by is used to fix the order of the retrieved records		
        -- offset clause is to specify from which row to start retrieving 
        -- limit 1 is used to limit selection of 1 record
		select sid, cid into tmpsid, tmpcid from registration order by sid, cid limit 1 offset counter;
        
        call sp_get_SCfinalmarks(tmpsid, tmpcid, tmpmarks);        
        UPDATE REGISTRATION SET final_mark = tmpmarks where sid = tmpsid and cid = tmpcid;
        set counter= counter + 1;
    end while;
END$$
delimiter ;

call sp_populate_finalmarks();
#select * from registration;  #to verify if final marks are updated for all records


#-------------------------------------------------------------------------------------------------------
# c.	Write a trigger 'after_performance_update' that executes after there is an update of marks on performance table. 
#       When the marks of a student for a course is updated in performance table, 
#       the final_mark should be updated for the corresponding student in REGISTRATION table. 
#       Use stored procedure sp_get_SCfinalmarks in your trigger.

delimiter $$
create trigger after_performance_update after update on performance for each row
begin
	declare tmpmarks decimal(5,2);
	if old.mark <> new.mark then  -- this is to update only if there is change in marks
		call sp_get_SCfinalmarks(new.sid, new.cid, tmpmarks);
		UPDATE REGISTRATION SET final_mark = tmpmarks where sid=new.sid and cid=new.cid;
	end if;
end$$
delimiter ;


select * from registration where sid=54907 and cid='ISM 3113';  #final_mark is 93 before update
update performance set mark=91 where sid=54907 and cid='ISM 3113' and aid=1; #mark is changed from 88 to 91
select * from performance where sid=54907 and cid='ISM 3113'; #marks are changed to 91, 93, 98 from 88, 93, 98
select * from registration where sid=54907 and cid='ISM 3113';  #final_mark is changed from 93 to 93.90



#-------------------------------------------------------------------------------------------------------
# d.	Write a trigger that executes after a record is deleted from performance table. 
#       Update the REGISTRATION table’s finalmark for the student and the course. 
#       Use sp_get_SCfinalmarks in your trigger.

delimiter $$
create trigger after_performance_delete after delete on performance for each row
begin
	declare tmpmarks decimal(5,2);
    call sp_get_SCfinalmarks(old.sid, old.cid, tmpmarks);
    UPDATE REGISTRATION SET final_mark = tmpmarks where sid=old.sid and cid=old.cid;
end$$
delimiter ;



# Note: final_marks computed based on the updated marks of 91 for aid = 1, sid=54907 and cid='ISM 3113' instead of the original mark of 93
delete from performance where sid=54907 and cid='ISM 3113' and aid=2;
select * from performance where sid=54907 and cid='ISM 3113';   #used to verify that there are only 2 records of marks for 54907, ISM 3113 
select * from registration where sid=54907 and cid='ISM 3113';  #used to verify that the final mark is changed (to 56.7) for the available aid(s)  


delete from performance where sid=54907 and cid='ISM 3113' and aid=3;
select * from performance where sid=54907 and cid='ISM 3113';   #used to verify that there is only 1 record of marks for 54907, ISM 3113 
select * from registration where sid=54907 and cid='ISM 3113';  #used to verify that the final mark is changed (to 27.3) for the available aid(s)  




#-------------------------------------------------------------------------------------------------------
# e.	Write a trigger that executes after a new record is inserted into performance table. 
#       Update the REGISTRATION table’s finalmark for the student and the course for the 
#       new assessment marks. Use sp_get_SCfinalmarks in your trigger.

delimiter $$
create trigger after_performance_insert after insert on performance for each row
begin
	declare tmpmarks decimal(5,2);
    call sp_get_SCfinalmarks(new.sid, new.cid, tmpmarks);
    UPDATE REGISTRATION SET final_mark = tmpmarks where sid=new.sid and cid=new.cid;
end$$
delimiter ;

insert into performance(mark, sid, cid, aid) values (88, 54907,'ISM 3113',2);
select * from performance where sid=54907 and cid='ISM 3113';  #have 2 "mark records" of the course
select * from registration where sid=54907 and cid='ISM 3113';


insert into performance(mark, sid, cid, aid) values (98, 54907,'ISM 3113',3);
select * from performance where sid=54907 and cid='ISM 3113';  #have 3 "mark records" of the course constituting for 100%
select * from registration where sid=54907 and cid='ISM 3113';

/*
Note that the triggers after_performance_update, after_performance_delete, after_performance_insert are all
related to one another. And make use of the Stored Proecdure sp_get_SCfinalmarks to update the final mark in REGISTRATION 
*/



#-------------------------------------------------------------------------------------------------------
# f.	Write a trigger that executes before a record is inserted into registration table. 
#       Stop the insertion of the registration record if the student has already registered  
#       for more than 5 courses for the semester.
# 

delimiter $$
CREATE TRIGGER before_registration_insert BEFORE INSERT ON registration FOR EACH ROW
   BEGIN   	
		declare course_count int;
		select count(*) into course_count from registration
        where sid = new.sid and semester=new.semester;                
        if course_count >= 5 then 
		      signal sqlstate '45000' set message_text = 
              'Trigger Error: Insertion fail, student has already 
              registered for 5 courses in the semester';
	    end if;
   END$$
delimiter ;

select * from registration where sid = 54907;  #checks how many courses has this student registered in
insert into registration(sid, cid, semester) values (54907, 'ISM 5555', 'I-2001');
insert into registration(sid, cid, semester)  values (54907, 'ISM 6666', 'I-2001');  #this fails and record is not inserted


#-------------------------------------------------------------------------------------------------------
# g.	Write a stored procedure that takes in an integer say n. The stored procedure should list 
#       all the faculty whose qualification is more than n years old. The stored procedure is 
#       expected to list the FID, FName, CID, number of years since the "qualification certificate" 
#       was obtained (ignoring the actual month the qualification was obtained in)

CREATE PROCEDURE sp_get_faculty_for_training(IN n int)
	SELECT q.fid, fname , q.cid,  year(curdate()) - year(date_qualified) as "Years Since Qualified"
	FROM qualification q , faculty f 
	WHERE f.fid = q.fid and (year(curdate()) - year(date_qualified)) > n
    ORDER BY (year(curdate()) - year(date_qualified)) desc;

CALL sp_get_faculty_for_training(25);


#-------------------------------------------------------------------------------------------------------
# h.	Given CID, semester and an integer say n as input parameters, 
#       write a stored procedure that lists the students’ SID and their corresponding 
#       final mark for the top n final marks, in the descending order of their final mark 
#       for the course. If there are more than one student scoring the same 
#       final mark ranked in the top N, all the students’ SID are to be returned. 
#		(Hint: Use clause limit offset) 

#DROP PROCEDURE if exists sp_students_marks;

DELIMITER $$
CREATE PROCEDURE sp_students_marks(IN in_cid char(8), IN in_sem char(6), IN N int)
    BEGIN
    DECLARE l_mark decimal(5,2) ;  
    DECLARE l_cutoff int;
    
    set l_cutoff = N - 1;
	-- gets the Nth highest mark 
    set l_mark = (select distinct final_mark as fm from registration where 
				     semester = in_sem and cid = in_cid order by final_mark desc 
				     limit 1 offset l_cutoff);                      
	select sid, final_mark from registration where semester = in_sem and cid = in_cid 
		and final_mark >= l_mark order by final_mark desc;
    END$$
DELIMITER ;

    
CALL sp_students_marks( 'ISM 3112', 'I-2001', 2);


#-------------------------------------------------------------------------------------------------------
# i.	Write a stored procedure that lists the student(s) SID who has scored the best (mark) 
#       for the semester, course ID and assessment id (AID) passed in as input parameters. 
#       If the input parameter for AID has the value -1, the stored procedure is expected to list 
#       the student(s) SID with the best final mark considering all assessments of the given course. 
#       List the best student(s) SID and his best mark (or final_mark). If there are more students 
#       with the best mark for the assessment ( or best final mark ), these students’ SID 
#       are to be returned.

#DROP PROCEDURE if exists sp_top_student;

DELIMITER $$
CREATE PROCEDURE sp_top_student(in in_sem char(6), in in_cid char(8), in in_aid int  )
    BEGIN    
    declare best_mark decimal(5,2);
    
    IF in_aid = -1 THEN 
		
		select max(final_mark) into best_mark from registration r 
		where semester = in_sem and cid = in_cid;

		select sid, final_mark from registration r 
		where semester = in_sem and cid = in_cid and final_mark = best_mark;        
        
    ELSE
		
		select max(mark) into best_mark from performance p, registration r 
		where r.sid = p.sid and r.cid = p.cid 
		and semester = in_sem and p.cid = in_cid and p.aid = in_aid;
		
        select p.sid, mark from performance p, registration r 
		where r.sid = p.sid and r.cid = p.cid 
		and semester = in_sem and p.cid = in_cid and p.aid = in_aid
        and mark = best_mark;
    
    END IF;
	  
    END$$
DELIMITER ;
    
CALL sp_top_student( 'I-2001', 'ISM 3112', 2);
CALL sp_top_student( 'I-2001', 'ISM 3112', -1);


#-------------------------------------------------------------------------------------------------------
# j.	Given a semester as input parameter, write a stored procedure that lists all faculty who are 
#       qualified to teach at least 2 courses for which there are registrations in that semester.
#       The stored procedure is expected to list FID and the number of courses (2 or more) he/she is 
#       qualified to teach in the given semester. The stored procedure should also return the 
#       number of faculty members who are not qualified to teach a minimum of 2 courses in that 
#       semester (as out parameter)

#DROP PROCEDURE sp_get_faculty;

DELIMITER $$
CREATE PROCEDURE sp_get_faculty(IN sem char(6), OUT fac_count int)
BEGIN

select fid, count(distinct q.cid) as 'Num Courses Qualified' from registration r, qualification q 
where q.cid = r.cid and semester = sem
group by fid having count(distinct q.cid) >= 2;

select count(*) into fac_count from 
(
	select fid from faculty where fid not in  
	(
	select fid from registration r, qualification q 
	where q.cid = r.cid and semester = sem
	group by fid having count(distinct q.cid) >= 2
	)
) as temp;


END $$
DELIMITER ;

CALL sp_get_faculty('I-2002', @out);
SELECT @out as 'Num faculty not qualified';

DELIMITER $$
CREATE PROCEDURE sp_get_faculty(IN in_sem char(6), out faq_count int)

BEGIN
	select q.fid, count(q.cid) as noOfCourses
    from qualification q, registration r
    where q.cid = r.cid and r.semester = in_sem
    group by q.fid having noOfCourses >=2;
    
    
    
    set faq_count = (select count(*) from (select q.fid, count(q.cid) as noOfCourses
    from qualification q, registration r
    where q.cid = r.cid and r.semester = in_sem
    group by q.fid
    having noOfCourses <2) as temp);
end$$

delimiter ;

CALL sp_get_faculty('I-2002', @out);
SELECT @out as 'Num faculty not qualified';
drop procedure sp_get_faculty;

        
    

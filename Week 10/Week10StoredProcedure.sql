
create procedure getAllStuCourse(in courseid char(8)) 

	select sid
    from registration r
    where cid = courseid;


call getAllStuCourse('ISM 4212');
drop procedure getAllStuCourse;
-- put drop at the bottom as in sql you need to keep dropping and creating when you make changes to your code for the changes to save

create procedure getFaqCourse(in courseid char(8), out totalcount int) -- use out (similar to return statement)
	select count(*) into totalcount -- use into here to return integer into totalcount
    from qualification q
    where cid = courseid;
	
call getFaqCourse('ISM 4212', @totalcount);
drop procedure getFaqCourse;

create procedure getFaqCourse1(in courseid char(8), out totalcount int)
	set totalcount = (select count(*)
    from qualification q
    where cid = courseid);
	
call getFaqCourse1('ISM 4212', @totalcount);
select @totalcount;
drop procedure getFaqCourse1;

delimiter $$
create procedure getFaqStuCourse(in courseid char(8), out totalcount int)
	begin
		declare faqcount int;
        declare stucount int;
        declare totalcount int;
		set faqcount = (select count(fid)
		from qualification q
		where cid = courseid);
        
        set stucount = (select count(sid)
		from registration r
		where cid = courseid);
        
        set totalcount = faqcount + stucount;
        
    end$$
delimiter ;
call getFaqStuCourse('ISM 4212', @totalcount);
select @totalcount;
drop procedure getFaqStuCourse;


delimiter $$
create procedure getFaqStuCourse1(in courseid char(8), out totalcount1 int)
	begin
		set totalcount1 = (select count(*) from registration where cid = courseid) +
        (select count(*) from qualification where cid = courseid);
        
    end$$
delimiter ;
call getFaqStuCourse1('ISM 4212', @totalcount1);
select @totalcount1;
drop procedure getFaqCourse1;

-- Trigger
delimiter $$
create trigger before_Registration_insert before insert on Registration for each row
#CREATE TRIGGER trigger_name trigger_time  trigger_event  ON table_name FOR EACH ROW  trigger_body

  begin
    declare cnt int;
        set cnt = (select count(*) from registration
          where sid = NEW.sid
                    and semester = NEW.semester); #fire this 
        
        
        
        #Check if student has taken 5 courses
        if cnt = 5 then
      signal sqlstate '45000'
      set message_text = 'Trigger Error: Student has taken 5 courses';
        end if;
        
  end$$
delimiter ;

show triggers;  #press i on schema also can see trigger
drop trigger before_Registration_insert;

delimiter $$
create trigger before_performance_insert before insert on performance for each row
begin
	
    declare currSum int;
    declare newWt double;
    declare newTtal double;
    declare newMessage varchar(256);
    
    #check what is the current sum of weightage
    set currSum = (select sum(weight) from performance p, assessment a
		where p.aid = a.aid
		and p.sid = new.sid
		and p.sid = new.sid
		and p.cid = new.cid);
    #get the new assessment weight
	set newWt = (select weight from assessment where aid = new.aid);
    
    set newTotal = currSum + newWt;
    
    if newTotal >1 then
		set newMessage = concat('Trigger Error: course assessment weight is more than 100% new value', newTotal);
        signal sqlState '4500' set message_text = newMessage;
    end if;
    
    delimiter ;
    show triggers;
	drop before_performance_insert;
  
    
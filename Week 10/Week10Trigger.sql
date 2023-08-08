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
  
    
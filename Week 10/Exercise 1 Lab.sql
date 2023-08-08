# Exercise 1
delimiter $$
create procedure sp_count_accounts(in customerName varchar(45), out SA int, out FD int)
	begin
	
        set SA = (select count(*)
        from account
        where ACC_TYPE = 'SA' and CUS_NAME = customerName);
        
        set FD = (select count(*)
        from account
        where ACC_TYPE = 'FD' and CUS_NAME = customerName);

	end$$
    

delimiter ;

CALL sp_count_accounts('Alex', @SA, @FD);
SELECT @SA as Savings, @FD as 'Fixed Deposit';
drop procedure sp_count_accounts;







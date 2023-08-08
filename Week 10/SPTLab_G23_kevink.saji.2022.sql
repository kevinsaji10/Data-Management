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

# Excercise 2
delimiter $$
create trigger update_accounts after insert on Transactions for each row
	begin
        if new.trans_type = 'D' then
			UPDATE account
			SET balance = balance - new.amount
			WHERE acc_num = new.acc_num;
		elseif new.trans_type = 'W' then
			UPDATE account
			SET balance =balance - new.amount
			WHERE acc_num = new.acc_num;
		end if;
        
	end$$
    
delimiter ;
show triggers;
INSERT INTO TRANSACTIONS(ACC_NUM, AMOUNT, TRANS_TYPE) VALUES ('A9',200, 'D');
INSERT INTO TRANSACTIONS(ACC_NUM, AMOUNT, TRANS_TYPE) VALUES ('A9',100, 'W');
drop trigger update_accounts;

# Exercise 3
delimiter $$
create trigger delete_account before delete on Account for each row
begin
	insert into deleted_accounts
    values(old.acc_num, old.acc_type, old.cus_name, old.balance, now());
    
	delete from transactions
    where acc_num = old.acc_num;
    
end$$

delimiter ;
show triggers;

#Test Script
INSERT INTO ACCOUNT VALUES ('ZZ', 'FD', 'DUMMY', 200);
INSERT INTO TRANSACTIONS(ACC_NUM, AMOUNT, TRANS_TYPE) VALUES('ZZ', 888.88, 'D');
DELETE FROM ACCOUNT WHERE ACC_NUM = 'ZZ';
drop trigger delete_account;
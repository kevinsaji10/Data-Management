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
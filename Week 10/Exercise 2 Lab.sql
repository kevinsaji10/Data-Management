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



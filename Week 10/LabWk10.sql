drop database labwk10;
create database labwk10;
use labwk10;
#Table ACCOUNT creation 
CREATE TABLE ACCOUNT ( 
ACC_NUM VARCHAR(8) NOT NULL PRIMARY KEY, 
ACC_TYPE CHAR(2)  NOT NULL, 
CUS_NAME VARCHAR(45) NOT NULL, 
BALANCE DECIMAL(10,2) 
); 

 

#Table TRANSACTIONS creation
CREATE TABLE TRANSACTIONS ( 
TRANS_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
ACC_NUM VARCHAR(8) NOT NULL, 
AMOUNT DECIMAL(10,2) NOT NULL, 
TRANS_TYPE CHAR(1) NOT NULL,  
CONSTRAINT TRANSACTION_FK FOREIGN KEY (ACC_NUM)  
REFERENCES ACCOUNT(ACC_NUM) 
); 

#Note: TRANS_ID is an integer and it will auto increment by 1 when a new record is inserted.  

 
 

# table DELETED_ACCOUNTS creation
CREATE TABLE DELETED_ACCOUNTS ( 
ACC_NUM VARCHAR(8) NOT NULL PRIMARY KEY, 
ACC_TYPE CHAR(2)  NOT NULL, 
CUS_NAME VARCHAR(45) NOT NULL, 
BALANCE DECIMAL(10,2), 
CLOSED_DATE DATETIME 
); 

 

#Insertion of Records 

INSERT INTO ACCOUNT VALUES 
('A1', 'SA', 'Alex', 1000.0), 
('A2', 'SA', 'Bob', 500.0), 
('A3', 'FD', 'Alex', 3000.0),
('A4', 'SA', 'Cathy', 750.0),
('A5', 'SA', 'Daniel', 600.0), 
('A6', 'FD', 'Cathy', 2000.0), 
('A7', 'FD', 'Eagan', 1000.0),
('A8', 'SA', 'Eagan', 500.0), 
('A9', 'SA', 'Alex', 550.0); 

 
INSERT INTO TRANSACTIONS(ACC_NUM, AMOUNT, TRANS_TYPE) VALUES  
('A1', 1000.0, 'D'), 
('A2', 500.0, 'D'), 
('A3', 1000.0, 'D'),
('A3', 1000.0, 'D'),
('A3', 1000.0, 'D'),
('A4', 500.0, 'D'), 
('A4', 500.0, 'D'), 
('A4', 250.0, 'W'), 
('A5', 600.0, 'D'), 
('A6', 1000.0, 'D'),
('A6', 500.0, 'D'), 
('A6', 500.0, 'D'), 
('A7', 1000.0, 'D'),
('A8', 500.0, 'D'), 
('A9', 550.0, 'D'); 
drop database dm_schema;
create database dm_schema;
use dm_schema;
-- remember to right click on dm_schema and set to default
create table course
( cid char(8) not null,
cname varchar(15) not null,
constraint course_pk primary key (cid)
);
-- create the tables that provide the primary key before creating
-- the tables that use the primary key as foreign key
create table faculty
(fid int not null,
fname varchar(25),
constraint faculty_pk primary key (fid)
);

create table Qualification
(fid int not null,
cid char(8) not null,
constraint qualification_pk primary key (fid, cid),
constraint qualification_fk1 foreign key (cid) references course(cid),
constraint qualification_fk2 foreign key (fid) references faculty(fid)
);












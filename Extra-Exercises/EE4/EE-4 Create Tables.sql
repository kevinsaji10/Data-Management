drop database dm_schema;
create database dm_schema;
use dm_schema;

create table assessment
( aid int not null,
Aname varchar(15) ,
weight decimal(3,2) ,
constraint assesment_pk primary key (aid)
);

create table student
(sid int not null,
sname varchar(15),
constraint student_pk primary key (sid)
);

create table course
(cid char(8) not null,
cname varchar(15),
constraint course_pk primary key (cid)
);

create table faculty
(fid int not null,
fname varchar(15),
constraint faculty_pk primary key (fid)
);

create table room 
(rid int not null, 
type varchar(20), 
capacity int,
constraint room_pk primary key (rid)
);

create table qualification
(fid int not null,
cid char(8) not null,
date_qualified date,
constraint qualification_pk primary key (fid, cid),
constraint qualificaiton_fk1 foreign key (fid) references faculty(fid),
constraint qualification_fk2 foreign key (cid) references course(cid)
);

create table registration
(sid int not null,
cid char(8) not null,
semester char(6),
constraint registration_pk primary key (sid, cid),
constraint registration_fk1 foreign key (sid) references student(sid),
constraint registration_fk2 foreign key (cid) references course(cid)
);

create table performance
(sid int not null,
cid char(8) not null,
aid int not null,
mark int,
constraint performance_pk primary key (sid, cid, aid),
constraint performance_fk1 foreign key (aid) references assessment(aid),
constraint performance_fk2 foreign key (sid) references student(sid),
constraint performance_fk3 foreign key (cid) references course(cid)
);









 
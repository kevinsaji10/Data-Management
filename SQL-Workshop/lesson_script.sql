
create schema lesson_script;
use lesson_script;

create table student (
StudentID int not null,
SName varchar(15) not null,
CONSTRAINT student_pk PRIMARY KEY (StudentID)
);

create table faculty (
FacultyID int not null,
FName varchar(15) not null,
CONSTRAINT faculty_pk PRIMARY KEY (FacultyID)
);

create table course (
CourseID char(5) not null,
StudentID int not null, 
FacultyID int not null,
CName varchar(30) not null,
CONSTRAINT course_pk PRIMARY KEY (CourseID, StudentID, FacultyID),
CONSTRAINT foreign_fk1 FOREIGN KEY (StudentID) REFERENCES student (StudentID),
CONSTRAINT foreign_fk2 FOREIGN KEY (FacultyID) REFERENCES faculty (FacultyID)
);

INSERT INTO student VALUES (123456, 'John Leow'), (123457, 'Ian Lim'), (123458, 'Laurey Wong'), (123459, 'John Smith'), (123460, 'Sean Adams'), (123461, 'Anne Lee'), (123462, 'Sally Wok');
INSERT INTO faculty VALUES (987654, 'Ama'), (987655, 'Berlin'), (987656, 'Derik'), (987657, 'Casey');
INSERT INTO course VALUES 
('IS111', 123456, 987655, 'Introduction to Programming'),
('IS111', 123457, 987654, 'Introduction to Programming'),
('IS111', 123458, 987654, 'Introduction to Programming'),
('IS112', 123456, 987655, 'Data Management'),
('IS112', 123457, 987655, 'Data Management'),
('IS112', 123459, 987655, 'Data Management'),
('IS112', 123461, 987655, 'Data Management'),
('IS113', 123458, 987655, 'Web Application Development'),
('IS113', 123459, 987656, 'Web Application Development'),
('IS113', 123461, 987656, 'Web Application Development');
-- D. Student enrollment in courses and books adopted for each course
-- STUDENT (regno: string, name: string, major: string, bdate: date)
-- COURSE (course#:int, cname: string, dept: string)
-- ENROLL(regno:string, course#: int,sem: int,marks: int)
-- BOOK-ADOPTION (course#:int, sem: int, book-ISBN: int)
-- TEXT (book-ISBN: int, book-title: string, publisher: string,author:string)

create database if not exists student;
use student;

create table if not exists student
	(regno varchar(10) primary key,name varchar(30),major VARCHAR(30),bdate date);

create table if not exists courses
	(course int primary key,cname varchar(30),dept VARCHAR(30));

create table if not exists texts
	(book_isbn int primary key, book_title VARCHAR(30),publisher VARCHAR(30),author VARCHAR(30));

create table if not exists enroll
	(regno varchar(10),course int,sem int,marks int,primary key(regno,course),
		foreign key(regno) references student(regno) on delete cascade,
		foreign key(course) references courses(course) on delete cascade
		);
create table if not exists book_adopt
	(course int,sem int,book_isbn int,primary key(course,book_isbn),
		foreign key(course) references courses(course) on delete cascade,
		foreign key(book_isbn) references texts(book_isbn) on delete cascade
		);

desc student;

desc courses;

desc enroll;

desc book_adopt;

desc texts;

insert into student values
	("s111","giri","maths","2020-02-02"),
	("s222","asdf","eng","2020-02-02"),
	("s333","ram","phy","2020-02-02"),
	("s444","qwerty","chem","2020-02-02"),
	("s555","vivek","maths","2020-02-02");

select * from student;

insert into courses values
	(111,"os","cse"),
	(222,"control sys","ec"),
	(333,"dbms","cse"),
	(444,"dms","cse"),
	(555,"sensors","ec");

select * from courses;

insert into enroll values
	("s111",111,3,90),
	("s333",222,5,95),
	("s333",333,5,90);

select * from enroll;

insert into texts values
	(123,"Operating Sys","pearson","senberg"),
	(234,"data str","mc grill","balguru"),
	(345,"digital sys","pearson","sita");

select * from texts;

insert into book_adopt values
	(111,3,123),
	(111,3,234),
	(222,5,345),
	(333,3,345);

select * from book_adopt;
-- D. Student enrollment in courses and books adopted for each course
-- STUDENT (regno: string, name: string, major: string, bdate: date)
-- COURSE (course#:int, cname: string, dept: string)
-- ENROLL(regno:string, course#: int,sem: int,marks: int)
-- BOOK-ADOPTION (course#:int, sem: int, book-ISBN: int)
-- TEXT (book-ISBN: int, book-title: string, publisher: string,author:string)


-- 1. Demonstrate how you add a new text book to the database and make this book be adopted by some department.


-- 2. Produce a list of text books (include Course #, Book-ISBN, Book-title) in the 
--    alphabetical order for courses offered by the ‘CS’ department that use more than 
--    two books.
-- select b.course,b.book_isbn,t.book_title from book_adopt b,texts t where b.book_isbn=t.book_book and 
-- b.course in ( )

select b.book_isbn,count(b.book_isbn) from book_adopt b,courses c where b.course=c.course and c.dept="cse" group by b.book_isbn;

-- 3. List any department that has all its adopted books published by a specific publisher.


-- 4. List the students who have scored maximum marks in ‘DBMS’ course.
select s.name from student s,courses c,enroll e where s.regno=e.regno and c.course=e.course and c.cname="dbms";

-- 5. Create a view to display all the courses opted by a student along with marks obtained.
create view view1 as select s.name,c.cname,e.marks from courses c,student s,enroll e where s.regno=e.regno and c.course=e.course;
select * from view1 where name="ram";

-- 6. Create a trigger such that it Deletes all records from enroll table when course is deleted .

delimiter //
create trigger delete_record after delete on course for each row
begin
if courses.course = enroll.course then
delete from enroll where enroll.course = courses.course;
end if;
end; //
delimiter ;

-- drop database student;

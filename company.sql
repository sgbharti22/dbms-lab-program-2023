-- E. Company Database:
-- EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
-- DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate)
-- DLOCATION (DNo,DLoc)
-- PROJECT (PNo, PName, PLocation, DNo)
-- WORKS_ON (SSN, PNo, Hours)

create database if not exists company;

use company;

create table if not exists dept(dno int primary key,dname varchar(50),mgrssn int,mgrdate date);

create table if not exists dlocate(dno int,dloc varchar(50),primary key(dno,dloc),foreign key(dno)references dept(dno) on delete cascade);

create table if not exists project(pno int primary key,pname varchar(50),ploc varchar(50),dno int,
	foreign key(dno)references dept(dno) on delete cascade);

create table if not exists employee(ssn int primary key,name varchar(50),address varchar(50),sex char,salary int,superssn int,dno int,
	foreign key(dno) references dept(dno) on delete cascade);

create table if not exists workson(ssn int,pno int,hours int,primary key(ssn,hours),
	foreign key(ssn) references employee(ssn) on delete cascade,
	foreign key(pno) references project(pno) on delete cascade
	);

desc dept;

desc dlocate;

desc project;

desc employee;

desc workson;

INSERT INTO dept VALUES
(001, "Human Resources", 789, "2020-10-21"),
(002, "Quality Assesment", 456, "2020-10-19"),
(003, "Technical", 123, "2020-10-20"),
(004, "Quality Control", 321, "2020-10-18"),
(005, "R & D",654, "2020-10-17");

select * from dept;

INSERT INTO employee VALUES
(20001, "Employee_1","Siddartha Nagar, Mysuru", "M", 1500000,789 , 5),
(20010, "Employee_2", "Lakshmipuram, Mysuru", "F", 1200000,456, 2),
(20011, "Employee_3", "Pune, Maharashtra", "M", 1000000,123, 4),
(20100, "Employee_4", "Hyderabad, Telangana", "M", 2500000,123 , 5),
(20101, "Employee_5", "JP Nagar, Bengaluru", "F", 1700000, 789, 1);

insert into employee values(20110, "Employee_6","Siddartha Nagar, Mysuru", "M", 1500000,789 , 5);
insert into employee values(20111, "Employee_7","Siddartha Nagar, Mysuru", "M", 1500000,789 , 5);
insert into employee values(21000, "Employee_8","Siddartha Nagar, Mysuru", "M", 1500000,789 , 5);
insert into employee values(21001, "Employee_9","Siddartha Nagar, Mysuru", "M", 1500000,789 , 5);

select * from employee;

INSERT INTO dlocate VALUES
(001, "Jaynagar, Bengaluru"),
(002, "Vijaynagar, Mysuru"),
(003, "Chennai, Tamil Nadu"),
(004, "Mumbai, Maharashtra"),
(005, "Kuvempunagar, Mysuru");

select * dlocate;


INSERT INTO project VALUES
(30001, "System Testing", "Mumbai, Maharashtra", 004),
(30010, "Cost Mangement", "JP Nagar, Bengaluru", 001),
(30011, "Product Optimization", "Hyderabad, Telangana", 005),
(30100, "Yeild Increase", "Kuvempunagar, Mysuru", 005),
(30101, "Product Refinement", "Saraswatipuram, Mysuru", 002);

select * from project;

INSERT INTO workson VALUES
(20001,30001 , 5),
(20010,30010 , 6),
(20011,30011 , 3),
(20100,30100 , 3),
(20101,30101 , 6);

select * from workson;

-- 1.Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, 
--   either as a worker or as a manager of the department that controls the project.

select p.pno from project p,workson w,employee e where w.pno=p.pno and e.ssn=w.ssn and e.name like '%4';

-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise.

select e.name,e.salary old_salary ,salary+(0.1*salary) new_salary from employee e,project p,workson w where e.ssn=w.ssn and p.pno=w.pno and p.pname="Product Refinement";

-- 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, 
--    and the average salary in this department

select sum(salary),max(salary),min(salary),avg(salary) from employee where dno in (select dno from dept where dname="R & D");

-- 4. Retrieve the name of each employee who works on all the projects controlled by department number 5 (use NOT EXISTS operator).


-- 5. For each department that has more than five employees, retrieve the department number and 
--    the number of its employees who are making more than Rs. 6,00,000.

select d.dno,count(*) from employee e,dept d where e.dno=d.dno and e.salary>600000 group by d.dno having count(*)>=5;

-- 6. Create a view that shows name, dept name and location of all employees.

create view view1 as select e.name,d.dname,dl.dloc from employee e,dept d,dlocate dl where e.dno=d.dno and d.dno=dl.dno;

select * from view1;

-- 7. A trigger that automatically updates manager’s start date when he is assigned
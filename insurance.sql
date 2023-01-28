-- B. Insurance database
-- PERSON (driver id#: string, name: string, address: string)
-- CAR (regno: string, model: string, year: int)
-- ACCIDENT (report_ number: int, acc_date: date, location: string)
-- OWNS (driver id#: string, regno: string)
-- PARTICIPATED(driver id#:string, regno:string, report_ number:int,damage_amount: int)

create database if not exists insurance;
use insurance;

create table if not exists person (driver_id varchar(5) primary key,name varchar(30) not null,address varchar(70));

create table if not exists car (reg_no varchar(20) primary key,model varchar(30) not null,year int);

create table if not exists accident (report_no int primary key,acc_date date,loc varchar(70));

create table if not exists owns (driver_id varchar(5),reg_no varchar(20),primary key(driver_id,reg_no),
	foreign key(driver_id) references person(driver_id) on delete cascade,
	foreign key(reg_no) references car(reg_no) on delete cascade
	);

create table if not exists participated (driver_id varchar(5),reg_no varchar(20),report_no int,dmg_amt int,
	primary key(driver_id,reg_no,report_no),
	foreign key(driver_id) references person(driver_id) on delete cascade,
	foreign key(report_no) references accident(report_no) on delete cascade,
	foreign key(reg_no) references car(reg_no) on delete cascade
	);

desc person;
desc car;
desc accident;
desc owns;
desc participated;

insert into person values
	("d111","giri","Mysore"),
	("d222","guru","blore"),
	("d333","ram","sagar"),
	("d444","asdf","berur");
insert into car values
	("KA09MA1234","zen","2011"),
	("KA09MA1235","nano","2014"),
	("KA09MA1236","alto","2018"),
	("KA09MA1237","benz","2022"),
	("KA09MA1238","bmw","2023"),
	("KA09MA1239","alto","2021"),
	("KA09MA1240","duster","2021");


insert into accident values 
	(111,"2020-01-01","hootgalli"),
	(222,"2021-01-01","belvadi"),
	(333,"2020-02-02","vijaynagar"),
	(444,"2021-01-03","primer studio");

insert into owns values
	("d111","KA09MA1234"),
	("d222","KA09MA1235"),
	("d333","KA09MA1236"),
	("d444","KA09MA1237"),
	("d444","KA09MA1238");


insert into participated values
	("d111","KA09MA1234",111,5000),
	("d222","KA09MA1235",222,6000),
	("d333","KA09MA1236",333,7000),
	("d444","KA09MA1237",444,8000);

select * from person;

select * from car;

select * from accident;

select * from owns;

select * from participated;

-- drop database insurance;

-- B. Insurance database
-- PERSON (driver id#: string, name: string, address: string)
-- CAR (regno: string, model: string, year: int)
-- ACCIDENT (report_ number: int, acc_date: date, location: string)
-- OWNS (driver id#: string, regno: string)
-- PARTICIPATED(driver id#:string, regno:string, report_ number:int,damage_amount: int)

-- 1. Find the total number of people who owned cars that were involved in accidents in 2021.
-- 2. Find the number of accidents in which the cars belonging to “Smith” were involved.
-- 3. Add a new accident to the database; assume any values for required attributes.
-- 4. Delete the Mazda belonging to “Smith”.
-- 5. Update the damage amount for the car with license number “KA09MA1234” in the accident with report.
-- 6. A view that shows models and year of cars that are involved in accident.
-- 7. A trigger that prevents driver with total damage amount >rs.50,000 from owning a car.

-- 1.	Find the total number of people who owned cars that were involved in accidents in 2021.

select count(distinct p.name) from accident a natural join person p natural join participated par where a.acc_date between '2021-01-01' and '2022-01-01';


-- 2.	Find the number of accidents in which the cars belonging to “Smith” were involved. 

select count(reg_no) from participated where reg_no in(select reg_no from owns natural join person p where p.name ="giri");

-- 3. Add a new accident to the database; assume any values for required attributes.
insert into accident values 
	(555,"2020-01-01","hootgalli");
insert into participated values
	("d444","KA09MA1237",111,8000);

-- 4. Delete the Mazda belonging to “Smith”.

delete from owns where driver_id=(select driver_id from person where name="guru") and reg_no=(select reg_no from car where model="nano");

-- 5. Update the damage amount for the car with license number “KA09MA1234” in the accident with report.

update participated set dmg_amt=888888 where report_no=111 and driver_id=(select driver_id from owns where reg_no="KA09MA1234");

-- 6. A view that shows models and year of cars that are involved in accident.

create view view1 as select model,year from car where reg_no in (select reg_no from participated);

-- - 7. A trigger that prevents driver with total damage amount >rs.50,000 from owning a car.

DELIMITER //
CREATE TRIGGER PDOC
	BEFORE INSERT ON owns
    FOR EACH ROW
    BEGIN
		IF NEW.driver_id IN (SELECT driver_id FROM participated WHERE dmg_amt > 50000)
        THEN 
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Person cannot own a car....!';
		END IF;
	END; //

DELIMITER ;

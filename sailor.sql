-- A.Sailors database
-- SAILORS (sid, sname, rating, age)
-- BOAT(bid, bname, color)
-- RSERVERS (sid, bid, date)
create database if not exists sailors;
use sailors;

create table if not exists sailors(sid int primary key,sname varchar(30) not null,rating int,age int);

create table if not exists boat(bid int primary key,bname varchar(30),color varchar(30));

create table if not exists reserves(sid int,bid int,date date,primary key(sid,bid),
        foreign key(sid) references sailors(sid) on delete cascade,
        foreign key(bid) references boat(bid) on delete cascade);

insert into sailors values (111,"ram",5,40);
insert into sailors values (222,"giri",4,47);
insert into sailors values (333,"guru",3,48);
insert into sailors values (444,"krish",5,51);
insert into sailors values (555,"albert",5,50);       

select * from sailors;

insert into boat values (123,"cat","red");
insert into boat values (234,"dog","blue");
insert into boat values (345,"ant","black");
insert into boat values (456,"rose","blue");

select * from boat;

insert into reserves values (111,123,"2020-08-01");
insert into reserves values (222,234,"2021-04-05");
insert into reserves values (333,345,"2022-05-05");
insert into reserves values (333,123,"2022-06-06");

select * from reserves;




-- A.Sailors database
-- SAILORS (sid, sname, rating, age)
-- BOAT(bid, bname, color)
-- RSERVERS (sid, bid, date)

-- 1. Find the colours of boats reserved by Albert
-- 2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
-- 3. Find the names of sailors who have not reserved a boat whose name contains the string “storm”.
--    Order the names in ascending order.
-- 4. Find the names of sailors who have reserved all boats.
-- 5. Find the name and age of the oldest sailor.
-- 6. For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and the average age of such sailors.
-- 7. A view that shows names and ratings of all sailors sorted by rating in descending order.
-- 8. A trigger that prevents boats from being deleted If they have active reservations.


-- 1. Find the colours of boats reserved by Albert
select b.color,b.bname,s.sname from sailors s,reserves r,boat b where r.sid=s.sid and r.bid=b.bid and s.sname="giri";

-- 2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
select sid from sailors where rating>5
union
select sid from reserves where bid=234;

-- 3. Find the names of sailors who have not reserved a boat whose name contains the string “storm”.
--    Order the names in ascending order.
select sname from sailors where sid not in (select sid from reserves) and sname like 'g%' order by sname;

delete from boat where bid>300;

select * from boat;

-- 4. Find the names of sailors who have reserved all boats.
SELECT S.sname 
FROM sailors S
WHERE NOT EXISTS (SELECT B.bid 
                  FROM boat B
                  WHERE NOT EXISTS(SELECT R.bid
                                   FROM reserves R
                                   WHERE R.bid = B.bid
                                         AND R.sid = S.sid));

-- A.Sailors database
-- SAILORS (sid, sname, rating, age)
-- BOAT(bid, bname, color)
-- RSERVERS (sid, bid, date)


-- 5. Find the name and age of the oldest sailor.
select sname,age as age from sailors where age=(select max(age) from sailors);


-- 6. For each boat which was reserved by at least 5 sailors with age >= 40, 
--    find the boat id and the average age of such sailors.
select b.bid,avg(age) from sailors s,reserves r,boat b where s.age>=40 and b.bid=r.bid and s.sid=r.sid group by b.bid having count(distinct s.sid)>=5;
-- 7. A view that shows names and ratings of all sailors sorted by rating in descending order.
create view view1 as select sname,rating from sailors order by rating desc; 

select * from view1;

-- 8. A trigger that prevents boats from being deleted If they have active reservations.

DELIMITER //
CREATE TRIGGER ARB
        BEFORE DELETE ON boat
    FOR EACH ROW
    BEGIN 
                IF OLD.bid IN (SELECT bid FROM reserves NATURAL JOIN boat)
        THEN 
                        SIGNAL SQLSTATE '45000'
                                SET MESSAGE_TEXT = 'The boat details you want to delete has active reservations....!';
                END IF;
        END; //

DELIMITER ;

SHOW TRIGGERS;

delete from boat where bid=234;



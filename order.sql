-- C. Order processing database
-- Customer (Cust#:int, cname: string, city: string)
-- Order (order#:int, odate: date, cust#: int, order-amt: int)
-- Order-item (order#:int, Item#: int, qty: int)
-- Item (item#:int, unitprice: int)
-- Shipment (order#:int, warehouse#: int, ship-date: date)
-- Warehouse (warehouse#:int, city: string)

CREATE DATABASE IF NOT EXISTS order2;
use order2;

CREATE TABLE IF NOT EXISTS customer (
    cust INTEGER NOT NULL,
    cname VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    PRIMARY KEY(cust)
);

CREATE TABLE IF NOT EXISTS item (
    itemid INTEGER NOT NULL,
    unitprice INTEGER NOT NULL,
    PRIMARY KEY(itemid)
);

CREATE TABLE IF NOT EXISTS warehouse (
    warehouseid INTEGER PRIMARY KEY,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
    orderid INTEGER NOT NULL,
    odate DATE NOT NULL,
    cust INTEGER,
    order_amt INTEGER,
    PRIMARY KEY(orderid,cust),
    FOREIGN KEY(cust) REFERENCES customer(cust) 
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_item (
    orderid INTEGER NOT NULL,
    itemid INTEGER,
    qty INTEGER,
    PRIMARY KEY(orderid,itemid),
    FOREIGN KEY(orderid) REFERENCES orders(orderid)
    ON DELETE CASCADE,
    FOREIGN KEY(itemid) REFERENCES item(itemid)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS shipment (
    orderid INTEGER NOT NULL,
    warehouseid INTEGER,
    PRIMARY KEY(orderid,warehouseid),
    ship_date DATE NOT NULL,
    FOREIGN KEY(orderid) REFERENCES orders(orderid)
    ON DELETE CASCADE,
    FOREIGN KEY(warehouseid) REFERENCES warehouse(warehouseid)
    ON DELETE CASCADE
);


INSERT INTO customer VALUES
(0001, "Customer_1", "Mysuru"),
(0002, "Customer_2", "Bengaluru"),
(0003, "Customer_3", "Mumbai"),
(0004, "Customer_4", "Dehli"),
(0005, "Customer_5", "Bengaluru");

INSERT INTO item VALUES
(0001, 400),
(0002, 200),
(0003, 1000),
(0004, 100),
(0005, 500);

INSERT INTO warehouse VALUES
(0001, "Mysuru"),
(0002, "Bengaluru"),
(0003, "Mumbai"),
(0004, "Dehli"),
(0005, "Chennai");

INSERT INTO orders VALUES
(001, "2020-01-14", 0001, 2000),
(002, "2021-04-13", 0002, 500),
(003, "2019-10-02", 0005, 2500),
(004, "2019-05-12", 0003, 1000),
(005, "2020-12-23", 0004, 1200);


INSERT INTO order_item VALUES 
(001, 0001, 5),
(002, 0005, 1),
(003, 0005, 5),
(004, 0003, 1),
(005, 0004, 12);


INSERT INTO shipment VALUES
(001, 0002, "2020-01-16"),
(002, 0001, "2021-04-14"),
(003, 0004, "2019-10-07"),
(004, 0003, "2019-05-16"),
(005, 0005, "2020-12-23");

select * from customer;

select * from item;
select * from warehouse;
select * from orders;
select * from order_item;
select * from shipment;

-- 1.List the Order# and Ship_date for all orders shipped from Warehouse# "W2".
select orderid,ship_date from shipment where warehouseid=4;

-- 2. List the Warehouse information from which the Customer named "Kumar" was supplied his orders.
 --   Produce a listing of Order#, Warehouse#.
select s.orderid,s.warehouseid,w.city from customer c,orders o,shipment s,warehouse w where c.cname="Customer_4" 
and c.cust=o.cust and o.orderid=s.orderid and w.warehouseid=s.warehouseid;

-- 3. Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total number of orders 
--    by the customer and the last column is the average order amount for that customer. (Use aggregate functions)

select c.cname,count(o.orderid),avg(o.order_amt) from customer c join orders o on c.cust=o.cust group by c.cname;
-- 4. Delete all orders for customer named "Kumar".

delete from orders where cust=(select cust from customer where cname="Customer_1");
-- 5. Find the item with the maximum unit price.
select itemid,unitprice from item where unitprice=(select max(unitprice) from item);

-- 6. A trigger that prevents a project from being deleted if it is currently being worked by any employee.


-- 7. Create a view to display orderID and shipment date of all orders shipped from a warehouse 2.

CREATE view view1 as select orderid,ship_date from shipment where warehouseid=4;

select * from view1;

-- drop DATABASE order1;
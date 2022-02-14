create database if not exists `order-directory` ;
use `order-directory`;

create table if not exists supplier(SUPP_ID int primary key,
SUPP_NAME varchar(50),
SUPP_CITY varchar(50),
SUPP_PHONE varchar(50));

create table if not exists customer(CUS_ID int primary key,
CUS_NAME varchar(50),
CUS_PHONE varchar(10),
CUS_CITY varchar(30),
CUS_GENDER char);

create table if not exists category(CAT_ID int primary key,
CAT_NAME varchar(50));

create table if not exists product(PRO_ID int primary key,
PRO_NAME varchar(50) null default null,
PRO_DESC varchar(60) null default null,
CAT_ID int not null,
foreign key (CAT_ID) references category(CAT_ID)); 

create table if not exists product_details(PROD_ID int primary key,
PRO_ID int not null,
SUPP_ID int not null,
PROD_PRICE int not null,
foreign key (PRO_ID) references product(PRO_ID),
foreign key (SUPP_ID) references supplier(SUPP_ID));

create table if not exists `order`(ORD_ID int primary key,
ORD_AMOUNT int not null,
ORD_DATE date,
CUS_ID int not null,
PROD_ID int not null,
foreign key (PROD_ID) references product_details(PROD_ID),
foreign key (CUS_ID) references customer(CUS_ID));

create table if not exists rating(RAT_ID int primary key,
RAT_RATSTARS int not null,
CUS_ID int not null,
SUPP_ID int not null,
foreign key (CUS_ID) references customer(CUS_ID),
foreign key (SUPP_ID) references supplier(SUPP_ID));

insert into supplier values(1,"Rajesh Retails","Delhi",'1234567890');
insert into supplier values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into supplier values(3,"Knome products","Banglore",'9785462315');
insert into supplier values(4,"Bansal Retails","Kochi",'8975463285');
insert into supplier values(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO customer VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO customer VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO customer VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO customer VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO customer VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO category VALUES( 1,"BOOKS");
INSERT INTO category VALUES(2,"GAMES");
INSERT INTO category VALUES(3,"GROCERIES");
INSERT INTO category VALUES (4,"ELECTRONICS");
INSERT INTO category VALUES(5,"CLOTHES");

INSERT INTO product VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO product VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO product VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO product VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO product VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);

INSERT INTO product_details VALUES(1,1,2,1500);
INSERT INTO product_details VALUES(2,3,5,30000);
INSERT INTO product_details VALUES(3,5,1,3000);
INSERT INTO product_details VALUES(4,2,3,2500);
INSERT INTO product_details VALUES(5,4,1,1000);

INSERT INTO `order` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `order` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `order` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `order` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `order` VALUES(30,3500,"2021-08-16",4,3);

INSERT INTO rating VALUES(1,2,2,4);
INSERT INTO rating VALUES(2,3,4,3);
INSERT INTO rating VALUES(3,5,1,5);
INSERT INTO rating VALUES(4,1,3,2);
INSERT INTO rating VALUES(5,4,5,4);


select cust.cus_gender , count(cust.cus_gender) as count from customer cust inner join
`order` on cust.cus_id = `order`.cus_id where `order`.ord_amount >= 3000 group by cust.cus_gender;

select `order`.*, product.pro_name from `order`, product_details, product
where `order`.cus_id = 2
and `order`.prod_id = product_details.prod_id and product_details.prod_id = product.pro_id;

select supplier.* from supplier, product_details where supplier.supp_id in
(select product_details.supp_id from product_details group by product_details.supp_id 
having count(product_details.supp_id) > 1) group by supplier.supp_id;

select category.* from `order` inner join product_details on 
`order`.prod_id = product_details.prod_id
inner join product on product.pro_id = product_details.pro_id
inner join category on category.cat_id = product.cat_id
order by `order`.ORD_AMOUNT limit 1;

select product.pro_id, product.pro_name from `order` inner join product_details on 
`order`.prod_id = product_details.prod_id inner join product on product.pro_id = product_details.pro_id
where `order`.ord_date > '2021-10-05';

select cust.cus_name, cust.cus_gender from customer cust where cust.CUS_NAME like 'A%' or cust.CUS_NAME like '%A';

select supplier.supp_id, supplier.supp_name, rating.rat_ratstars,
case
when rating.rat_ratstars > 4 then 'Genuine Supplier'
when rating.rat_ratstars > 2 then 'Average Supplier'
else 'Supplier should not be considered'
end as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;

call new_procedure()
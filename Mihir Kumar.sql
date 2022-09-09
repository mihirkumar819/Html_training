create table tbl_cust
(
cust_id number(25) not null,
cust_name varchar(200) not null,
cust_address varchar(500) not null);
alter table tbl_cust
    add(constraint pk_cust primary key(cust_id));

create table tbl_items
(
item_id number (25) not null,
item_desc varchar2(200) not null,
item_price number (30,2) not null);

alter table tbl_items
    add(constraint pk_items primary key(item_id));

create table tbl_orders
(
order_id number(25) not null,
order_date date not null,
cust_id number(25) not null);

alter table tbl_orders
    add(constraint pk_orders primary key(order_id),
        constraint fk1_orders foreign key (cust_id)
            references tbl_cust(cust_id));
            
create table tbl_orders_items
(
  order_id number(25) not null,
  item_id number(25) not null,
  item_qty number(10) not null );
 alter table tbl_orders_items
    add(constraint fk1_order_items foreign key(order_id)
         references tbl_orders(order_id),
        constraint fk2_order_items foreign key(item_id)
           references tbl_items(item_id));
select * from tbl_orders;  
select * from tbl_orders_items;
select * from tbl_items;
select * from tbl_cust;


insert into tbl_cust(cust_id,cust_name,cust_address) values(1,'santosh','Btm lyout');
insert into tbl_cust(cust_id,cust_name,cust_address) values(2,'srinivasan','jp nagar');
insert into tbl_cust(cust_id,cust_name,cust_address) values(3,'geetha','mg road');
insert into tbl_cust(cust_id,cust_name,cust_address) values(4,'vijay','kanakpura');
commit;
select * from tbl_cust;

insert into tbl_items(item_id,item_desc,item_price) values(1,'shirt',999 );
insert into tbl_items(item_id,item_desc,item_price) values(2,'Trouser',1499);
insert into tbl_items(item_id,item_desc,item_price) values(3,'t-shit',699);
insert into tbl_items(item_id,item_desc,item_price) values(4,'tie',890);
commit;

insert into tbl_orders(order_id,order_date,cust_id) values(1,'12-jan-2017',1);
insert into tbl_orders(order_id,order_date,cust_id) values(2,'27-jan-2017',2);
insert into tbl_orders(order_id,order_date,cust_id) values(3,'21-feb-2017',3);
insert into tbl_orders(order_id,order_date,cust_id) values(4,'16-feb-2017',1);
insert into tbl_orders(order_id,order_date,cust_id) values(5,'09-mar-2017',4);
insert into tbl_orders(order_id,order_date,cust_id) values(6,'18-feb-2017',2);
insert into tbl_orders(order_id,order_date,cust_id) values(7,'15-jan-2017',4);

commit;
select * from tbl_orders;

insert into tbl_orders_items(order_id,item_id,item_qty) values(1,1,2);
insert into tbl_orders_items(order_id,item_id,item_qty) values(1,2,1);
insert into tbl_orders_items(order_id,item_id,item_qty) values(2,4,1);
insert into tbl_orders_items(order_id,item_id,item_qty) values(3,3,3);
insert into tbl_orders_items(order_id,item_id,item_qty) values(7,1,4);
insert into tbl_orders_items(order_id,item_id,item_qty) values(7,2,2);
commit;
select * from tbl_orders_items;

--Get the list of items with price for an entered order id

select toi.order_id, toi.item_qty,ti.item_price,toi.item_qty*ti.item_price as amount
from tbl_orders_items toi,tbl_items ti
where toi.item_id=ti.item_id
and toi.order_id=&p_order_id;


--2nd queries.........

select ti.item_price*toi.item_qty as amount,to_char(tor.order_date,'Mon-yyyy')
as mon_year from tbl_items ti,tbl_orders_items toi,tbl_orders tor 
where ti.item_id=toi.item_id
and tor.order_id=toi.order_id;


--3rd Queries.........

select ti.item_price*toi.item_qty as amount
from tbl_items ti,tbl_orders_items toi,tbl_orders tor 
where ti.item_id=toi.item_id
and tor.order_id=toi.order_id;

-- 3rd queries................


select sql.amount amount,sql.order_id order_id, sql.cust_name cust_name,
Case
when sql.amount between 200 and 400 then ((5*sql.amount)/100)
when sql.amount>400 then  ((10*sql.amount) /100)
end as discount
from (select toi.order_id, tc.cust_name, to1.item_qty*ti.item_price as amount
from tbl_cust tc,
tbl items_ti,
tbl_order_items tol,
tbl_orders tor
where tor.order_id =to1.order_id
and
tc.cust_id=tor.cust_id
and t1.item_id=to1.item_id)sql
group by amount, order_id, cust_name;



select sql.order_id,sql.cust_name,sum(sql.amount) amount,
     case when sum(sql.amount)>=2000 and sum(sql.amount)<=4000
    then sum(sql.amount)-sum(sql.amount)*0.05
    when sum(sql.amount > 4000 then sum(sql.amount)-sum(sql.amount)*0.1
    else
    sum(sql.amount)
  end as disc_price 
  from
  (select tor.order_id,tc.cust_name,ti.item_price*toi.item_qty as amount
  from tbl_orders tor, tbl_items ti,tbl_order_items toi,
  tbl_cust tc
   where tor.order_id=toi.order_id
   and ti.item_id=toi.item_id
   and tc.cust_id= tor.cust_id)sql;


 














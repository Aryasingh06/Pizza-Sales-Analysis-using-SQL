create database pizzahut;


create table orders (
order_id int not null,
order_dare date not null,
order_time time not null,
primary key(order_id) );

ALTER TABLE orders RENAME COLUMN order_dare TO order_date;

create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id) );




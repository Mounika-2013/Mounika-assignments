drop table if exists products;
create table products(
	product_id serial,
	product_name varchar(50),
	price decimal,
	primary key(product_id)
);

drop table if exists orders;
create table orders(
	order_id serial,
	product_id integer,
	amount integer,
	primary key(order_id)
	--foreign key(product_id) references products(product_id)
);
insert into products(product_name, price) values
	('Burger', '5.00'),
	('Drink', '1.00'),
	('Chicken Tenders', '6.00'),
	('Fries', '1.50')
;
insert into orders(product_id, amount) values
	(1, 4), 
	(2, 2),
	(3, 7),
	(1, 3),
	(1, 2),
	(3, 4),
	(5, 1)
;
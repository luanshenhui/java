create database t_computer
drop database computer
use t_computer
create table t_computer(
	t_name varchar(20) primary key,
	t_descript varchar(100) not null,
	t_price double(10,2) not null
)
drop table t_computer;

create table t_computer_cart(
	t_name varchar(20),
	t_price double(10,2),
	t_num double(10,2) not null
)

drop table t_computer_cart

select * from t_computer_cart
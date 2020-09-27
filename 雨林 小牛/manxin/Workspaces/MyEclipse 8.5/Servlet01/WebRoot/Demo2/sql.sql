create database demo2;
use demo2;
drop table t_user if exists d_user;
create table d_user(
	d_id int(6) not null auto_increment,
	d_name varchar(10),
	d_pwd varchar(20),
	d_age int(4),
	d_salary double,
	PRIMARY KEY (d_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
alter table d_user auto_increment = 1001;

insert into d_user values(null,'张三','1234',12,1000);

select * from d_user;
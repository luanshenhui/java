drop table t_User;
create table t_User(
	u_loginId varchar2(100) primary key,
	u_pwd varchar2(100) not null,
	u_name varchar2(100) not null, 
	u_salary number(5) not null,
	u_age number(3) not null
);
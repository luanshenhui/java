drop table t_User;
create table t_User(
	u_loginId varchar2(100) primary key,
	u_pwd varchar2(100) not null,
	u_name varchar2(100) not null,
	u_sex varchar2(10) not null,
	u_age number(3) not null,
	u_email varchar2(100) not null,
	u_phone varchar2(20) not null,
	u_city varchar2(20) not null
);
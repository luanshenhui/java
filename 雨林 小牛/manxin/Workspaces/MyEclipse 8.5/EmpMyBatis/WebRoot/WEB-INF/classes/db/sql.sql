drop table jsp_User;
create database jsp_User
create table jsp_User(
	u_loginId varchar(100) primary key,
	u_pwd varchar(100) not null,
	u_name varchar(20) not null,
	u_salary int not null,
	u_age int not null
);
select * from jsp_User

insert into jsp_User values('1001','1234','aaaa',1000,22);
insert into jsp_User values('1002','1234','bbbb',1000,22);
insert into jsp_User values('1003','1234','cccc',1000,22);
insert into jsp_User values('1004','1234','dddd',1000,22);
insert into jsp_User values('1005','1234','eeee',1000,22);
insert into jsp_User values('1006','1234','ffff',1000,22);
insert into jsp_User values('1007','1234','gggg',1000,22);
insert into jsp_User values('1013','1234','gggg',2000,22);
insert into jsp_User values('1014','1234','gggg',2000,22);

select * from jsp_User;

select * from jsp_User where u_salary in(1000)
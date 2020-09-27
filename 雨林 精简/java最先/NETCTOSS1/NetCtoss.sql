
create table admin_role4 (
admin_id number(11),
role_id number(11)
);
insert into admin_role values(1002,1);
insert into admin_role values(1002,44);
insert into admin_role values(1002,21);
insert into admin_role values(1003,1);
insert into admin_role values(1003,21);
commit;
DROP TABLE ADMIN_INFO;
CREATE TABLE ADMIN_INFO(
  ID NUMBER(11) CONSTRAINT ADMIN_INFO_ID_PK PRIMARY KEY,
  ADMIN_CODE VARCHAR2(30)  UNIQUE　NOT NULL,
  PASSWORD  VARCHAR2(30) NOT NULL,
  NAME VARCHAR2(30) NOT NULL,
  TELEPHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  ENROLLDATE DATE NOT NULL
  );
  SELECT *FROM ADMIN_INFO;
insert into admin_info
values(1002,'1001_syl','syl123','lily','13688997766',
'shiyl@sin.com',to_date('2013-05-22','yyyy-mm-dd'));
insert into admin_info
 values(1001,'admin','111111','lily','13688997766','shiyl@sin.com'
,to_date('2013-05-22','yyyy-mm-dd'));
drop table account cascade constraints purge;

create table account(
id number(9) primary key,
recommender_id number(9),
login_name varchar2(30) unique not null,
login_passwd varchar2(30)  not null,
status char check (status in(0,1,2)) ,
create_date date,
pause_date date,
close_date date,
real_name varchar(20) not null,
idcard_no char(18) unique not null,
birthdate date,
gender char check(gender in(0,1)),
occupation varchar2(50),
telephone varchar2(15),
email varchar2(50),
mailaddress varchar2(50),
zipcode char(6),
qq varchar2(15),
last_login_time date,
last_login_ip varchar2(15),
constraint account_recommender_id_fk foreign key(recommender_id) references account(id)
);

Insert into account(ID,RECOMMENDER_ID,LOGIN_NAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,REAL_NAME,IDCARD_NO,BIRTHDATE,GENDER,OCCUPATION,TELEPHONE,EMAIL,MAILADDRESS,ZIPCODE,QQ,LAST_LOGIN_TIME,LAST_LOGIN_IP) values (1005,null,'taiji001','256528','1',to_date('2008-03-15 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,'zhangsanfeng','410381194302256528',to_date('1943-02-25 00:00:00','yyyy-mm-dd hh24:mi:ss'),'1',null,'13669351234',null,null,null,null,null,null);
Insert into account(ID,RECOMMENDER_ID,LOGIN_NAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,REAL_NAME,IDCARD_NO,BIRTHDATE,GENDER,OCCUPATION,TELEPHONE,EMAIL,MAILADDRESS,ZIPCODE,QQ,LAST_LOGIN_TIME,LAST_LOGIN_IP) values (1010,null,'xl18z60','190613','1',to_date('2009-01-10 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,'guojing','330682196903190613',to_date('1969-03-19 00:00:00','yyyy-mm-dd hh24:mi:ss'),'1',null,'13338924567',null,null,null,null,null,null);
Insert into account(ID,RECOMMENDER_ID,LOGIN_NAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,REAL_NAME,IDCARD_NO,BIRTHDATE,GENDER,OCCUPATION,TELEPHONE,EMAIL,MAILADDRESS,ZIPCODE,QQ,LAST_LOGIN_TIME,LAST_LOGIN_IP) values (1011,1010,'dgbf70','270429','1',to_date('2009-03-01 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,'huangrong','330902197108270429',to_date('1971-08-27 00:00:00','yyyy-mm-dd hh24:mi:ss'),'0',null,'13637811357',null,null,null,null,null,null);
Insert into account(ID,RECOMMENDER_ID,LOGIN_NAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,REAL_NAME,IDCARD_NO,BIRTHDATE,GENDER,OCCUPATION,TELEPHONE,EMAIL,MAILADDRESS,ZIPCODE,QQ,LAST_LOGIN_TIME,LAST_LOGIN_IP) values (1015,1005,'mjjzh64','041115','1',to_date('2010-03-12 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,'zhangwuji','610121198906041115',to_date('1989-06-04 00:00:00','yyyy-mm-dd hh24:mi:ss'),'1',null,'13572952468',null,null,null,null,null,null);
Insert into account(ID,RECOMMENDER_ID,LOGIN_NAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,REAL_NAME,IDCARD_NO,BIRTHDATE,GENDER,OCCUPATION,TELEPHONE,EMAIL,MAILADDRESS,ZIPCODE,QQ,LAST_LOGIN_TIME,LAST_LOGIN_IP) values (1018,1011,'jmdxj00','010322','1',to_date('2011-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,'guofurong','350581200201010322',to_date('1996-01-01 03:22:00','yyyy-mm-dd hh24:mi:ss'),'0',null,'18617832562',null,null,null,null,null,null);
Insert into account(ID,RECOMMENDER_ID,LOGIN_NAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,REAL_NAME,IDCARD_NO,BIRTHDATE,GENDER,OCCUPATION,TELEPHONE,EMAIL,MAILADDRESS,ZIPCODE,QQ,LAST_LOGIN_TIME,LAST_LOGIN_IP) values (1019,1011,'ljxj90','310346','1',to_date('2012-02-01 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,'luwushuang','320211199307310346',to_date('1993-07-31 00:00:00','yyyy-mm-dd hh24:mi:ss'),'0',null,'13186454984',null,null,null,null,null,null);
Insert into account(ID,RECOMMENDER_ID,LOGIN_NAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,REAL_NAME,IDCARD_NO,BIRTHDATE,GENDER,OCCUPATION,TELEPHONE,EMAIL,MAILADDRESS,ZIPCODE,QQ,LAST_LOGIN_TIME,LAST_LOGIN_IP) values (1020,null,'kxhxd20','012115','1',to_date('2012-02-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,'weixiaobao','321022200010012115',to_date('2000-10-01 00:00:00','yyyy-mm-dd hh24:mi:ss'),'1',null,'13953410078',null,null,null,null,null,null);
commit;

drop table cost cascade constraints purge;
create table cost(
id number(4) primary key,
name varchar2(50) not null,
base_duration number(11),
base_cost number(7,2),
unit_cost number(7,4),
status char  check (status in(0,1)),
descr varchar2(100),
creatime date default sysdate,
startime date,
cost_type char
);
Insert into cost(ID,NAME,BASE_DURATION,BASE_COST,UNIT_COST,STATUS,DESCR,CREATIME,STARTIME,COST_TYPE) values (1,'5.9元套餐',20,5.9,0.4,'0','5.9元20小时/月,超出部分0.4元/时',to_date('2013-09-03 23:27:28','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into cost(ID,NAME,BASE_DURATION,BASE_COST,UNIT_COST,STATUS,DESCR,CREATIME,STARTIME,COST_TYPE) values (2,'6.9元套餐',40,6.9,0.3,'0','6.9元40小时/月,超出部分0.3元/时',to_date('2013-09-03 23:27:28','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into cost(ID,NAME,BASE_DURATION,BASE_COST,UNIT_COST,STATUS,DESCR,CREATIME,STARTIME,COST_TYPE) values (3,'8.5元套餐',100,8.5,0.2,'0','8.5元100小时/月,超出部分0.2元/时',to_date('2013-09-03 23:27:28','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into cost(ID,NAME,BASE_DURATION,BASE_COST,UNIT_COST,STATUS,DESCR,CREATIME,STARTIME,COST_TYPE) values (4,'10.5元套餐',200,10.5,0.1,'0','10.5元200小时/月,超出部分0.1元/时',to_date('2013-09-03 23:27:28','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into cost(ID,NAME,BASE_DURATION,BASE_COST,UNIT_COST,STATUS,DESCR,CREATIME,STARTIME,COST_TYPE) values (5,'计时收费',null,null,0.5,'0','0.5元/时,不使用不收费',to_date('2013-09-03 23:27:28','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into cost(ID,NAME,BASE_DURATION,BASE_COST,UNIT_COST,STATUS,DESCR,CREATIME,STARTIME,COST_TYPE) values (6,'包月',null,20,null,'0','每月20元,不限制使用时间',to_date('2013-09-03 23:27:28','yyyy-mm-dd hh24:mi:ss'),null,null);
commit;

drop table service cascade constraints purge;
create table service(
id number(10) primary key,
account_id  number(9) not null,
unix_host varchar2(15) not null,
os_username varchar2(8) not null,
login_passwd varchar2(8) not null,
status char check (status in(0,1)),
create_date date,
pause_date date,
close_date date,
cost_id number(4) not null,
constraint service_aid_fk foreign key(account_id) 
references account(id),

constraint service_cid_fk foreign key(cost_id) 
references cost(id),

constraint service_uhostosname_uk 
unique(unix_host,os_username)
);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2001,1010,'192.168.0.26','guojing','guo1234','0',to_date('2009-03-10 10:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,1);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2002,1011,'192.168.0.26','huangr','huang234','0',to_date('2009-03-01 15:30:05','yyyy-mm-dd hh24:mi:ss'),null,null,1);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2003,1011,'192.168.0.20','huangr','huang234','0',to_date('2009-03-01 15:30:10','yyyy-mm-dd hh24:mi:ss'),null,null,3);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2004,1011,'192.168.0.23','huangr','huang234','0',to_date('2009-03-01 15:30:15','yyyy-mm-dd hh24:mi:ss'),null,null,6);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2005,1019,'192.168.0.26','luwsh','luwu2345','0',to_date('2012-02-10 23:50:55','yyyy-mm-dd hh24:mi:ss'),null,null,4);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2006,1019,'192.168.0.20','luwsh','luwu2345','0',to_date('2012-02-10 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null,5);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2007,1020,'192.168.0.20','weixb','wei12345','0',to_date('2012-02-10 11:05:20','yyyy-mm-dd hh24:mi:ss'),null,null,6);
Insert into service(ID,ACCOUNT_ID,UNIX_HOST,OS_USERNAME,LOGIN_PASSWD,STATUS,CREATE_DATE,PAUSE_DATE,CLOSE_DATE,COST_ID) values (2008,1010,'192.168.0.20','guojing','guo09876','0',to_date('2012-02-11 12:05:21','yyyy-mm-dd hh24:mi:ss'),null,null,6);
commit;

drop table service_detail cascade constraints purge;
create table service_detail(
id number(11) primary key,
service_id number(10) references service(id) not null,
client_host varchar2(15),
os_username varchar2(8),
pid number(11),
login_time date,
logout_time date,
duration number(20,9),
cost number(20,6)
);
commit;

drop table role cascade constraints purge;
create table ROLE
(
  id   NUMBER primary key,
  name VARCHAR2(20)
);


insert into ROLE (id, name)
values (1, '系统管理员');
insert into ROLE (id, name)
values (43, 'w');
insert into ROLE (id, name)
values (44, 'a');
insert into ROLE (id, name)
values (21, 'jojo');
insert into ROLE (id, name)
values (41, 'qq1');
insert into ROLE (id, name)
values (42, 'qq1');
commit;

drop table ROLE_PRIVILEGE cascade constraints purge;
create table ROLE_PRIVILEGE
(
  role_id      NUMBER not null,
  privilege_id NUMBER not null
);
alter table ROLE_PRIVILEGE
  add constraint RP_PK primary key (ROLE_ID, PRIVILEGE_ID);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (1, 1);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (1, 2);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (1, 3);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (1, 4);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (1, 5);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (1, 6);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (1, 7);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (21, 2);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (41, 1);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (42, 1);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (43, 1);
insert into ROLE_PRIVILEGE (role_id, privilege_id)
values (44, 4);
commit;


create index reco_id 
on account(recommender_id);

create index rname
on account(real_name);

create index aid
on service(account_id);

create index cid
on service(cost_id);

create index serid
on service_detail(service_id);

create sequence account_id start with 1021;
create sequence admin_seq start with 1003;
create sequence cost_id start with 10;
create sequence service_id_seq start with 2010;
create sequence role_id_seq start with 100;
create sequence service_bak_id_seq;

create table SERVICE_UPDATE_BAK(
ID number(9) primary key,
SERVICE_ID number(9),
UNIX_HOST varchar2(15),
OS_USERNAME varchar2(8),
COST_ID number(4),
CREAT_TIME date
);

create sequence service_bak_id_seq;
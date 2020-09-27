--创建表空间、创建用户、授权用户
create tablespace zhaoyang datafile 'zhaoyang.dbf' size 10m;
create user zhao identified by "zhao" default tablespace zhaoyang;
grant dba to zhao with admin option;



--(1)用户表
create table person(
  id number(10) primary key,--主键
  username varchar2(255) not null,--用户
  password varchar2(255) not null,--口令
  sex char(3),--性别
  age number(3),--年龄
  email varchar2(50) unique,--邮箱
  phone number(11) unique,--移动电话
  salary number(9,2)—薪资
);
insert into person values(1, 'jack','123456','男',26,'jack@163.com',13012345678, 345612.5);
insert into person values(2, '张三','123456','女',31,'zhangsan@163.com',13098762222,9834.2);
insert into person values(3, '李四','123456','男',29,'lisi@163.com',13011115678,100000);
commit;



--(2)类别表
create table category (
	id number(10) primary key,
	code varchar2(10) unique,
	name varchar2(50),
	info varchar2(200)
);
insert into category values(1, '101', '笔记本', '笔记本电脑');
insert into category values(2, '102', '手机', '智能手机');
insert into category values(3, '103', '冰箱', '冰箱描述');
commit;



--(3)商品表
create table product(
	id number(10) primary key,
	cid number(10) references category(id),
	code varchar2(10) unique,
	name varchar2(50),
	price number(10,2),
	info varchar2(100)
);
insert into product values(1, '1','1001','HP',4000,'HP笔记本电脑');
insert into product values(2, '1','1002','IBM',4500,'IBM笔记本电脑');
insert into product values(3, '2','1003','三星',4000,'三星韩国');
insert into product values(4, '2','1004','索爱',6500,'索爱手机');
insert into product values(5, '3','1005','海尔',4000,'国产');
insert into product values(6, '3','1006','小天鹅',6500,'国产');
commit;



--(4)供应商表
create table supplier(
	  id number(10) primary key,
	  name varchar2(50),
	  address varchar2(50),
	  linkman varchar2(50),
	  phone varchar2(50),
	  bank varchar2(50),
	  account varchar2(50)
);
insert into supplier values(1, '广发物流','大连','李峰','13067881238','工商银行','985312345987734');
insert into supplier values(2, '财富货运','大连','孙俪','13010903645','建设银行','1687682345987734');
insert into supplier values(3, '火车站','大连','刘飞','13089672312','民生银行','78912345987734');
commit;



--(5)客户表
create table client(
	  id number(10) primary key,
	  name varchar2(50),
	  address varchar2(50),
	  linkman varchar2(50),
	  phone varchar2(50),
	  bank varchar2(50),
	  account varchar2(50)
);
insert into client values(1, '天宇集团','大连','李先生','13012341238','工商银行','985312345987734');
insert into client values(2, '发财','瓦房店','孙先生','13023653645','建设银行','1687682345987734');
insert into client values(3, '通宝','普兰店','朱晓','1303454545','民生银行','78912345987734');
commit;



--(6)进货表(进)
create table stock(
	id number(10) primary key,
	personid number(10) references person(id),
	productcode varchar2(10) references product(code),
	stockdate varchar2(50),
	stockmount number(6),
	moneysum number(9,2)
);



--(7)销售表(销)
create table sell(
	id number(10) primary key,
	personid number(10) references person(id),
	productcode varchar2(10) references product(code),
	selldate varchar2(50),
	sellmount number(6),
	moneysum number(9,2)
);



--(8)库存表(存)
create table repertory(
  id number(10) primary key,
  productcode varchar2(10) references product(code),
  storage number(6)
);



--(9)角色表(存)
create table roleaction(
id number(10) primary key,
rolename varchar2(20) not null,
personid number(10) references person(id)
);
insert into roleaction values(1,'管理员',4);
insert into roleaction values(2,'操作员',26);
insert into roleaction values(3,'操作员',105);
insert into roleaction values(4,'操作员',106);
commit;

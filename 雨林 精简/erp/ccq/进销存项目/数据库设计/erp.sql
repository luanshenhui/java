--������ռ䡢�����û�����Ȩ�û�
create tablespace zhaoyang datafile 'zhaoyang.dbf' size 10m;
create user zhao identified by "zhao" default tablespace zhaoyang;
grant dba to zhao with admin option;



--(1)�û���
create table person(
  id number(10) primary key,--����
  username varchar2(255) not null,--�û�
  password varchar2(255) not null,--����
  sex char(3),--�Ա�
  age number(3),--����
  email varchar2(50) unique,--����
  phone number(11) unique,--�ƶ��绰
  salary number(9,2)��н��
);
insert into person values(1, 'jack','123456','��',26,'jack@163.com',13012345678, 345612.5);
insert into person values(2, '����','123456','Ů',31,'zhangsan@163.com',13098762222,9834.2);
insert into person values(3, '����','123456','��',29,'lisi@163.com',13011115678,100000);
commit;



--(2)����
create table category (
	id number(10) primary key,
	code varchar2(10) unique,
	name varchar2(50),
	info varchar2(200)
);
insert into category values(1, '101', '�ʼǱ�', '�ʼǱ�����');
insert into category values(2, '102', '�ֻ�', '�����ֻ�');
insert into category values(3, '103', '����', '��������');
commit;



--(3)��Ʒ��
create table product(
	id number(10) primary key,
	cid number(10) references category(id),
	code varchar2(10) unique,
	name varchar2(50),
	price number(10,2),
	info varchar2(100)
);
insert into product values(1, '1','1001','HP',4000,'HP�ʼǱ�����');
insert into product values(2, '1','1002','IBM',4500,'IBM�ʼǱ�����');
insert into product values(3, '2','1003','����',4000,'���Ǻ���');
insert into product values(4, '2','1004','����',6500,'�����ֻ�');
insert into product values(5, '3','1005','����',4000,'����');
insert into product values(6, '3','1006','С���',6500,'����');
commit;



--(4)��Ӧ�̱�
create table supplier(
	  id number(10) primary key,
	  name varchar2(50),
	  address varchar2(50),
	  linkman varchar2(50),
	  phone varchar2(50),
	  bank varchar2(50),
	  account varchar2(50)
);
insert into supplier values(1, '�㷢����','����','���','13067881238','��������','985312345987734');
insert into supplier values(2, '�Ƹ�����','����','��ٳ','13010903645','��������','1687682345987734');
insert into supplier values(3, '��վ','����','����','13089672312','��������','78912345987734');
commit;



--(5)�ͻ���
create table client(
	  id number(10) primary key,
	  name varchar2(50),
	  address varchar2(50),
	  linkman varchar2(50),
	  phone varchar2(50),
	  bank varchar2(50),
	  account varchar2(50)
);
insert into client values(1, '�����','����','������','13012341238','��������','985312345987734');
insert into client values(2, '����','�߷���','������','13023653645','��������','1687682345987734');
insert into client values(3, 'ͨ��','������','����','1303454545','��������','78912345987734');
commit;



--(6)������(��)
create table stock(
	id number(10) primary key,
	personid number(10) references person(id),
	productcode varchar2(10) references product(code),
	stockdate varchar2(50),
	stockmount number(6),
	moneysum number(9,2)
);



--(7)���۱�(��)
create table sell(
	id number(10) primary key,
	personid number(10) references person(id),
	productcode varchar2(10) references product(code),
	selldate varchar2(50),
	sellmount number(6),
	moneysum number(9,2)
);



--(8)����(��)
create table repertory(
  id number(10) primary key,
  productcode varchar2(10) references product(code),
  storage number(6)
);



--(9)��ɫ��(��)
create table roleaction(
id number(10) primary key,
rolename varchar2(20) not null,
personid number(10) references person(id)
);
insert into roleaction values(1,'����Ա',4);
insert into roleaction values(2,'����Ա',26);
insert into roleaction values(3,'����Ա',105);
insert into roleaction values(4,'����Ա',106);
commit;

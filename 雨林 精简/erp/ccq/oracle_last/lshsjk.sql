select*from cat;
--(1)��system��½��ϵͳ��ռ�
--(2)������ռ�
--��ռ��������t1 ,�����ļ���t1.dbf ,Ĭ�ϴ�С10��
create tablespace t1 datafile 't1.dbf' size 10m;
--(3)�����µ��û�
--����a1����û���������123 ������ı�ռ���t1
create user a1 identified by "123" default tablespace t1;
--(4)�޸Ŀ���
alter user a1 identified by "abc";
--(5)��Ȩ
--�����ݿ����Ա��Ȩ�������û�a1
--withǰ��dba�ѹ���ԱȨ�޸�a1��with��������a1��Ȩ�޸�����
grant dba to a1 with admin option;
select * from cat;
--(6)ע��,�˳�,�����û���½
--(7)������
--varchar2�Ǳ䳤���ַ�����number���������ͣ����
create table person (
name varchar2(20),
age number(2)
);
--(8)ɾ����
drop table person;
--(9)��ջ���վ
purge recyclebin;
--(10)ɾ����ռ�t1  including(����) contents(����) datafiles(�����ļ�)
drop tablespace qq1 including contents and datafiles;
--(11)ɾ���û�a1
drop user a1;

--(1)������
create table person(
id number(5)primary key,--������Ψһ��ʾһ����¼
name varchar2(20) not null,--����Ϊ��
age number(2),
dep varchar2(20),
salary number (8,2)
);

--(2)insert ��Ӽ�¼
--(2.1)insert���1��(ȫ������)
insert into person values (1,'����',30,'�г���',5000.5);
insert into person values (2,'����',40,'������',6800.5);
insert into person values (3,'����',50,'���Բ�',4300.5);
insert into person values (5,'����',60,'���ڲ�',1210.05);
--�ύ  ���ǰѻ��浱�е�������ӵ����ݿ��� 
commit;
--(2.2)insert���2��(ָ���ֶβ���)
insert into person(id,name,age)values(6,'����',60);--�������˳����Ի�
insert into person (id,name)values(7,'����');
insert into person (id,name)values(8,'����');
select * from person;

--(3)update �޸ļ�¼
--ע�⣬update���ͨ��Ҫָ��where�������������м�¼���޸�
update person set age=33,salary=salary-5000 where id=4;
--һ��Ҫ�ύ�ڲ鿴  set(�޸�)
update person set age=70,salary=7000,dep='���Բ�'where id=7;
update person set age=age+1;
update person set salary=6000where age=60;

--(4)ɾ�� delete ���
delete from person where id=4;
delete from person where name='����';
delete from person where salary is null;
update person set salary=3300 where dep='���Բ�';



create table ls(
id number(5)primary key,--������Ψһ��ʾһ����¼
name varchar2(20) not null,--����Ϊ��
age number(2),
dep varchar2(20),
salary number (8,2)
);
select*from ls;
drop table ls;

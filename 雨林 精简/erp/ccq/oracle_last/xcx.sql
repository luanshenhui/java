select * from person;
select * from cat;
--(1)��system��½��ϵͳ��ռ�
--(2)������ռ�
--��ռ��������t1  �����ļ���t1.dbf  Ĭ�ϴ�С10��
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
--(6)�����û���½,ע��,�˳�
--(7)������
--varchar2�Ǳ䳤���ַ�����number���������ͣ����
create table person(name varchar2(20), age number(2));
--(8)ɾ����
drop table person;
--(9)��ջ���վ
purge recyclebin;
--(10)ɾ����ռ�t1  including(����) content(����) datafiles()
drop tablespace t1 including contents and datafiles;
--(11)ɾ���û�a1
drop user a1;

create tablespace t11 datafile 'qq1.dbf' size 5m;
create user lsh identified by "000" default tablespace t11;
grant dba to lsh with admin option;

create table jap(
 name varchar2(20),
 age number(2)
);

alter user lsh identified by "lsh";

drop table jap;
purge recyclebin;

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
---------------------------------------------------------------------------
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
insert into person values (5,'����',60,'���ڲ�',3210.05);
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
update person set salary=6000 where age=60;

--(4)ɾ�� delete ���
delete from person where id=4;
delete from person where name='����';
delete from person where salary is null;
update person set salary=3300 where dep='���Բ�';



create table member(
id number(5)primary key,--������Ψһ��ʾһ����¼
name varchar2(20) not null,--����Ϊ��
sex varchar2(20),
salary number (8,2),
depaptment varchar2(20)
);


select * from member;
insert into member values (1,'С��','��','1500','�г���');
insert into member values (2,'С��','Ů','1800','���۲�');
insert into member values (3,'С��','��','2300','������');
insert into member values (4,'С��','Ů','2000','����');
insert into member values (5,'С��','��','3500','�г���');
insert into member values (6,'�⹤','Ů','4500','������');
insert into member values (7,'С��','��','2600','������');
insert into member values (8,'�Ϻ�','��','7500','������');
insert into member values (9,'С��','��','10000','����');

update member set name='С��',salary=3500 where id=5;

--select��ѯ����ʽ
--1)select:���Ը�   *��ָ���У������У�����
--2)from: ����������
--3)where�������Ӿ�
--        �Ƚ������(>,>=,<,<=,=,(!=,<>))
--        �߼������(�߼���and����or����not)
--        ���������(between and,in,like,null)
--4)group by:����(avg��max��min��count)
--5)having�������
--6)order by������(asc��desc)

--(1)select �Ӿ�
--*��ʾ��ѯ������
select * from member;
--ָ������
select name,salary from member;
--����
select name ����,salary ���� from member;
--������
select name,(salary+100) ���� from member;

--(2)from�Ӿ�
--����
select * from member;
--����
select m.name,m.sex,m.salary--û��m���淶(��������Ҳ����member.salary)
from member m

--(3.1)where�Ӿ䣻�Ա���ÿһ�����ɽ���ɸѡ���ˣ������Ӿ�
--�Ƚ������(>,>=,<,<=,=,(!=,<>))
select * from member where salary>2000;
select * from member where salary<>2000;

--(3.2)�߼������(�߼���and����or����not)
--and
select * from member where sex='��' and salary >=2500 and depaptment='�г���';
--or
select *
from member
where salary>2200 or depaptment='�г���';
--not
update member set sex=null where id=1;
select * 
from member where sex is null;
--�ж�nullҪ��is�ؼ��֣����ܲ���Ƚ������
select * 
from member where sex is not null;

--(3.3)���������(between and��in��like��null)
--between and �����ڼ䣬�����߽�ֵ
select *
from member
where salary between 2300 and 3500;

select *
from member
where salary >=2300 and salary<=3500;

--in��������ֵ
select *
from member 
where salary not in(1800,3500,7500);

select *
from member
where salary not between 2300 and 3500;

--like ģ����ѯ
--ƥ���:_ƥ�������һ���ַ�,%ƥ����������ַ�
select *
from member
where name like'С_'

select *
from member
where depaptment like'��__'

select *
from member
where depaptment like'��%'

select *
from member
where depaptment like'%��_';

select *
from member
where depaptment like'%��%'

--null

--(4)group by����(ͨ��������������)
--���⣺ʹ��group by����ʱ��
--select��߱���ʱ���������������ʱ�����ͳ�ƾۺϺ�����
select sex
from member 
group by sex;
--max min �������/Сֵ
select depaptment,max(salary) from member group by depaptment;
--avg ƽ��
select sex,avg(salary),max(salary),min(salary)
from member 
group by sex;

select sex,count(*)--count(*)����
from member
group by sex;

update member set sex ='Ů'where id=1;
select 

--(5)having ������й���
--��group by���ã�
select depaptment,avg(salary)
from member 
where depaptment !='������'
group by depaptment 
having avg(salary)>3000;

--(6)order by����(asc����desc��)
select *
from member
order by sex,salary desc;
--����order by A��Bdesc��C asc
--A����A��ͬ��B����AB��ͬ��C����

--���⣺group by A��B��C
--A��B��C��ͬ�ľ���һ��
select * from member
order by salary desc;

select depaptment,count(*)
from member 
group by depaptment;

commit;
select * from member;


select depaptment from member group by depaptment;

select depaptment,count(*) from member group by depaptment;

select depaptment,max(salary) from member group by depaptment;

select sex,count(*) from member group by sex;

select sex,avg(salary) from member group by sex;
--�ҳ��У�Ů����͵�Ա�� ����
select name,salary,sex from member
where salary in
(select min(salary)
from member
group by sex);


--������˾��
create table company(
id number(3)primary key,--������Ψһ��ʾһ����¼
name varchar2(20) not null--����Ϊ��
);
--��Ա��
create table employee(
id number(3)primary key,--������Ψһ��ʾһ����¼
name varchar2(20) not null,--����Ϊ��
salary number (8,2),
comid number (3)references company(id)--��˾id
);
commit;
select * from cat;
--��������
insert into company values(1,'IBM');
insert into company values(2,'HP');
select * from company;
insert into employee values(25,'����',5000,1);
insert into employee values(26,'����',4000,1);
insert into employee values(27,'����',4500,2);
select * from employee;

--(1)���������   �ѿ�����(A����M����¼��B����N����¼�����M*N����¼)
select *
from company c,employee e

--(2)���������ȷ����
--�����m�����ѯ��������Ҫָ��(m-1)�������е�����������ѿ�������
select c.name ��˾��,e.name Ա����
from company c,employee e
where c.id=e.comid;

drop table employee;

insert into company values(3,'Google');

insert into employee(id,name,salary) values (28,'����',3500);

select * from employee;
select * from company;

--(3)��������(�ڹ����е��ұ����(+))(ֻ��oracle��)
--��߲����������ļ�¼Ҳ��ʾ
select *
from company c,employee e
where c.id=e.comid(+);

--(4)��������
----�ұ߲����������ļ�¼Ҳ��
select *
from company c,employee e
where c.id(+)=e.comid;

--(5)������(�ȼ���������)(ͨ��)
select *
from company c left join employee e on c.id=e.comid;

--(6)������(�ȼ���������)
select *
from company c right join employee e on c.id=e.comid;

--(7)ȫ����(������+������)
select *
from company c full join employee e on c.id=e.comid;

--(8)������
select *
from company c inner join employee e on c.id=e.comid;--���������
--1��ѯIBM��Ա����Ϣ
select e.name
from company c,employee e
where c.id=e.comid and c.name='IBM';
--2��ѯ�������ڹ�˾��Ϣ
select c.name
from company c,employee e
where c.id=e.comid and e.name='����';
--3��ѯ������4000��Ա�����ֺ����ڹ�˾����
select e.name,c.name
from company c,employee e
where c.id=e.comid and salary='4000';
--4��ѯ�����Ա����Ϣ�Լ����ڹ�˾
select *
from company c,employee e
where c.id=e.comid and e.name like '��%';
--5��ѯIBM��HP���ҹ�˾��Ա����ƽ������
select c.name,avg(e.salary)
from company c,employee e
where c.id=e.comid and (c.name in('IBM','HP'))
group by c.name
having avg(e.salary)>3000
order by c.name;

select * from employee;
select * from company;
select * from member;

--�Ӳ�ѯ
--(1)select�Ӳ�ѯ(��select�����Ƕ��select���)
--(2)where�Ӳ�ѯ
--(3)from�Ӳ�ѯ

--1)select�Ӳ�ѯ
--ע�⣬��ѯ�Ľ�����뷵�ص�ֵ(һ��)
--�������ļҹ�˾��
select (select name from company where id=comid) ��˾��
from employee 
where name='����';

--2)where�Ӳ�ѯ
--2.1)�������ǵ�ֵ��
--��Ѷ����ƽ�����ʵ�Ա����Ϣ
select*
from member
where salary>(select avg(salary) from member);

--2.2)�����Ǽ��ϵ�
--��ѯIBM��HP��Ա����Ϣ
select *
from employee e
where comid in(select id from company where name='IBM' or name='HP');

--��ѯ��С����һ�����ŵ�Ա����Ϣ
select *
from member
where depaptment=(select depaptment from member where name='С��');

--3)from�Ӳ�ѯ(���Խ�from�Ӳ�ѯ�Ľ�����ɡ��������)û���κ�����
--��ѯ�������ڵĹ�˾��
--��ʵ�ʿ�����from�Ӳ�ѯ�õ����
select company.name,t1.n
from company,
(select comid c,name n 
from employee 
where name='����') t1
where company.id=t1.c;  

select *
from member 
where salary in (select min(salary) from member group by sex);

select m.*
from member m,
(select min(salary) s
from member group by sex) t
where m.salary=t.s;

--(1)rownumα��
--���ã���ҳ���ܣ�top-n����
--��⣺rownum��oracle��ȡ���ݵ�ͬʱ����ֵ,��1��ʼ,������1
select rownum,member.* from member where rownum = 1;
select rownum,member.* from member where rownum = 2;
select rownum,member.* from member;
--��ʵ�ʿ�����3��
--1,��������(where,group,having,order by)
--2,ʹ��rownumα��,�ڽ����Ļ���֮�����rownum
--3,top-n����,��ҳ����
select *
from
       (select t1.*,rownum r
                from
                (select *
                from member
                order by salary desc) t1) t2
where t2.r<=3;

--  ��ҳ���ܣ���3-7�ļ�¼
select *
from (select member.*,rownum r from member) t1
where t1.r between 3 and 7;

select*
from(select member.*,rownum r from member) t1
where t1.r=2;

---case���ʽ
create table stu(
id number(3)primary key,--������Ψһ��ʾһ����¼
name varchar2(20),--����Ϊ��
sub varchar2(20),
sco number (3)
);
insert into stu values(1,'����','����',80);
insert into stu values(2,'����','��ѧ',50);
insert into stu values(3,'����','Ӣ��',90);
insert into stu values(4,'����','����',40);
insert into stu values(5,'����','��ѧ',50);
insert into stu values(6,'����','Ӣ��',70);

select * from stu;
--���⣻��ѯstu Ҫ������+ 
����  ���� ��ѧ Ӣ��
����  80   50  90
--���ת��ʹ��case���ʽ
select name ����,
       sum(case when sub='����' then sco else 0 end) ����,--then�����ж��
       sum(case when sub='Ӣ��' then sco else 0 end) Ӣ��
from stu
group by name;
--ͳ�Ƹ��Ƶļ��������Ͳ���������
--------------------------------------------------------------------------------------
select sub ��Ŀ,
sum(case when sco>60 then 1 else 0 end) ����
from stu
group by sub;

select*
from(select member.*,rownum r from member order by salary) t1
where t1.salary=2;

(select depaptment,avg(salary)
from member
group by depaptment) t
where ;
------------------------------------------------------------------------
--1
create table student(
id number(3)primary key,--������Ψһ��ʾһ����¼
name varchar2(20),--����Ϊ��
age number(30),
sex varchar2(20),
ph varchar2(20),
edu varchar2(20)
);
drop table student;
insert into student values(1,'A',22,'��',123456,'Сѧ');
insert into student values(2,'B',21,'��',119,'��ѧ');
insert into student values(3,'C',23,'��',110,'����');
insert into student values(4,'D',18,'Ů',114,'��ѧ');
select * from student;
update student set edu='��ר' where ph like '11%';
commit;
delete from student where name like'C%'and sex='��';

select *
from student
where age<22 and edu='��ר';

select *
from
(select student.*,rownum r
from student) t1
where t1.r between 1 and 0.5*r;

select * from student order by age desc;

select sex,avg(age)
from student
group by sex;
--2
--2.1
create table member(
  id integer primary key,
  name varchar2(20),
  sex varchar2(20)��
  salary number(10,2),
  department varchar2(20)
);
drop table member;
insert into member values('1','С��','��',1500,'�г���');
insert into member values('2','С��','Ů',1800,'���۲�');
insert into member values('3','С��','��',2300,'������');
insert into member values('4','С��','Ů',2000,'����');
insert into member values('5','С��','��',3500,'�г���');
insert into member values('6','�⹤','Ů',4500,'������');
insert into member values('7','С��','��',2600,'������');
insert into member values('8','�Ϻ�','��',7500,'������');
insert into member values('9','�¸�','��',10000,'����');
select *from member;
--1
select department 
from member 
group by department;
--2
select department,count(*) 
from member 
group by department;
--3
select department,max(salary) 
from member 
group by department;
--4
select sex,count(*) 
from member 
group by sex;
--5
select sex,avg(salary) 
from member 
group by sex;
--6
select name,salary 
from member 
where salary in (select min(salary) from member group by sex);
--7

(select 
from member m,
(select sex,avg(salary) s from member group by sex ) t1
where m.sex=t1.sex and m.salary>t1.s) 

select sex,count(id)
from member group by sex

select sex,avg(salary),count(*)
from member 
group by sex

select*
from member 
where salary>(select sex,avg(salary),count(*)
from member group by sex)

--8
select *
from member m,
(select department,max(salary) s
from member 
group by department) t1
where m.salary=t1.s;


-----------
create table company(
id varchar2(10) primary key,
name varchar2(20)
);
drop table company;
drop table employee;
insert into company values('01','����ֹ�˾');
insert into company values('02','����ֹ�˾');
insert into company values('03','κ���ֹ�˾');
insert into company values('04','�����ķֹ�˾');


create table sales(
id varchar2(10) primary key,
name varchar2(20),
companyid varchar2(20)��
salesvolume number(10)
);

insert into sales values('1','����','01',10000);
insert into sales values('10','����','03',10500);
insert into sales values('11','����','05',18000);
insert into sales values('2','�ŷ�','01',11000);
insert into sales values('3','����','01',12000);
insert into sales values('4','��','01',9000);
insert into sales values('5','����','01',8500);
insert into sales values('6','����','02',5000);
insert into sales values('7','�Ƹ�','02',3000);
insert into sales values('8','��̩','03',6000);
insert into sales values('9','���','03',9500);

--1

select*
from company c,sales s
where c.id(+)=s.companyid;

--2
select c.name,count(*)
from company c,sales s
where c.id=s.companyid(+)
group by c.name;

--3
select c.name,sum(salesvolume)
from company c,sales s
where c.id=s.companyid(+)
group by c.name;
--4x

select c.name,s.name 
from company c,sales s
where s.salesvolume=(select max(salesvolume)from sales)and(c.id=s.companyid);

select s.name,c.name
from sales s,company c
where s.salesvolume=(select max(s.salesvolume)from sales s)and s.companyid=c.id;


select * from sales;
select * from company;

---------------
create table movie(
   ID VARCHAR2(50) not null primary key, 
   NAME VARCHAR2(500) 
);


 insert into movie ( ID, NAME ) values ( '1', 'ٻŮ�Ļ�' );
 insert into movie ( ID, NAME ) values ( '2', 'ɱ����' );
 insert into movie ( ID, NAME ) values ( '3', '��' );
 insert into movie ( ID, NAME ) values ( '4', '�߽�����ɽ' );
 insert into movie ( ID, NAME ) values ( '5', 'ǹ��' );
 insert into movie ( ID, NAME ) values ( '6', '��¥�»�' );
 
 
 create table tag(
   ID VARCHAR2(50) not null primary key, 
   NAME VARCHAR2(500) 
);


 insert into tag ( ID, NAME ) values ( '01', '����' );
 insert into tag ( ID, NAME ) values ( '02', '��װ' );
 insert into tag ( ID, NAME ) values ( '03', '�ִ�' );
 insert into tag ( ID, NAME ) values ( '04', '��Ƭ' );
 insert into tag ( ID, NAME ) values ( '05', 'ǹս' );
 insert into tag ( ID, NAME ) values ( '06', '����' );

 
 create table movie2tag(
   ID VARCHAR2(50) not null primary key, 
   movied VARCHAR2(500),
   tager VARCHAR2(500)    
   );

 insert into  movie2tag  values ( '001', '1','02');
 insert into  movie2tag  values ( '002', '1','04');
 insert into  movie2tag  values ( '003', '2','01' );
 insert into  movie2tag  values ( '004', '2','03' );
 insert into  movie2tag  values ( '005', '3','01' );
 insert into  movie2tag  values ( '006', '3','02');
 insert into  movie2tag  values ( '007', '4','01');
 insert into  movie2tag  values ( '008', '4','02');
 insert into  movie2tag  values ( '009', '4','06');
 insert into  movie2tag  values ( '0010', '5','03');
 insert into  movie2tag  values ( '0011', '5','05');
 insert into  movie2tag  values ( '0012', '5','06');
 insert into  movie2tag  values ( '0013', '6','04');
 insert into  movie2tag  values ( '0014', '6','06');

 select * from movie2tag; 
 select * from tag;
select * from movie;
commit;
select *
from tag t1,movie2tag m2
where t1.id=m2.id and t1.name='�߽�����ɽ';

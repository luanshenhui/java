select * from person;
select * from cat;
--(1)以system登陆到系统表空间
--(2)创建表空间
--表空间的名字是t1  数据文件是t1.dbf  默认大小10兆
create tablespace t1 datafile 't1.dbf' size 10m;
--(3)创建新的用户
--创建a1这个用户，密码是123 它分配的表空间是t1
create user a1 identified by "123" default tablespace t1;
--(4)修改口令
alter user a1 identified by "abc";
--(5)授权
--将数据库管理员的权限授予用户a1
--with前是dba把管理员权限给a1，with后是允许a1把权限给别人
grant dba to a1 with admin option;
select * from cat;
--(6)以新用户登陆,注销,退出
--(7)创建表
--varchar2是变长的字符串，number是数字类型，最常见
create table person(name varchar2(20), age number(2));
--(8)删除表
drop table person;
--(9)清空回收站
purge recyclebin;
--(10)删除表空间t1  including(包含) content(内容) datafiles()
drop tablespace t1 including contents and datafiles;
--(11)删除用户a1
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
--(1)以system登陆到系统表空间
--(2)创建表空间
--表空间的名字是t1 ,数据文件是t1.dbf ,默认大小10兆
create tablespace t1 datafile 't1.dbf' size 10m;
--(3)创建新的用户
--创建a1这个用户，密码是123 它分配的表空间是t1
create user a1 identified by "123" default tablespace t1;
--(4)修改口令
alter user a1 identified by "abc";
--(5)授权
--将数据库管理员的权限授予用户a1
--with前是dba把管理员权限给a1，with后是允许a1把权限给别人
grant dba to a1 with admin option;
select * from cat;
--(6)注销,退出,以新用户登陆
--(7)创建表
--varchar2是变长的字符串，number是数字类型，最常见
create table person (
name varchar2(20),
age number(2)
);
--(8)删除表
drop table person;
--(9)清空回收站
purge recyclebin;
--(10)删除表空间t1  including(包含) contents(内容) datafiles(数据文件)
drop tablespace qq1 including contents and datafiles;
--(11)删除用户a1
drop user a1;
---------------------------------------------------------------------------
--(1)创建表
create table person(
id number(5)primary key,--主键，唯一标示一条纪录
name varchar2(20) not null,--不能为空
age number(2),
dep varchar2(20),
salary number (8,2)
);

--(2)insert 添加记录
--(2.1)insert添加1：(全部插入)
insert into person values (1,'张三',30,'市场部',5000.5);
insert into person values (2,'李四',40,'开发部',6800.5);
insert into person values (3,'王五',50,'测试部',4300.5);
insert into person values (5,'赵六',60,'后勤部',3210.05);
--提交  才是把缓存当中的数据添加到数据库中 
commit;
--(2.2)insert添加2：(指定字段插入)
insert into person(id,name,age)values(6,'赵六',60);--括号里的顺序可以换
insert into person (id,name)values(7,'刘七');
insert into person (id,name)values(8,'王二');
select * from person;

--(3)update 修改记录
--注意，update语句通常要指定where条件。否则所有纪录做修改
update person set age=33,salary=salary-5000 where id=4;
--一定要提交在查看  set(修改)
update person set age=70,salary=7000,dep='测试部'where id=7;
update person set age=age+1;
update person set salary=6000 where age=60;

--(4)删除 delete 语句
delete from person where id=4;
delete from person where name='赵六';
delete from person where salary is null;
update person set salary=3300 where dep='测试部';



create table member(
id number(5)primary key,--主键，唯一标示一条纪录
name varchar2(20) not null,--不能为空
sex varchar2(20),
salary number (8,2),
depaptment varchar2(20)
);


select * from member;
insert into member values (1,'小王','男','1500','市场部');
insert into member values (2,'小李','女','1800','销售部');
insert into member values (3,'小刘','男','2300','生产部');
insert into member values (4,'小赵','女','2000','财务部');
insert into member values (5,'小雷','男','3500','市场部');
insert into member values (6,'吴工','女','4500','生产部');
insert into member values (7,'小孙','男','2600','生产部');
insert into member values (8,'老胡','男','7500','人力部');
insert into member values (9,'小王','男','10000','总务部');

update member set name='小雷',salary=3500 where id=5;

--select查询语句句式
--1)select:可以跟   *，指定列，计算列，别名
--2)from: 表名，别名
--3)where：条件子句
--        比较运算符(>,>=,<,<=,=,(!=,<>))
--        逻辑运算符(逻辑与and，或or，非not)
--        其他运算符(between and,in,like,null)
--4)group by:分组(avg，max，min，count)
--5)having：组过滤
--6)order by：排序(asc，desc)

--(1)select 子句
--*标示查询所有列
select * from member;
--指定的列
select name,salary from member;
--别名
select name 名字,salary 工资 from member;
--计算列
select name,(salary+100) 工资 from member;

--(2)from子句
--表名
select * from member;
--别名
select m.name,m.sex,m.salary--没有m不规范(表名不长也可以member.salary)
from member m

--(3.1)where子句；对表中每一条纪律进行筛选过滤，条件子句
--比较运算符(>,>=,<,<=,=,(!=,<>))
select * from member where salary>2000;
select * from member where salary<>2000;

--(3.2)逻辑运算符(逻辑与and，或or，非not)
--and
select * from member where sex='男' and salary >=2500 and depaptment='市场部';
--or
select *
from member
where salary>2200 or depaptment='市场部';
--not
update member set sex=null where id=1;
select * 
from member where sex is null;
--判断null要用is关键字，不能参与比较运算符
select * 
from member where sex is not null;

--(3.3)其他运算符(between and，in，like，null)
--between and 连续期间，包括边界值
select *
from member
where salary between 2300 and 3500;

select *
from member
where salary >=2300 and salary<=3500;

--in不练续的值
select *
from member 
where salary not in(1800,3500,7500);

select *
from member
where salary not between 2300 and 3500;

--like 模糊查询
--匹配符:_匹配任意的一个字符,%匹配零个或多个字符
select *
from member
where name like'小_'

select *
from member
where depaptment like'生__'

select *
from member
where depaptment like'生%'

select *
from member
where depaptment like'%场_';

select *
from member
where depaptment like'%务%'

--null

--(4)group by分组(通过排序来理解分组)
--主意：使用group by分组时，
--select后边必须时分组的组名，或者时对组的统计聚合函数。
select sex
from member 
group by sex;
--max min 函数最大/小值
select depaptment,max(salary) from member group by depaptment;
--avg 平均
select sex,avg(salary),max(salary),min(salary)
from member 
group by sex;

select sex,count(*)--count(*)个数
from member
group by sex;

update member set sex ='女'where id=1;
select 

--(5)having 对组进行过滤
--和group by连用？
select depaptment,avg(salary)
from member 
where depaptment !='生产部'
group by depaptment 
having avg(salary)>3000;

--(6)order by排序(asc升，desc降)
select *
from member
order by sex,salary desc;
--主意order by A，Bdesc，C asc
--A升序，A相同，B降序，AB相同，C升序

--主意：group by A，B，C
--A，B，C相同的就是一组
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
--找出男，女中最低的员工 工资
select name,salary,sex from member
where salary in
(select min(salary)
from member
group by sex);


--创建公司表
create table company(
id number(3)primary key,--主键，唯一标示一条纪录
name varchar2(20) not null--不能为空
);
--雇员表
create table employee(
id number(3)primary key,--主键，唯一标示一条纪录
name varchar2(20) not null,--不能为空
salary number (8,2),
comid number (3)references company(id)--公司id
);
commit;
select * from cat;
--插入数据
insert into company values(1,'IBM');
insert into company values(2,'HP');
select * from company;
insert into employee values(25,'张三',5000,1);
insert into employee values(26,'李四',4000,1);
insert into employee values(27,'王五',4500,2);
select * from employee;

--(1)错误的做法   笛卡尔积(A表有M条纪录，B表有N条记录，结果M*N条记录)
select *
from company c,employee e

--(2)多表连查正确做法
--如果有m个表查询，至少需要指定(m-1)个公用列的条件，否则笛卡尔积。
select c.name 公司名,e.name 员工名
from company c,employee e
where c.id=e.comid;

drop table employee;

insert into company values(3,'Google');

insert into employee(id,name,salary) values (28,'赵六',3500);

select * from employee;
select * from company;

--(3)左外连接(在公共列的右边添加(+))(只在oracle用)
--左边不满足条件的记录也显示
select *
from company c,employee e
where c.id=e.comid(+);

--(4)右外连接
----右边不满足条件的记录也显
select *
from company c,employee e
where c.id(+)=e.comid;

--(5)左连接(等价左外连接)(通用)
select *
from company c left join employee e on c.id=e.comid;

--(6)右连接(等价右外连接)
select *
from company c right join employee e on c.id=e.comid;

--(7)全连接(左连接+右连接)
select *
from company c full join employee e on c.id=e.comid;

--(8)内连接
select *
from company c inner join employee e on c.id=e.comid;--公共列相等
--1查询IBM的员工信息
select e.name
from company c,employee e
where c.id=e.comid and c.name='IBM';
--2查询王五所在公司信息
select c.name
from company c,employee e
where c.id=e.comid and e.name='王五';
--3查询工资是4000的员工名字和所在公司名字
select e.name,c.name
from company c,employee e
where c.id=e.comid and salary='4000';
--4查询姓李的员工信息以及所在公司
select *
from company c,employee e
where c.id=e.comid and e.name like '李%';
--5查询IBM和HP两家公司的员工的平均工资
select c.name,avg(e.salary)
from company c,employee e
where c.id=e.comid and (c.name in('IBM','HP'))
group by c.name
having avg(e.salary)>3000
order by c.name;

select * from employee;
select * from company;
select * from member;

--子查询
--(1)select子查询(在select语句中嵌入select语句)
--(2)where子查询
--(3)from子查询

--1)select子查询
--注意，查询的结果必须返回单值(一个)
--张三是哪家公司的
select (select name from company where id=comid) 公司名
from employee 
where name='张三';

--2)where子查询
--2.1)条件中是单值的
--查讯高于平均工资的员工信息
select*
from member
where salary>(select avg(salary) from member);

--2.2)条件是集合的
--查询IBM和HP的员工信息
select *
from employee e
where comid in(select id from company where name='IBM' or name='HP');

--查询和小王在一个部门的员工信息
select *
from member
where depaptment=(select depaptment from member where name='小雷');

--3)from子查询(可以将from子查询的结果当成“表”来理解)没有任何限制
--查询张三所在的公司，
--在实际开发中from子查询用的最多
select company.name,t1.n
from company,
(select comid c,name n 
from employee 
where name='张三') t1
where company.id=t1.c;  

select *
from member 
where salary in (select min(salary) from member group by sex);

select m.*
from member m,
(select min(salary) s
from member group by sex) t
where m.salary=t.s;

--(1)rownum伪列
--作用：分页功能，top-n分析
--理解：rownum是oracle获取数据的同时分配值,从1开始,增量是1
select rownum,member.* from member where rownum = 1;
select rownum,member.* from member where rownum = 2;
select rownum,member.* from member;
--在实际开发中3步
--1,各种条件(where,group,having,order by)
--2,使用rownum伪列,在结果表的基础之上添加rownum
--3,top-n分析,分页功能
select *
from
       (select t1.*,rownum r
                from
                (select *
                from member
                order by salary desc) t1) t2
where t2.r<=3;

--  分页功能，查3-7的记录
select *
from (select member.*,rownum r from member) t1
where t1.r between 3 and 7;

select*
from(select member.*,rownum r from member) t1
where t1.r=2;

---case表达式
create table stu(
id number(3)primary key,--主键，唯一标示一条纪录
name varchar2(20),--不能为空
sub varchar2(20),
sco number (3)
);
insert into stu values(1,'张三','语文',80);
insert into stu values(2,'张三','数学',50);
insert into stu values(3,'张三','英语',90);
insert into stu values(4,'李四','语文',40);
insert into stu values(5,'李四','数学',50);
insert into stu values(6,'李四','英语',70);

select * from stu;
--问题；查询stu 要求如下+ 
姓名  语文 数学 英语
张三  80   50  90
--表的转置使用case表达式
select name 姓名,
       sum(case when sub='语文' then sco else 0 end) 语文,--then可以有多个
       sum(case when sub='英语' then sco else 0 end) 英语
from stu
group by name;
--统计各科的及格人数和不及格人数
--------------------------------------------------------------------------------------
select sub 科目,
sum(case when sco>60 then 1 else 0 end) 及格
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
id number(3)primary key,--主键，唯一标示一条纪录
name varchar2(20),--不能为空
age number(30),
sex varchar2(20),
ph varchar2(20),
edu varchar2(20)
);
drop table student;
insert into student values(1,'A',22,'男',123456,'小学');
insert into student values(2,'B',21,'男',119,'中学');
insert into student values(3,'C',23,'男',110,'高中');
insert into student values(4,'D',18,'女',114,'大学');
select * from student;
update student set edu='大专' where ph like '11%';
commit;
delete from student where name like'C%'and sex='男';

select *
from student
where age<22 and edu='大专';

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
  sex varchar2(20)，
  salary number(10,2),
  department varchar2(20)
);
drop table member;
insert into member values('1','小王','男',1500,'市场部');
insert into member values('2','小李','女',1800,'销售部');
insert into member values('3','小刘','男',2300,'生产部');
insert into member values('4','小赵','女',2000,'财务部');
insert into member values('5','小黄','男',3500,'市场部');
insert into member values('6','吴工','女',4500,'生产部');
insert into member values('7','小孙','男',2600,'生产部');
insert into member values('8','老胡','男',7500,'人力部');
insert into member values('9','温哥','男',10000,'总务部');
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
insert into company values('01','蜀国分公司');
insert into company values('02','吴国分公司');
insert into company values('03','魏国分公司');
insert into company values('04','西南夷分公司');


create table sales(
id varchar2(10) primary key,
name varchar2(20),
companyid varchar2(20)，
salesvolume number(10)
);

insert into sales values('1','关羽','01',10000);
insert into sales values('10','张辽','03',10500);
insert into sales values('11','吕布','05',18000);
insert into sales values('2','张飞','01',11000);
insert into sales values('3','赵云','01',12000);
insert into sales values('4','马超','01',9000);
insert into sales values('5','黄忠','01',8500);
insert into sales values('6','甘宁','02',5000);
insert into sales values('7','黄盖','02',3000);
insert into sales values('8','周泰','03',6000);
insert into sales values('9','徐晃','03',9500);

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


 insert into movie ( ID, NAME ) values ( '1', '倩女幽魂' );
 insert into movie ( ID, NAME ) values ( '2', '杀破狼' );
 insert into movie ( ID, NAME ) values ( '3', '刀' );
 insert into movie ( ID, NAME ) values ( '4', '七剑下天山' );
 insert into movie ( ID, NAME ) values ( '5', '枪火' );
 insert into movie ( ID, NAME ) values ( '6', '黑楼孤魂' );
 
 
 create table tag(
   ID VARCHAR2(50) not null primary key, 
   NAME VARCHAR2(500) 
);


 insert into tag ( ID, NAME ) values ( '01', '动作' );
 insert into tag ( ID, NAME ) values ( '02', '古装' );
 insert into tag ( ID, NAME ) values ( '03', '现代' );
 insert into tag ( ID, NAME ) values ( '04', '鬼片' );
 insert into tag ( ID, NAME ) values ( '05', '枪战' );
 insert into tag ( ID, NAME ) values ( '06', '悬疑' );

 
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
where t1.id=m2.id and t1.name='七剑下天山';

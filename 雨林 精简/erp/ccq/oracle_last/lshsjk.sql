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
insert into person values (5,'赵六',60,'后勤部',1210.05);
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
update person set salary=6000where age=60;

--(4)删除 delete 语句
delete from person where id=4;
delete from person where name='赵六';
delete from person where salary is null;
update person set salary=3300 where dep='测试部';



create table ls(
id number(5)primary key,--主键，唯一标示一条纪录
name varchar2(20) not null,--不能为空
age number(2),
dep varchar2(20),
salary number (8,2)
);
select*from ls;
drop table ls;

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

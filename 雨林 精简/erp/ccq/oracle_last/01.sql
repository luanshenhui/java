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

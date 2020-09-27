create table dept
(
deptno number(2) primary key,
dname varchar2(20)
);

create table emp
(
empno number(2) primary key,
ename varchar2(20),
job varchar2(20),
mgr varchar2(20),
sal varchar2(20),
deptno number(2) references dept(deptno)
);

insert into dept values (1,'��ҵ��');
insert into dept values (2,'���۲�');
insert into dept values (3,'������');
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

insert into emp values (1,'jacky','clerk','tom','1000','1');
insert into emp values (2,'tom','clerk','','2000','1');
insert into emp values (7,'biddy','clerk','','2000','1');
insert into emp values (3,'jenny','sales','pretty','600','2');
insert into emp values (4,'pretty','sales','','800','2');
insert into emp values (5,'buddy','jishu','canndy','1000','3');
insert into emp values (6,'canndy','jishu','','1500','3');
commit;
select * from dept;
select * from emp;
--1�г�emp���и����ŵĲ��źţ���߹��ʣ���͹���
select deptno,max(sal),min(sal)
from emp
group by deptno
--2 �г�emp���и�����jobΪ'CLERK'��Ա������͹��ʣ���߹���
select deptno,min(t.sal),max(t.sal)
from 
(select *
from emp
where job='clerk') t
group by deptno
--3 ����emp����͹���С��2000�Ĳ��ţ��г�jobΪ'CLERK'��Ա���Ĳ��źţ���͹��ʣ���߹���
select  deptno,max(sal),min(sal)
from emp e,
(select min(sal) s,deptno d
from emp
group by deptno) t1
where e.deptno=t1.d and t1.s<2000 and job='clerk'
group by deptno
--4 ���ݲ��ź��ɸ߶��ͣ������еͶ����г�ÿ��Ա�������������źţ�����
select *
from emp 
order by deptno desc,sal
--5 �г�'buddy'���ڲ�����ÿ��Ա���������벿�ź�
select *
from emp
where deptno=
(select deptno
from emp
where ename='buddy')
--6 �г�ÿ��Ա�������������������źţ�������
select ename,job,deptno,empno
from emp
--7�г�emp�й���Ϊ'CLERK'��Ա�������������������źţ�������
select ename,job,deptno,empno
from emp
where job='clerk'
--8����emp���й����ߵ�Ա�����г����������������������������Ϊmgr��
select *
from emp 
where mgr is not null
--9 ����dept���У��г����в����������źţ�ͬʱ�г������Ź���Ϊ'CLERK'��Ա�����빤��
select e.empno,e.ename,e.job
from emp e,
(select deptno
from emp 
where job='clerk'
group by deptno) t1
where t1.deptno=e.deptno
--10 ���ڹ��ʸ��ڱ�����ƽ��ˮƽ��Ա�����г����źţ����������ʣ������ź�����
select *
from emp e,
(select deptno,avg(sal) s from emp group by deptno) t1
where e.deptno=t1.deptno and e.sal>t1.s

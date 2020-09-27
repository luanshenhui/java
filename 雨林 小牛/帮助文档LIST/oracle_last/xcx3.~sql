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

insert into dept values (1,'事业部');
insert into dept values (2,'销售部');
insert into dept values (3,'技术部');
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
--1列出emp表中各部门的部门号，最高工资，最低工资
select deptno,max(sal),min(sal)
from emp
group by deptno
--2 列出emp表中各部门job为'CLERK'的员工的最低工资，最高工资
select deptno,min(t.sal),max(t.sal)
from 
(select *
from emp
where job='clerk') t
group by deptno
--3 对于emp中最低工资小于2000的部门，列出job为'CLERK'的员工的部门号，最低工资，最高工资
select  deptno,max(sal),min(sal)
from emp e,
(select min(sal) s,deptno d
from emp
group by deptno) t1
where e.deptno=t1.d and t1.s<2000 and job='clerk'
group by deptno
--4 根据部门号由高而低，工资有低而高列出每个员工的姓名，部门号，工资
select *
from emp 
order by deptno desc,sal
--5 列出'buddy'所在部门中每个员工的姓名与部门号
select *
from emp
where deptno=
(select deptno
from emp
where ename='buddy')
--6 列出每个员工的姓名，工作，部门号，部门名
select ename,job,deptno,empno
from emp
--7列出emp中工作为'CLERK'的员工的姓名，工作，部门号，部门名
select ename,job,deptno,empno
from emp
where job='clerk'
--8对于emp中有管理者的员工，列出姓名，管理者姓名（管理者外键为mgr）
select *
from emp 
where mgr is not null
--9 对于dept表中，列出所有部门名，部门号，同时列出各部门工作为'CLERK'的员工名与工作
select e.empno,e.ename,e.job
from emp e,
(select deptno
from emp 
where job='clerk'
group by deptno) t1
where t1.deptno=e.deptno
--10 对于工资高于本部门平均水平的员工，列出部门号，姓名，工资，按部门号排序
select *
from emp e,
(select deptno,avg(sal) s from emp group by deptno) t1
where e.deptno=t1.deptno and e.sal>t1.s

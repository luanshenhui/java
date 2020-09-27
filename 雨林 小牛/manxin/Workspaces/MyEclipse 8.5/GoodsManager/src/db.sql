drop table goods;
create table goods(
	id number(6) primary key,
	cls varchar2(20) not null,
	name varchar2(20) not null,
	input_time date
);

insert into goods values(1001,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1002,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1003,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1004,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1005,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1006,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1007,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1008,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(1009,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10010,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10011,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10012,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10013,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10014,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10015,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10016,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10017,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10018,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10019,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
insert into goods values(10020,'日用品','牙刷',to_date('2013-02-01','yyyy-mm-dd'));
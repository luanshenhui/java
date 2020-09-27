drop table houseAdmin;
create table houseAdmin(
admin_username varchar2(20),
admin_password varchar2(20) 
);
create sequence houseAdmin_id;
drop sequence houseAdmin_id;
select * from houseAdmin;

create table houseUser(
admin_username varchar2(20),
admin_password varchar2(20)	
);
insert into houseUser values('admin','111');
select * from houseUser;

drop table alarm;
create table alarm(
alarm_id varchar2(20) primary key,
alarm_date varchar2(20),
alarm_location varchar2(50),
alarm_matter varchar2(50),
alarm_way varchar2(50),
alarm_dealway varchar2(50),
alarm_dealperson varchar2(50),
alarm_dealresult varchar2(50)
); 
create sequence alarm_id;
drop sequence alarm_id;

drop table rooms;
create table rooms(
rooms_id varchar2(10) primary key,
rooms_housesid varchar2(20),
rooms_type varchar2(50),
rooms_area number(7,2),
rooms_usearea number(10,2)
);
create sequence rooms_id;
drop sequence rooms_id;


drop table resident;
create table resident(
resident_id varchar2(20),
resident_roomsid varchar2(10),
resident_name varchar2(30),
resident_phone varchar2(20),
resident_unit varchar2(50),
resident_sex varchar2(20)
);

drop table repairs;
create table repairs(
repairs_id varchar2(10),
repairs_plantid varchar2(50),
repairs_date varchar2(20),
repairs_reason varchar2(50),
repairs_way varchar2(50),
repairs_person varchar2(50),
repairs_result varchar2(50)
);
drop table plant;
create table plant(
plant_id varchar2(20),
plant_name varchar2(50),
plant_comid varchar2(10),
plant_factory varchar2(50),
plant_date varchar2(20),
plant_num number(10),
plant_repaircycle number(10)
);


drop table pay;
create table pay(
pay_id varchar2(20),
pay_resid varchar2(20),
pay_feeid varchar2(50),
pay_number number(7,2),
pay_date   varchar2(10),
pay_overdue number(7,2)
);

	
create table houses(
houses_id varchar2(10),
houses_comid varchar2(10),
houses_date varchar2(10),
houses_floor number(10),
houses_area  number(7,2),
houses_face	varchar2(10),
houses_type varchar2(20)
);	

create table fee(
 fee_id varchar2(10),
 fee_comid varchar2(8),
 fee_name varchar2(20),
 fee_standard number(7,2),
 fee_date varchar2(18)
 );
 drop table complaint;
 create table complaint(
 complaint_id varchar2(10),
 complaint_resid varchar2(50),
 complaint_date varchar2(20),
 complaint_matter varchar2(50),
 complaint_dealperson varchar2(50),
 complaint_way varchar2(50),
 complaint_result varchar2(50)
 );
 
 drop table community;
create table Community(
com_id	 varchar2(50),
com_name varchar2(50),
com_date varchar2(50),	
com_principal varchar(20),
com_area number(8,2),
com_buildarea  number(8,2),
com_location varchar2(100)
);
select * from community;
to_date('2012-12-09','YYYY-MM-DD');
update community set com_name='耦合成',com_date='2012-12-11',com_principal='王朝撒旦',com_area='43.0',com_buildarea='23.0',com_location='圣达菲'where com_id='R';
select * from community where com_id='R';
drop table cominfo;
create table cominfo(
cominfo_id varchar2(10),
cominfo_bus varchar2(20),
cominfo_medical varchar2(50),
cominfo_news varchar2(50),
cominfo_weather varchar2(50),
cominfo_notice varchar2(50)
);

drop table carport;
create table carport(
carport_id varchar2(10),
carport_resid  varchar2(10),
carport_carnum  varchar2(10),
carport_cartype  varchar2(50),
carport_area number(7,2)
);	
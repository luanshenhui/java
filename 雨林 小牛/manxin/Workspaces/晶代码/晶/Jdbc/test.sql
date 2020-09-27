create table t_student(
	 	id int primary key auto_increment,
	 	name varchar(50),
	 	age int
	 )
insert into t_student(name,age) values('tom',22);
insert into t_student(name,age) values('jetty',23);

create table t_user(
			id int primary key auto_increment,
			username varchar(50) unique,
			pwd varchar(30),
			age int
		)
		select * from t_user;
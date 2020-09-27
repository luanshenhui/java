create database teach; --创建分区

use teach; --选择分区

Oracle和mysql的区别：
1.mySQL没有varchar2，只有char和varchar

2.mysql中用int来表示整数。

3.mysql中用bigint来保存长整型。

4.mysql中用text类保存过长的字符串，text不需要声明长度

5.mysql可以设置自动增长的主键，auto_increatment
	更改主键增长的默认起始值， alter table tableName auto_increatment = 1001;

6.mysql可以直接通过索引查询数据，例如，查询出第6~10条数据，select * from table limit 5, 5;
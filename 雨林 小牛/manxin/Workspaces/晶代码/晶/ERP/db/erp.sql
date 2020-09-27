# MySQL-Front 5.0  (Build 1.0)

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE */;
/*!40101 SET SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES */;
/*!40103 SET SQL_NOTES='ON' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;


# Host: localhost    Database: market
# ------------------------------------------------------
# Server version 5.0.15-nt


set names gb2312;


DROP DATABASE IF EXISTS `market`;
CREATE DATABASE `market` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `market`;

#
# Table structure for table brand
#

CREATE TABLE `brand` (
  `Id` int(11) NOT NULL auto_increment,
  `num` varchar(50) default NULL,
  `name` varchar(100) default NULL,
  `factory` varchar(50) default NULL,
  `phone` varchar(50) default NULL,
  `address` varchar(100) default NULL,
  `remark` varchar(400) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `brand` VALUES (1,'10001','海尔','地方','放的是','','');
INSERT INTO `brand` VALUES (2,'1002','乐百氏','娃哈哈','','','');
INSERT INTO `brand` VALUES (3,'1003','蒙牛','蒙牛','','','');
INSERT INTO `brand` VALUES (4,'1004','其他','','','','');
INSERT INTO `brand` VALUES (5,'1003','惠普','惠普','','','');
INSERT INTO `brand` VALUES (6,'1007','九阳','','','','');
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table card
#

CREATE TABLE `card` (
  `Id` int(11) NOT NULL auto_increment,
  `card_no` varchar(15) default NULL,
  `card_type` varchar(30) default NULL,
  `money` double default NULL,
  `score` int(11) default NULL,
  `member_id` varchar(30) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `card` VALUES (1,'10001','金卡',1000,0,'1');
INSERT INTO `card` VALUES (2,'1002','普通卡',5000,0,'2');
/*!40000 ALTER TABLE `card` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table employee
#

CREATE TABLE `employee` (
  `Id` int(11) NOT NULL auto_increment,
  `name` varchar(30) default NULL,
  `sex` varchar(30) default NULL,
  `idno` varchar(30) default NULL,
  `birthday` date default NULL,
  `telphone` varchar(30) default NULL,
  `employ_type` varchar(30) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `employee` VALUES (1,'王饼汪','男','1222333333','2011-12-06','3334444','采购员');
INSERT INTO `employee` VALUES (2,'张晓','女','12345612',NULL,'','销售员');
INSERT INTO `employee` VALUES (3,'张杰','男','33343434444','2007-01-09','444444','采购员');
INSERT INTO `employee` VALUES (4,'王五','男','3435454555',NULL,'','销售员');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table goods
#

CREATE TABLE `goods` (
  `Id` int(11) NOT NULL auto_increment,
  `good_no` varchar(20) default NULL,
  `good_name` varchar(100) default NULL,
  `good_type` varchar(30) default NULL,
  `brand` varchar(50) default NULL,
  `good_style` varchar(30) default NULL,
  `good_unit` varchar(30) default NULL,
  `in_come` double default NULL,
  `out_come` double default NULL,
  `factory` varchar(50) default NULL,
  `remark` varchar(400) default NULL,
  `good_num` int(11) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `goods` VALUES (1,'1001','海尔电冰箱','电器','海尔','WV300','台',1500,2555,'','',15);
INSERT INTO `goods` VALUES (2,'1002','果粒橙','食品','','250ml','瓶',2,5,'方法','发',9);
INSERT INTO `goods` VALUES (3,'1003','蒙牛纯牛奶','食品','蒙牛','250ml','箱',2,3,'','',90);
INSERT INTO `goods` VALUES (4,'1004','HTC手机','电器','其他','G14','台',2000,4999,'','',8);
INSERT INTO `goods` VALUES (5,'11','111','食品','','','',0,0,'','111',0);
INSERT INTO `goods` VALUES (6,'1005','创维酷开电视','电器','其他','酷开','台',1999,2999,'','',9);
INSERT INTO `goods` VALUES (7,'2001','九阳豆浆机','电器','九阳','HTMF-998','台',100,255,'九阳','',28);
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table loginuser
#

CREATE TABLE `loginuser` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) default NULL,
  `password` varchar(50) default NULL,
  `phone` varchar(50) default NULL,
  `user_type` varchar(30) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `loginuser` VALUES (1,'admin','admin','123456','管理员');
INSERT INTO `loginuser` VALUES (2,'cgy','8888','123456','采购员');
INSERT INTO `loginuser` VALUES (3,'test','8888','1122222','管理员');
/*!40000 ALTER TABLE `loginuser` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table member
#

CREATE TABLE `member` (
  `Id` int(11) NOT NULL auto_increment,
  `name` varchar(30) default NULL,
  `sex` varchar(30) default NULL,
  `idno` varchar(30) default NULL,
  `birthday` date default NULL,
  `telphone` varchar(30) default NULL,
  `address` varchar(100) default NULL,
  `card_no` varchar(30) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `member` VALUES (1,'张晓梅','女','12121333','2011-12-07','244343434','fgfdgfdg','10001');
INSERT INTO `member` VALUES (2,'斯小杰','男','343434',NULL,'34545555','','1002');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table sales
#

CREATE TABLE `sales` (
  `Id` int(11) NOT NULL auto_increment,
  `member_no` varchar(30) default NULL,
  `member_name` varchar(30) default NULL,
  `sales_date` date default NULL,
  `employee` varchar(30) default NULL,
  `total_money` double default NULL,
  `remark` varchar(300) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `sales` VALUES (1,'10001','张晓梅','2011-12-08','张晓',7554,'订单');
INSERT INTO `sales` VALUES (2,'10001','张晓梅','2011-12-09','张晓',8109,'');
INSERT INTO `sales` VALUES (3,'1002','斯小杰','2011-12-10','王五',1320,'');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table sales_detail
#

CREATE TABLE `sales_detail` (
  `Id` int(11) NOT NULL auto_increment,
  `sales_id` int(11) default NULL,
  `goods_id` int(11) default NULL,
  `num` int(11) default NULL,
  `money` double default NULL,
  `price` double default NULL,
  `goods_name` varchar(100) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `sales_detail` VALUES (1,1,4,1,4999,4999,'HTC手机');
INSERT INTO `sales_detail` VALUES (2,1,1,1,2555,2555,'海尔电冰箱');
INSERT INTO `sales_detail` VALUES (3,2,1,2,2555,2555,'海尔电冰箱');
INSERT INTO `sales_detail` VALUES (4,2,6,1,2999,2999,'创维酷开电视');
INSERT INTO `sales_detail` VALUES (5,3,7,2,510,255,'九阳豆浆机');
INSERT INTO `sales_detail` VALUES (6,3,3,10,30,3,'蒙牛纯牛奶');
/*!40000 ALTER TABLE `sales_detail` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table stock
#

CREATE TABLE `stock` (
  `Id` int(11) NOT NULL auto_increment,
  `stock_no` varchar(30) default NULL,
  `stock_date` date default NULL,
  `member` varchar(30) default NULL,
  `total_money` double default NULL,
  `remark` varchar(300) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `stock` VALUES (1,'1001','2011-12-08','王饼汪',55540,'fasdfsd');
INSERT INTO `stock` VALUES (2,'2001','2011-12-10','张杰',7950,'');
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;
UNLOCK TABLES;

#
# Table structure for table stock_detail
#

CREATE TABLE `stock_detail` (
  `Id` int(11) NOT NULL auto_increment,
  `stock_id` int(11) default NULL,
  `goods_id` int(11) default NULL,
  `num` int(11) default NULL,
  `money` double default NULL,
  `goods_name` varchar(50) default NULL,
  `price` double default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `stock_detail` VALUES (1,1,6,10,29990,'创维酷开电视',2999);
INSERT INTO `stock_detail` VALUES (2,1,1,10,25550,'海尔电冰箱',2555);
INSERT INTO `stock_detail` VALUES (3,2,7,30,7650,'九阳豆浆机',255);
INSERT INTO `stock_detail` VALUES (4,2,3,100,300,'蒙牛纯牛奶',3);
/*!40000 ALTER TABLE `stock_detail` ENABLE KEYS */;
UNLOCK TABLES;

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

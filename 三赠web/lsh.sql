/*
Navicat MySQL Data Transfer

Source Server         : lsh
Source Server Version : 50717
Source Host           : localhost:3306
Source Database       : test

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2017-07-10 16:12:41
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for folt
-- ----------------------------
DROP TABLE IF EXISTS `folt`;
CREATE TABLE `folt` (
  `person_id` varchar(32) NOT NULL,
  `role_id` varchar(32) NOT NULL,
  `role_type` varchar(2) NOT NULL,
  `create_time` varchar(20) NOT NULL,
  `c_a` varchar(2) DEFAULT NULL,
  `c_b` varchar(2) DEFAULT NULL,
  `c_c` varchar(2) DEFAULT NULL,
  `c_d` varchar(2) DEFAULT NULL,
  `c_e` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of folt
-- ----------------------------
INSERT INTO `folt` VALUES ('1111111111', '1', 'a', '2017-07-01', '0', '1', '0', '0', '0');
INSERT INTO `folt` VALUES ('222222222', '1', 'b', '2017-07-09', '0', '0', '1', '0', '0');
INSERT INTO `folt` VALUES ('3476334069966359933', '1111111111', 'h', '2017-07-06 15:55:10', '0', '0', '1', '0', '0');
INSERT INTO `folt` VALUES ('SZ1499072837026', '1111111111', 'd', '2017-07-10 10:16:51', '0', '1', '0', '0', '0');
INSERT INTO `folt` VALUES ('3476334069966359933', '1111111111', 'i', '2017-07-10 10:22:15', '0', '0', '0', '0', '0');
INSERT INTO `folt` VALUES ('3476334069966359933', '1111111111', 'i', '2017-07-10 10:22:16', '0', '0', '0', '0', '0');
INSERT INTO `folt` VALUES ('3476334069966359933', '1111111111', 'i', '2017-07-10 10:22:56', '0', '0', '0', '0', '0');
INSERT INTO `folt` VALUES ('SZ1499072837026', '1111111111', 'd', '2017-07-10 10:38:23', '0', '1', '0', '0', '0');
INSERT INTO `folt` VALUES ('3476334069966359933', '1111111111', 'i', '2017-07-10 11:45:04', '0', '0', '0', '0', '0');

-- ----------------------------
-- Table structure for group
-- ----------------------------
DROP TABLE IF EXISTS `group`;
CREATE TABLE `group` (
  `person_id` varchar(32) NOT NULL,
  `app_id` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of group
-- ----------------------------
INSERT INTO `group` VALUES ('1111111111', '1111111111');
INSERT INTO `group` VALUES ('222222222', '222222222');
INSERT INTO `group` VALUES ('1111111111', '4404647499098611744');
INSERT INTO `group` VALUES ('333333', '333333');
INSERT INTO `group` VALUES ('SZ1498804631935', '123456');
INSERT INTO `group` VALUES ('SZ1499049265374', 'yy123456786');
INSERT INTO `group` VALUES ('1111111111', '1499053338566');
INSERT INTO `group` VALUES ('null', 'null');
INSERT INTO `group` VALUES ('SZ14990606894771', '14990606894771');
INSERT INTO `group` VALUES ('SZ1499060689477', 'SZ1499060689477');
INSERT INTO `group` VALUES ('1111111111', '1499068157492');
INSERT INTO `group` VALUES ('1111111111', '1499072837026');
INSERT INTO `group` VALUES ('333333', '1499073599727');
INSERT INTO `group` VALUES ('1111111111', '3476334069966359933');
INSERT INTO `group` VALUES ('SZ1499233479786', 'SZ1499233479786');
INSERT INTO `group` VALUES ('SZ1499246767106', 'SZ1499246767106');

-- ----------------------------
-- Table structure for img
-- ----------------------------
DROP TABLE IF EXISTS `img`;
CREATE TABLE `img` (
  `id` varchar(32) NOT NULL,
  `type` varchar(5) NOT NULL,
  `name` varchar(12) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of img
-- ----------------------------
INSERT INTO `img` VALUES ('c_a', 'c_a', '红色婊');
INSERT INTO `img` VALUES ('c_b', 'c_b', '橙色');
INSERT INTO `img` VALUES ('c_c', 'c_c', '黄色');
INSERT INTO `img` VALUES ('c_d', 'c_d', '绿茶婊');
INSERT INTO `img` VALUES ('c_e', 'c_e', '蓝色');

-- ----------------------------
-- Table structure for manager
-- ----------------------------
DROP TABLE IF EXISTS `manager`;
CREATE TABLE `manager` (
  `id` varchar(32) NOT NULL,
  `account` varchar(15) NOT NULL,
  `password` varchar(12) NOT NULL,
  `tel` varchar(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of manager
-- ----------------------------
INSERT INTO `manager` VALUES ('admin', 'admin', '111111', '');
INSERT INTO `manager` VALUES ('b743b270766b4e598dd732f59e1dcf7f', '撒大声地', '111111', '131000000000');
INSERT INTO `manager` VALUES ('883e70b15bc64009854e1231ef5802e6', '多撒多', 'qqqqqq', '15924323456');
INSERT INTO `manager` VALUES ('31363b11fd5545cba4cef41b7da44191', 'luan', '111111', '13130496439');

-- ----------------------------
-- Table structure for person
-- ----------------------------
DROP TABLE IF EXISTS `person`;
CREATE TABLE `person` (
  `person_id` varchar(32) NOT NULL,
  `name` varchar(10) NOT NULL,
  `area` varchar(10) NOT NULL,
  `remark` varchar(20) DEFAULT NULL,
  `create_time` varchar(20) NOT NULL,
  `brithday` varchar(20) DEFAULT NULL,
  `type` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of person
-- ----------------------------
INSERT INTO `person` VALUES ('1111111111', 'a', '210000', '1', '2017-06-01', '2000-12-01', '1');
INSERT INTO `person` VALUES ('222222222', 'b', '210000', '1', '2017-06-08', null, null);
INSERT INTO `person` VALUES ('333333', 'a', '210000', '1', '2017-06-23 17:09:56', null, null);
INSERT INTO `person` VALUES ('3476334069966359933', 'i', '210000', null, '2017-07-04 14:44:32', null, '2');
INSERT INTO `person` VALUES ('errt123456', 'a', '210000', null, '2017-07-03 10:23:01', null, '2');
INSERT INTO `person` VALUES ('null', 'A', '210000', null, '2017-07-03 13:34:33', '2001-7-3', '1');
INSERT INTO `person` VALUES ('SZ1499053338566', 'b', '210000', null, '2017-07-03 13:08:33', null, '2');
INSERT INTO `person` VALUES ('SZ1499060689477', 'A', '210000', null, '2017-07-03 14:16:06', '2000-7-3', '1');
INSERT INTO `person` VALUES ('SZ14990606894771', 'A', '210000', null, '2017-07-03 13:56:11', '2000-7-3', '1');
INSERT INTO `person` VALUES ('SZ1499068157492', 'f', '210000', null, '2017-07-03 16:24:10', null, '2');
INSERT INTO `person` VALUES ('SZ1499072837026', 'd', '210000', null, '2017-07-03 17:08:11', null, '2');
INSERT INTO `person` VALUES ('SZ1499073599727', 'i', '210000', null, '2017-07-03 17:23:44', null, '2');
INSERT INTO `person` VALUES ('SZ1499233479786', 'a', '210000', null, '2017-07-05 13:52:17', '2003-07-05', '1');
INSERT INTO `person` VALUES ('SZ1499246767106', 'a', '210000', null, '2017-07-05 17:29:23', '2017-07-05', '1');
INSERT INTO `person` VALUES ('yy123456786', 'c', '210000', null, '2017-07-03 10:51:38', null, '2');

-- ----------------------------
-- Table structure for provinces
-- ----------------------------
DROP TABLE IF EXISTS `provinces`;
CREATE TABLE `provinces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `provinceid` varchar(20) NOT NULL,
  `province` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='省份信息表';

-- ----------------------------
-- Records of provinces
-- ----------------------------
INSERT INTO `provinces` VALUES ('1', '110000', '北京市');
INSERT INTO `provinces` VALUES ('2', '120000', '天津市');
INSERT INTO `provinces` VALUES ('3', '130000', '河北省');
INSERT INTO `provinces` VALUES ('4', '140000', '山西省');
INSERT INTO `provinces` VALUES ('5', '150000', '内蒙古自治区');
INSERT INTO `provinces` VALUES ('6', '210000', '辽宁省');
INSERT INTO `provinces` VALUES ('7', '220000', '吉林省');
INSERT INTO `provinces` VALUES ('8', '230000', '黑龙江省');
INSERT INTO `provinces` VALUES ('9', '310000', '上海市');
INSERT INTO `provinces` VALUES ('10', '320000', '江苏省');
INSERT INTO `provinces` VALUES ('11', '330000', '浙江省');
INSERT INTO `provinces` VALUES ('12', '340000', '安徽省');
INSERT INTO `provinces` VALUES ('13', '350000', '福建省');
INSERT INTO `provinces` VALUES ('14', '360000', '江西省');
INSERT INTO `provinces` VALUES ('15', '370000', '山东省');
INSERT INTO `provinces` VALUES ('16', '410000', '河南省');
INSERT INTO `provinces` VALUES ('17', '420000', '湖北省');
INSERT INTO `provinces` VALUES ('18', '430000', '湖南省');
INSERT INTO `provinces` VALUES ('19', '440000', '广东省');
INSERT INTO `provinces` VALUES ('20', '450000', '广西壮族自治区');
INSERT INTO `provinces` VALUES ('21', '460000', '海南省');
INSERT INTO `provinces` VALUES ('22', '500000', '重庆市');
INSERT INTO `provinces` VALUES ('23', '510000', '四川省');
INSERT INTO `provinces` VALUES ('24', '520000', '贵州省');
INSERT INTO `provinces` VALUES ('25', '530000', '云南省');
INSERT INTO `provinces` VALUES ('26', '540000', '西藏自治区');
INSERT INTO `provinces` VALUES ('27', '610000', '陕西省');
INSERT INTO `provinces` VALUES ('28', '620000', '甘肃省');
INSERT INTO `provinces` VALUES ('29', '630000', '青海省');
INSERT INTO `provinces` VALUES ('30', '640000', '宁夏回族自治区');
INSERT INTO `provinces` VALUES ('31', '650000', '新疆维吾尔自治区');
INSERT INTO `provinces` VALUES ('32', '710000', '台湾省');
INSERT INTO `provinces` VALUES ('33', '810000', '香港特别行政区');
INSERT INTO `provinces` VALUES ('34', '820000', '澳门特别行政区');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `role_type` varchar(8) NOT NULL,
  `role_name` varchar(8) NOT NULL,
  `c_a` varchar(12) DEFAULT NULL,
  `c_b` varchar(12) DEFAULT NULL,
  `c_c` varchar(12) DEFAULT NULL,
  `c_d` varchar(12) DEFAULT NULL,
  `c_e` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`role_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('a', '孩子', '1', '2', '3', '4', '5');
INSERT INTO `role` VALUES ('b', '父亲', '美图美图美图美图美', '美图美图美图美图美', '美图美图美图美图美美图美', '美图美图美图美图美', '美图美图美图美图美');
INSERT INTO `role` VALUES ('c', '母亲', '发的啥地方', '2', '3', '4', '5');
INSERT INTO `role` VALUES ('d', '爷爷', '红色', '2', '黄色', '绿色', '5');
INSERT INTO `role` VALUES ('e', '奶奶', '1', '绿色报告吗', '3', '4', '5');
INSERT INTO `role` VALUES ('f', '外公', '红色', '橙色', '3', '4', '5');
INSERT INTO `role` VALUES ('g', '外婆', '1', '2', '3', '4', '5');

-- ----------------------------
-- Table structure for role_person
-- ----------------------------
DROP TABLE IF EXISTS `role_person`;
CREATE TABLE `role_person` (
  `id` varchar(32) NOT NULL,
  `type` varchar(1) NOT NULL,
  `name` varchar(5) NOT NULL,
  PRIMARY KEY (`id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role_person
-- ----------------------------
INSERT INTO `role_person` VALUES ('001', 'a', '孩子');
INSERT INTO `role_person` VALUES ('002', 'b', '父亲');
INSERT INTO `role_person` VALUES ('003', 'c', '母亲');
INSERT INTO `role_person` VALUES ('004', 'd', '爷爷');
INSERT INTO `role_person` VALUES ('005', 'e', '奶奶');
INSERT INTO `role_person` VALUES ('006', 'f', '外公');
INSERT INTO `role_person` VALUES ('007', 'g', '外婆');
INSERT INTO `role_person` VALUES ('008', 'h', '弟弟');
INSERT INTO `role_person` VALUES ('009', 'i', '阿姨');
INSERT INTO `role_person` VALUES ('010', 'j', '姑姑');
INSERT INTO `role_person` VALUES ('011', 'h', '舅舅');

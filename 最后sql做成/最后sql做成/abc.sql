/*
Navicat MySQL Data Transfer

Source Server         : lsh
Source Server Version : 50561
Source Host           : localhost:3306
Source Database       : abc

Target Server Type    : MYSQL
Target Server Version : 50561
File Encoding         : 65001

Date: 2018-10-08 10:57:30
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `class_person`
-- ----------------------------
DROP TABLE IF EXISTS `class_person`;
CREATE TABLE `class_person` (
  `name` varchar(255) DEFAULT NULL,
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of class_person
-- ----------------------------
INSERT INTO `class_person` VALUES ('张三', '1');
INSERT INTO `class_person` VALUES ('李四', '2');

-- ----------------------------
-- Table structure for `courses`
-- ----------------------------
DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses` (
  `courseno` varchar(20) NOT NULL,
  `coursenm` varchar(100) NOT NULL,
  PRIMARY KEY (`courseno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='课程表';

-- ----------------------------
-- Records of courses
-- ----------------------------
INSERT INTO `courses` VALUES ('C001', '大学语文');
INSERT INTO `courses` VALUES ('C002', '新视野英语');
INSERT INTO `courses` VALUES ('C003', '离散数学');
INSERT INTO `courses` VALUES ('C004', '概率论与数理统计');
INSERT INTO `courses` VALUES ('C005', '线性代数');
INSERT INTO `courses` VALUES ('C006', '高等数学(一)');
INSERT INTO `courses` VALUES ('C007', '高等数学(二)');

-- ----------------------------
-- Table structure for `folt`
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
-- Table structure for `group`
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
-- Table structure for `img`
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
-- Table structure for `manager`
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
-- Table structure for `newtable`
-- ----------------------------
DROP TABLE IF EXISTS `newtable`;
CREATE TABLE `newtable` (
  `keysed` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of newtable
-- ----------------------------
INSERT INTO `newtable` VALUES ('北京市');
INSERT INTO `newtable` VALUES ('天津市');
INSERT INTO `newtable` VALUES ('河北省');
INSERT INTO `newtable` VALUES ('山西省');
INSERT INTO `newtable` VALUES ('内蒙古自治区');
INSERT INTO `newtable` VALUES ('辽宁省');
INSERT INTO `newtable` VALUES ('吉林省');
INSERT INTO `newtable` VALUES ('黑龙江省');
INSERT INTO `newtable` VALUES ('上海市');
INSERT INTO `newtable` VALUES ('江苏省');
INSERT INTO `newtable` VALUES ('浙江省');
INSERT INTO `newtable` VALUES ('安徽省');
INSERT INTO `newtable` VALUES ('福建省');
INSERT INTO `newtable` VALUES ('江西省');
INSERT INTO `newtable` VALUES ('山东省');

-- ----------------------------
-- Table structure for `people`
-- ----------------------------
DROP TABLE IF EXISTS `people`;
CREATE TABLE `people` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `age` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `borth` varchar(255) DEFAULT NULL,
  `qq` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of people
-- ----------------------------
INSERT INTO `people` VALUES ('1', '张红梅', '9', '北京', '1985', '99', '75');
INSERT INTO `people` VALUES ('2', '李雷雷', '8', '北京', '1985', '11', '54');
INSERT INTO `people` VALUES ('3', '迟实都', '14', '北京', '1985', '22', '99');
INSERT INTO `people` VALUES ('4', '张晓莎', '7', '北京', '1985', '33', '88');
INSERT INTO `people` VALUES ('5', '李玉磊', '67', '北京', '1985', '44', '77');
INSERT INTO `people` VALUES ('6', '仓木麻衣', '13', '北京', '1985', '55', '56');
INSERT INTO `people` VALUES ('7', '滨崎步', '67', '北京', '1985', '9', '55');
INSERT INTO `people` VALUES ('8', '赤发鬼', '34', '北京', '1985', '0', '24');
INSERT INTO `people` VALUES ('9', '扈三娘', '23', '大连', '1990', '8', '9');
INSERT INTO `people` VALUES ('10', '阿甘', '45', '北京', '1985', '7', '78');
INSERT INTO `people` VALUES ('11', '玉儿', '24', '北京', '1985', '6', '67');
INSERT INTO `people` VALUES ('12', '矮脚虎', '21', '北京', '1985', '5', '5');
INSERT INTO `people` VALUES ('13', '东方不败', '32', '北京', '1985', '4', '4');
INSERT INTO `people` VALUES ('14', '黑旋风', '23', '大连', '1990', '2', '34');
INSERT INTO `people` VALUES ('15', '李艳', '23', '大连', '1990', '12', '12');

-- ----------------------------
-- Table structure for `person`
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
-- Table structure for `provinces`
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
-- Table structure for `role`
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
-- Table structure for `role_person`
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

-- ----------------------------
-- Table structure for `score`
-- ----------------------------
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `stuid` varchar(16) NOT NULL,
  `courseno` varchar(20) NOT NULL,
  `scores` float DEFAULT NULL,
  PRIMARY KEY (`stuid`,`courseno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of score
-- ----------------------------
INSERT INTO `score` VALUES ('1001', 'C001', '67');
INSERT INTO `score` VALUES ('1001', 'C002', '87');
INSERT INTO `score` VALUES ('1001', 'C003', '83');
INSERT INTO `score` VALUES ('1001', 'C004', '88');
INSERT INTO `score` VALUES ('1001', 'C005', '77');
INSERT INTO `score` VALUES ('1001', 'C006', '77');
INSERT INTO `score` VALUES ('1002', 'C001', '68');
INSERT INTO `score` VALUES ('1002', 'C002', '88');
INSERT INTO `score` VALUES ('1002', 'C003', '84');
INSERT INTO `score` VALUES ('1002', 'C004', '89');
INSERT INTO `score` VALUES ('1002', 'C005', '78');
INSERT INTO `score` VALUES ('1002', 'C006', '78');
INSERT INTO `score` VALUES ('1003', 'C001', '69');
INSERT INTO `score` VALUES ('1003', 'C002', '89');
INSERT INTO `score` VALUES ('1003', 'C003', '85');
INSERT INTO `score` VALUES ('1003', 'C004', '90');
INSERT INTO `score` VALUES ('1003', 'C005', '79');
INSERT INTO `score` VALUES ('1003', 'C006', '79');
INSERT INTO `score` VALUES ('1004', 'C001', '70');
INSERT INTO `score` VALUES ('1004', 'C002', '90');
INSERT INTO `score` VALUES ('1004', 'C003', '86');
INSERT INTO `score` VALUES ('1004', 'C004', '91');
INSERT INTO `score` VALUES ('1004', 'C005', '80');
INSERT INTO `score` VALUES ('1004', 'C006', '80');
INSERT INTO `score` VALUES ('1005', 'C001', '71');
INSERT INTO `score` VALUES ('1005', 'C002', '91');
INSERT INTO `score` VALUES ('1005', 'C003', '87');
INSERT INTO `score` VALUES ('1005', 'C004', '92');
INSERT INTO `score` VALUES ('1005', 'C005', '81');
INSERT INTO `score` VALUES ('1005', 'C006', '81');
INSERT INTO `score` VALUES ('1006', 'C001', '72');
INSERT INTO `score` VALUES ('1006', 'C002', '92');
INSERT INTO `score` VALUES ('1006', 'C003', '88');
INSERT INTO `score` VALUES ('1006', 'C004', '93');
INSERT INTO `score` VALUES ('1006', 'C005', '82');
INSERT INTO `score` VALUES ('1006', 'C006', '82');

-- ----------------------------
-- Table structure for `stu`
-- ----------------------------
DROP TABLE IF EXISTS `stu`;
CREATE TABLE `stu` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of stu
-- ----------------------------
INSERT INTO `stu` VALUES ('1', '张三');
INSERT INTO `stu` VALUES ('2', '李四');
INSERT INTO `stu` VALUES ('3', '王五');
INSERT INTO `stu` VALUES ('4', '赵六');
INSERT INTO `stu` VALUES ('5', '吕七');
INSERT INTO `stu` VALUES ('6', '张三');
INSERT INTO `stu` VALUES ('7', '王五');
INSERT INTO `stu` VALUES ('8', '钱八');
INSERT INTO `stu` VALUES ('1', '利益');
INSERT INTO `stu` VALUES ('2', '收到');

-- ----------------------------
-- Table structure for `student`
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `stuid` varchar(16) NOT NULL COMMENT '学号',
  `stunm` varchar(20) NOT NULL COMMENT '学生姓名',
  PRIMARY KEY (`stuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES ('1001', '张三');
INSERT INTO `student` VALUES ('1002', '李四');
INSERT INTO `student` VALUES ('1003', '赵二');
INSERT INTO `student` VALUES ('1004', '王五');
INSERT INTO `student` VALUES ('1005', '刘青');
INSERT INTO `student` VALUES ('1006', '周明');

-- ----------------------------
-- Table structure for `table1`
-- ----------------------------
DROP TABLE IF EXISTS `table1`;
CREATE TABLE `table1` (
  `col1` char(2) DEFAULT NULL,
  `col2` char(2) DEFAULT NULL,
  `col3` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of table1
-- ----------------------------
INSERT INTO `table1` VALUES ('A1', 'B1', '9');
INSERT INTO `table1` VALUES ('A2', 'B1', '7');
INSERT INTO `table1` VALUES ('A3', 'B1', '4');
INSERT INTO `table1` VALUES ('A4', 'B1', '2');
INSERT INTO `table1` VALUES ('A1', 'B2', '2');
INSERT INTO `table1` VALUES ('A2', 'B2', '9');
INSERT INTO `table1` VALUES ('A3', 'B2', '8');
INSERT INTO `table1` VALUES ('A4', 'B2', '5');
INSERT INTO `table1` VALUES ('A1', 'B3', '1');
INSERT INTO `table1` VALUES ('A2', 'B3', '8');
INSERT INTO `table1` VALUES ('A3', 'B3', '8');
INSERT INTO `table1` VALUES ('A4', 'B3', '6');
INSERT INTO `table1` VALUES ('A1', 'B4', '8');
INSERT INTO `table1` VALUES ('A2', 'B4', '2');
INSERT INTO `table1` VALUES ('A3', 'B4', '6');
INSERT INTO `table1` VALUES ('A4', 'B4', '9');
INSERT INTO `table1` VALUES ('A1', 'B4', '3');
INSERT INTO `table1` VALUES ('A2', 'B4', '5');
INSERT INTO `table1` VALUES ('A3', 'B4', '2');
INSERT INTO `table1` VALUES ('A4', 'B4', '5');

-- ----------------------------
-- Table structure for `tb1`
-- ----------------------------
DROP TABLE IF EXISTS `tb1`;
CREATE TABLE `tb1` (
  `id` int(11) DEFAULT NULL,
  `typeid` int(11) DEFAULT NULL,
  `value` decimal(10,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb1
-- ----------------------------
INSERT INTO `tb1` VALUES ('1', '1', '2.5');
INSERT INTO `tb1` VALUES ('1', '3', '3.0');
INSERT INTO `tb1` VALUES ('1', '2', '6.0');
INSERT INTO `tb1` VALUES ('2', '3', '6.0');
INSERT INTO `tb1` VALUES ('3', '2', '1.5');

-- ----------------------------
-- Table structure for `tb2`
-- ----------------------------
DROP TABLE IF EXISTS `tb2`;
CREATE TABLE `tb2` (
  `typeid` int(11) DEFAULT NULL,
  `type` varchar(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb2
-- ----------------------------
INSERT INTO `tb2` VALUES ('1', 'A');
INSERT INTO `tb2` VALUES ('2', 'B');
INSERT INTO `tb2` VALUES ('3', 'C');

-- ----------------------------
-- Table structure for `test`
-- ----------------------------
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test` (
  `Date` varchar(10) DEFAULT NULL,
  `item` char(10) DEFAULT NULL,
  `saleqty` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of test
-- ----------------------------
INSERT INTO `test` VALUES ('2010-01-01', 'AAA', '8');
INSERT INTO `test` VALUES ('2010-01-02', 'AAA', '4');
INSERT INTO `test` VALUES ('2010-01-03', 'AAA', '5');
INSERT INTO `test` VALUES ('2010-01-01', 'BBB', '1');
INSERT INTO `test` VALUES ('2010-01-02', 'CCC', '2');
INSERT INTO `test` VALUES ('2010-01-03', 'DDD', '6');

-- ----------------------------
-- Table structure for `test_exam`
-- ----------------------------
DROP TABLE IF EXISTS `test_exam`;
CREATE TABLE `test_exam` (
  `idnew` int(11) DEFAULT NULL,
  `sn` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of test_exam
-- ----------------------------

-- ----------------------------
-- Table structure for `test_table`
-- ----------------------------
DROP TABLE IF EXISTS `test_table`;
CREATE TABLE `test_table` (
  `a_id` int(11) DEFAULT NULL,
  `b_id` varchar(255) DEFAULT NULL,
  `c_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of test_table
-- ----------------------------
INSERT INTO `test_table` VALUES (null, null, '北京市');
INSERT INTO `test_table` VALUES (null, null, '天津市');
INSERT INTO `test_table` VALUES (null, null, '河北省');
INSERT INTO `test_table` VALUES (null, null, '山西省');
INSERT INTO `test_table` VALUES (null, null, '内蒙古自治区');
INSERT INTO `test_table` VALUES (null, null, '辽宁省');
INSERT INTO `test_table` VALUES (null, null, '吉林省');
INSERT INTO `test_table` VALUES (null, null, '黑龙江省');
INSERT INTO `test_table` VALUES (null, null, '上海市');
INSERT INTO `test_table` VALUES (null, null, '江苏省');
INSERT INTO `test_table` VALUES (null, null, '浙江省');
INSERT INTO `test_table` VALUES (null, null, '安徽省');
INSERT INTO `test_table` VALUES (null, null, '福建省');
INSERT INTO `test_table` VALUES (null, null, '江西省');
INSERT INTO `test_table` VALUES (null, null, '山东省');
INSERT INTO `test_table` VALUES (null, null, '北京市');
INSERT INTO `test_table` VALUES (null, null, '天津市');
INSERT INTO `test_table` VALUES (null, null, '河北省');
INSERT INTO `test_table` VALUES (null, null, '山西省');
INSERT INTO `test_table` VALUES (null, null, '内蒙古自治区');
INSERT INTO `test_table` VALUES (null, null, '辽宁省');
INSERT INTO `test_table` VALUES (null, null, '吉林省');
INSERT INTO `test_table` VALUES (null, null, '黑龙江省');
INSERT INTO `test_table` VALUES (null, null, '上海市');
INSERT INTO `test_table` VALUES (null, null, '江苏省');
INSERT INTO `test_table` VALUES (null, null, '浙江省');
INSERT INTO `test_table` VALUES (null, null, '安徽省');
INSERT INTO `test_table` VALUES (null, null, '福建省');
INSERT INTO `test_table` VALUES (null, null, '江西省');
INSERT INTO `test_table` VALUES (null, null, '山东省');

-- ----------------------------
-- Table structure for `title`
-- ----------------------------
DROP TABLE IF EXISTS `title`;
CREATE TABLE `title` (
  `id` int(11) NOT NULL,
  `param` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of title
-- ----------------------------
INSERT INTO `title` VALUES ('1', '身高');
INSERT INTO `title` VALUES ('2', '体重');
INSERT INTO `title` VALUES ('3', '腰围');

-- ----------------------------
-- Table structure for `trigger`
-- ----------------------------
DROP TABLE IF EXISTS `trigger`;
CREATE TABLE `trigger` (
  `key` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of trigger
-- ----------------------------

-- ----------------------------
-- Table structure for `value`
-- ----------------------------
DROP TABLE IF EXISTS `value`;
CREATE TABLE `value` (
  `title_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of value
-- ----------------------------
INSERT INTO `value` VALUES ('1', '10', '1');
INSERT INTO `value` VALUES ('2', '178', '1');
INSERT INTO `value` VALUES ('3', '118', '1');
INSERT INTO `value` VALUES ('2', '180', '2');

-- ----------------------------
-- Procedure structure for `bv`
-- ----------------------------
DROP PROCEDURE IF EXISTS `bv`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `bv`(IN `a` int,OUT `b` int)
BEGIN
	select p.province INTO b from provinces p
where p.id=a;
select b;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `fgg`
-- ----------------------------
DROP PROCEDURE IF EXISTS `fgg`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fgg`(IN `a` int,OUT `b` varchar(50))
BEGIN
	select p.province INTO b from provinces p
where p.id=a;
select b;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `getlist`
-- ----------------------------
DROP PROCEDURE IF EXISTS `getlist`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getlist`()
BEGIN
	   select * from provinces;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `getlist2`
-- ----------------------------
DROP PROCEDURE IF EXISTS `getlist2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getlist2`()
BEGIN
	DECLARE  v_province varchar(30);  
  DECLARE  v_tag_id int default -1;  
  DECLARE  v_done int;  
  DECLARE v_count int default 0;  
  
-- 定义游标  
DECLARE rs_cursor CURSOR FOR select province from provinces  limit 15;  
  
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=1;  
  
open rs_cursor;  
cursor_loop:loop  
   FETCH rs_cursor into v_province; -- 取数据  
if(v_count<15)  then  
  
  insert into test_table (c_name)values(v_province);  
  
  set v_tag_id = LAST_INSERT_ID();  
  -- 关键是like CONCAT('%',v_keyword,'%'); 这里的用法  
  -- insert into tbl_sm_tag  (tag_id,soft_id) select v_tag_id,id from sm where soft_name like CONCAT('%',v_keyword,'%');  
  -- insert into test_table (a_id)values(LAST_INSERT_ID());  
end if;  
  
set v_count = v_count + 1;  
  
    
  
   if v_done=1 then  
    leave cursor_loop;  
   end if;  
    
end loop cursor_loop;  
close rs_cursor;  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `getListByKey`
-- ----------------------------
DROP PROCEDURE IF EXISTS `getListByKey`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getListByKey`(IN `a` int)
BEGIN
	select * from provinces where id like CONCAT('%',a,'%');  

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `grpy`
-- ----------------------------
DROP PROCEDURE IF EXISTS `grpy`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `grpy`()
BEGIN
select *, count(distinct id) from stu group by id;
select GROUP_CONCAT(name),id from stu GROUP BY id;
select p.* from people p where (p.age,p.address,p.borth) in(
select e.age,e.address,e.borth from people e group by e.age,e.address,e.borth HAVING count(*)>1
);
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `jj`
-- ----------------------------
DROP PROCEDURE IF EXISTS `jj`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `jj`(IN `emp_id` int,OUT `count_num` int)
BEGIN
SELECT p.province INTO count_num FROM provinces p
WHERE p.id=emp_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `num_from_employee`
-- ----------------------------
DROP PROCEDURE IF EXISTS `num_from_employee`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `num_from_employee`(IN emp_id INT, OUT count_num INT)
    READS SQL DATA
BEGIN  
              SELECT  COUNT(*)  INTO  count_num  
              FROM  manager m
              WHERE  m.account=emp_id ;  
          END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `num_from_employee2`
-- ----------------------------
DROP PROCEDURE IF EXISTS `num_from_employee2`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `num_from_employee2`(IN emp_id VARCHAR(50), OUT count_num VARCHAR(50))
    READS SQL DATA
BEGIN  
             SELECT  m.`password`  INTO  count_num  
              FROM  manager m
              WHERE  m.account=emp_id ; 
							select count_num; 
          END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `SP_QueryData`
-- ----------------------------
DROP PROCEDURE IF EXISTS `SP_QueryData`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_QueryData`(IN `stuid` varchar(16))
BEGIN
SET @sql = NULL;
SET @stuid = NULL;
SELECT
 GROUP_CONCAT(DISTINCT
  CONCAT(
   'MAX(IF(c.coursenm = ''',
   c.coursenm,
   ''', s.scores, 0)) AS ''',
   c.coursenm, '\''
  )
 ) INTO @sql
FROM courses c;
 
SET @sql = CONCAT('Select st.stuid, st.stunm, ', @sql, 
            ' From Student st 
            Left Join score s On st.stuid = s.stuid
            Left Join courses c On c.courseno = s.courseno');
             
IF stuid is not null and stuid <> '' then
SET @stuid = stuid;
SET @sql = CONCAT(@sql, ' Where st.stuid = \'', @stuid, '\'');
END IF;  
 
SET @sql = CONCAT(@sql, ' Group by st.stuid');
 
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `test_table`
-- ----------------------------
DROP PROCEDURE IF EXISTS `test_table`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `test_table`()
BEGIN
		DECLARE  a int;   -- id
    DECLARE  b varchar(32); -- 密码
    DECLARE  c varchar(32);   -- id
    -- 遍历数据结束标志
    DECLARE done INT DEFAULT FALSE;
    -- 游标
    DECLARE cur_account CURSOR FOR select id,provinceid,province from provinces;
    -- 将结束标志绑定到游标
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- 打开游标
    OPEN  cur_account;     
    -- 遍历
    read_loop: LOOP
            -- 取值 取多个字段
            FETCH  NEXT from cur_account INTO a,b,c;
            IF done THEN
                LEAVE read_loop;
             END IF;
 
        -- 你自己想做的操作
        insert into test_table(a_id,b_id,c_name) value(a,b,c);
    END LOOP;
 
 
    CLOSE cur_account;

END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `ins_stu`;
DELIMITER ;;
CREATE TRIGGER `ins_stu` AFTER INSERT ON `test_table` FOR EACH ROW begin  
      insert into newtable (keysed)  
        values(new.c_name);  
end
;;
DELIMITER ;

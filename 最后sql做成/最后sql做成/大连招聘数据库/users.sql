/*
Navicat MySQL Data Transfer

Source Server         : user
Source Server Version : 50720
Source Host           : localhost:3306
Source Database       : base

Target Server Type    : MYSQL
Target Server Version : 50720
File Encoding         : 65001

Date: 2018-05-10 10:33:31
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `tel` varchar(255) CHARACTER SET utf32 DEFAULT NULL,
  `midetel` varchar(255) DEFAULT NULL,
  `xl` varchar(255) DEFAULT NULL,
  `borth` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `personName` varchar(255) DEFAULT NULL,
  `age` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `hukou` varchar(255) DEFAULT NULL,
  `zt` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `updateTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('2', '15942629036', '18940935351', '大专', '1987', '刘', null, '', '大连', '大连', '1', '15942629036', null, null);
INSERT INTO `users` VALUES ('3', '15942468297', '417354844', '1', '1989', 'ccq', null, '', null, null, '2', '15942468297', null, null);
INSERT INTO `users` VALUES ('4', 'T13654081621', '1', '本', '1985', '萍', '', null, null, null, null, 'T13654081621', null, null);
INSERT INTO `users` VALUES ('5', '0', 'T15724541908', '本科', '1989', '', '小太阳', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('6', '0', 'yilingqingyu', '硕士', '1988', '', '王', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('7', '0', 'zhao958886508', '大专', '1988', '', '赵', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('8', '0', '15842677838', '本科', '1993', '', '王', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('9', '0', '15940849736', '本科', '1988', '', '许', '2', null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('10', '0', '15942815605', '本科', '1989', '', '萌萌', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('11', '0', '13478461198', '大专', '1988', '', '王', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('12', '0', '15909857893', '大专', '1988', '', '徐', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('13', '0', 'W1837133670', '大专', '1989', '', '洪', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('14', '0', '13889483253', '大专', '1986', '', '于', null, null, null, '3', '123456789', null, null);
INSERT INTO `users` VALUES ('15', '0', 'W707413079', '研究生', '1987', '', '伊', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('16', '0', 'W2291544135', '中专', '1988', '', '丽丽', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('17', '0', '13942495543', '本科', '1985', '', '王', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('18', '0', '13624083995', '本科', '1991', '', '晶晶', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('19', '0', '15566932773', '研究生', '1990', null, '伊', null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('20', '0', '13795114162', null, '1983', null, 'li', null, null, null, '0', '123456789', null, null);
INSERT INTO `users` VALUES ('21', '0', '13478790479', null, '1991', null, '张', '27-30', null, null, '0', '123456789', null, null);
INSERT INTO `users` VALUES ('22', '0', '13840936721', null, '1989', null, '钟', '本科，公务员', null, null, '0', '123456789', null, null);
INSERT INTO `users` VALUES ('23', '0', '15898477746', null, '1987', null, null, null, null, null, '0', '123456789', null, null);
INSERT INTO `users` VALUES ('24', '0', '13898643756', null, '1984', null, null, '本科', null, '教师', '0', '123456789', null, null);
INSERT INTO `users` VALUES ('25', '0', '15330821780', null, '1991', 'mm', null, '3-5岁', null, null, '0', '123456789', null, null);
INSERT INTO `users` VALUES ('26', '0', '15842667692', null, '1992', null, 'li-mm', '要求好高的', null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('27', null, null, null, null, null, null, null, null, null, null, '123456789', null, null);
INSERT INTO `users` VALUES ('28', '', '', '1', '0', '0', '小土巴啦', null, '大连', '大连', null, '0', null, null);
INSERT INTO `users` VALUES ('29', 'yh', '15998484989', '', '1988', '', '', null, null, null, null, null, 'yh', '2018-04-02 14:48:37');
INSERT INTO `users` VALUES ('30', 'yh', '13029448853', '', '1989', '', '', null, null, null, null, null, 'yh', '2018-04-02 14:48:34');
INSERT INTO `users` VALUES ('31', 'yh', '13604098286', '', '1985', '', '', null, null, null, null, null, 'yh', '2018-04-02 14:48:30');
INSERT INTO `users` VALUES ('32', '', '13795147632', '', '1986', '', '', null, null, null, null, null, null, '2018-04-02 14:48:27');
INSERT INTO `users` VALUES ('33', '', '15330821780', '', '1991', '', '', null, null, null, null, null, '金融行业', '2018-04-02 14:48:23');
INSERT INTO `users` VALUES ('34', '', '13998471638', '', '1986', '', '张mm', null, null, null, null, null, null, '2018-04-02 14:48:21');
INSERT INTO `users` VALUES ('35', '', '13889689662', '', '1987', '', '', null, null, null, null, null, null, '2018-04-02 14:48:18');
INSERT INTO `users` VALUES ('36', '', '13342229310', '', '1993', '', 'bb', '幼师', null, null, null, null, '要本', '2018-04-02 14:48:15');
INSERT INTO `users` VALUES ('37', '', '15141100121', '', '1987', '', '', '源自公园', null, null, null, null, null, '2018-04-02 14:48:11');
INSERT INTO `users` VALUES ('38', '', '18840958589', '', '1983', '', '关mm', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('39', '', '13190193873', '', '1990', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('40', '', '1956716462', '', '1984', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('41', '', '183713361/570', '', '1989', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('42', '', '15035056631', '', '0', '', '王mm', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('43', '', '13898643756', '', '1984', '', '', null, null, null, null, null, '本科', null);
INSERT INTO `users` VALUES ('44', '', '13604098286', '', '1985', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('45', '', '15330821780', '', '1991', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('46', '', '13674263463', '', '1985', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('47', '', '15724541908', '', '1989', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('48', '', '84608304', '', '1987', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('49', '', '15898350289', '', '1985', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('50', '', '18840958589', '', '1983', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('51', '', '15909857893', '', '1988', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('52', '', '13889483253', '', '1986', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('53', '', '86737719', '', '1989', '', '陈mm', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('54', '', '15524786634', '', '1983', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('55', '', '13204067671', '', '1989', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('56', '', '15140381587/2', '硕士', '1984', '', '林mm', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('57', '', '13614266820', '', '1989', '', '房，车', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('58', '', '13610952065', '', '1989', '', '曲mm', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('59', '', '13624083995', '', '1984', '', '硕士', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('60', '', '13840991784', '', '1994', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('61', '', '13149867260', '', '1983', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('62', '', '13052781929', '', '1985', '', '张mm', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('63', '', '15998511296', '', '1992', '', 'yh', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('64', '', '13795106091', '', '1988', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('65', '', '13704286137', '', '1983', '', '本科 bb', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('66', '', '13898643756', '', '1984', '', '老师', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('67', '', '15330821780', '', '1991', '', '', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('68', '', '15941181352', '', '1991', '', '本科', null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('70', null, 'test00', 'test1', '3333', 'test1', 'test3', 'test3', 'test3', 'test3', null, 'test17', 'test3', '2018-04-02 11:38:54');
INSERT INTO `users` VALUES ('71', null, '15734186135', '', '1986', '', '', '', '', '', null, '', '', '2018-04-03 14:00:41');
INSERT INTO `users` VALUES ('72', null, '13654119120', '', '1983', '', '杨mm', '', '', '', null, '', '', '2018-04-03 14:02:39');
INSERT INTO `users` VALUES ('73', null, '84623617', '', '1988', '', '王mm', '', '', '', null, '', '', '2018-04-03 14:01:59');
INSERT INTO `users` VALUES ('74', null, '13052778460', '', '1989', '', '', '教育主管', '', '', '1', '', '', '2018-04-09 14:18:52');
INSERT INTO `users` VALUES ('75', null, '18757827389', '中专', '1988', '', '', '健康行业', '', 'h:160', '1', '', '', '2018-04-09 14:19:02');
INSERT INTO `users` VALUES ('76', null, '17170250281', '', '1987', '', '', '店铺，教师', '', 'h164，w102', null, '', '', '2018-04-09 13:39:38');
INSERT INTO `users` VALUES ('77', null, '13897814186', '本科', '1988', '', '', '公务员', '', 'h165', '1', '', '', '2018-04-09 14:19:14');
INSERT INTO `users` VALUES ('78', null, '13500709164', '', '1989', '', '', '财务', '', 'w60', '1', '', '', '2018-04-09 14:22:15');
INSERT INTO `users` VALUES ('79', null, '13238091692', '', '1989', '', '', '', '', 'g169', '1', '', '', '2018-04-09 14:23:40');
INSERT INTO `users` VALUES ('80', null, '18098857232', '本科', '1989', '', '小姨', '护士', '', '', '1', '', '', '2018-04-09 14:24:54');
INSERT INTO `users` VALUES ('81', null, '123', '', '0', '', '恰合啊。臭小宝', '', '', '', '3', '', '', '2018-04-09 15:23:19');
INSERT INTO `users` VALUES ('82', null, '13591390967', '', '1989', '', '曲mm', '', '', '机场安检', null, '', '', '2018-04-16 14:24:42');
INSERT INTO `users` VALUES ('83', null, '81256306', '', '1985', '', '', '', '', '要本科', null, '', '', '2018-04-16 14:28:53');
INSERT INTO `users` VALUES ('84', null, '13500797439', '', '1991', '', '', '', '', '', null, '', '要87', '2018-04-23 09:42:04');
INSERT INTO `users` VALUES ('85', null, '13342229310', '', '1993', '', '', '', '', '', null, '', '要本科', '2018-04-23 09:42:32');
INSERT INTO `users` VALUES ('86', null, '15840817458', '', '1988', '', '', '宾馆', '', '', null, '', '', '2018-04-23 09:42:57');
INSERT INTO `users` VALUES ('87', null, '13795175238', '', '1983', '', '', '', '', '无爸', null, '', '', '2018-04-23 09:43:43');
INSERT INTO `users` VALUES ('88', null, '13998567798', '', '1992', '', '张爸爸', '', '', '', null, '', '', '2018-04-23 09:44:19');
INSERT INTO `users` VALUES ('89', null, '13130452972', '', '1989', '', '张mm', '', '', '身高158', null, '', '', '2018-04-23 09:46:15');
INSERT INTO `users` VALUES ('90', null, '13204067671', '', '1989', '', '于mm', '', '', '', null, '', '', '2018-04-23 10:48:05');
INSERT INTO `users` VALUES ('91', null, '15042490971', '', '1993', '', '', '', '', '', null, '', '', '2018-05-03 14:21:01');
INSERT INTO `users` VALUES ('92', null, '15330821780', '', '1991', '', '', '', '', '168', null, '', '', '2018-05-03 14:37:25');
INSERT INTO `users` VALUES ('93', null, '13889583625 ', '', '1987', '', '从爸爸', '', '', '', null, '', '', '2018-05-03 14:38:01');
INSERT INTO `users` VALUES ('94', null, '155423025150', '', '1987', '', 'mm', '', '', '', null, '', '', '2018-05-03 14:38:22');
INSERT INTO `users` VALUES ('95', null, '13052778460', '', '1989', '', '', '', '', '', null, '', '', '2018-05-10 10:27:30');
INSERT INTO `users` VALUES ('96', null, '13504110876', '', '1991', '', '', '', '', '', null, '', '', '2018-05-10 10:27:55');
INSERT INTO `users` VALUES ('97', null, '15998497191', '', '1990', '', '', '', '', '', null, '', '', '2018-05-10 10:29:25');
INSERT INTO `users` VALUES ('98', null, '13940950339', '', '1986', '', '', '', '', '', null, '', '', '2018-05-10 10:29:41');

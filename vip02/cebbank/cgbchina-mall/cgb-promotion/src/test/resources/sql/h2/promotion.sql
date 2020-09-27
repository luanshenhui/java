/*
Navicat MySQL Data Transfer

Source Server         : 172.16.75.204-dev
Source Server Version : 50173
Source Host           : 172.16.75.204:3306
Source Database       : cgb

Target Server Type    : MYSQL
Target Server Version : 50173
File Encoding         : 65001

Date: 2016-06-15 16:44:04
*/
-- ----------------------------
-- Table structure for `tbl_promotion`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_promotion`;
CREATE TABLE `tbl_promotion` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `shop_type` char(2) NOT NULL COMMENT '平台类型 yg：广发商城，jf：积分商城',
  `prom_code` char(10) DEFAULT NULL COMMENT '活动编号',
  `name` varchar(200) DEFAULT NULL COMMENT '活动名称',
  `short_name` varchar(200) DEFAULT NULL COMMENT '简称',
  `prom_type` tinyint(4) DEFAULT NULL COMMENT '活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍',
  `is_signup` tinyint(4) DEFAULT NULL COMMENT '是否需报名活动 0否 1是',
  `begin_date` datetime DEFAULT NULL COMMENT '开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '结束时间',
  `loop_job` varchar(255) DEFAULT NULL COMMENT '存储为JSON格式，其中【loop_type】的值为d  按天循环;w 按星期循环；m 按月循环例子：{"loop_type":"m","data":"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31","begin_time":"10:30:30","end_time":"11:30:30"}',
  `channel_types` varchar(255) DEFAULT NULL COMMENT '销售渠道（01 广发商城，02积分商城，03手机商城，04CC，05IVR，06短信，07APP，08微信广发银行，09微信广发信用卡）格式：||01||02||',
  `description` text COMMENT '内容介绍',
  `fee_rule` varchar(255) DEFAULT NULL COMMENT '优惠规则，JSON串',
  `state` tinyint(4) DEFAULT NULL COMMENT '活动状态(添加(未提交审批) 0; 编辑(未提交审批) 1;已提交(待审批) 2;已提交(已审批通过) 3;已提交(未审批通过) 4;正在进行 5;已停止[活动执行过&结束时间小于当前时间] 6;已取消 7;已失效[结束时间小于当前时间] 8;)',
  `begin_entry_date` datetime DEFAULT NULL COMMENT '报名开始时间',
  `end_entry_date` datetime DEFAULT NULL COMMENT '报名结束时间',
  `create_oper_type` int(6) DEFAULT NULL COMMENT '创建人类型',
  `modify_oper_type` int(6) DEFAULT NULL COMMENT '修改人类型',
  `audit_log` varchar(2048) DEFAULT NULL COMMENT '审核日志',
  `audit_oper` int(10) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '最终审核日期',
  `is_valid` tinyint(4) DEFAULT NULL COMMENT '有效状态：0删除，1正常',
  `create_oper` varchar(50) NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_oper` varchar(50) DEFAULT NULL COMMENT '修改人',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
);

-- ----------------------------
-- Table structure for `tbl_promotion_formal`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_promotion_formal`;
CREATE TABLE `tbl_promotion_formal` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `promotion_id` int(10) NOT NULL COMMENT '活动ID',
  `begin_date` datetime DEFAULT NULL COMMENT '开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '结束时间',
  `vendor_id` char(6) DEFAULT NULL COMMENT '供应商ID',
  `brand_id` bigint(20) DEFAULT NULL COMMENT '品牌ID',
  `back_category_id` bigint(20) DEFAULT NULL COMMENT '后台类目ID',
  `goods_id` varchar(50) DEFAULT NULL COMMENT '商品ID',
  `item_id` varchar(50) DEFAULT NULL COMMENT '单品ID',
  `channel_types` varchar(255) DEFAULT NULL COMMENT '销售渠道（01 广发商城，02积分商城，03手机商城，04CC，05IVR，06短信，07APP，08微信广发银行，09微信广发信用卡）格式：||01||02||',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `sales` int(10) DEFAULT NULL COMMENT '销量',
  PRIMARY KEY (`id`)
);

-- ----------------------------
-- Records of tbl_promotion_formal
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_promotion_period`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_promotion_period`;
CREATE TABLE `tbl_promotion_period` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `promotion_id` int(10) NOT NULL COMMENT '活动ID',
  `begin_date` datetime DEFAULT NULL COMMENT '开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`)
);

-- ----------------------------
-- Records of tbl_promotion_period
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_promotion_range`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_promotion_range`;
CREATE TABLE `tbl_promotion_range` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '活动选取范围ID',
  `promotion_id` int(10) NOT NULL COMMENT '活动ID',
  `vendor_id` char(6) DEFAULT NULL COMMENT '供应商ID',
  `range_type` tinyint(4) DEFAULT NULL COMMENT '范围类型（0 单品）',
  `select_id` int(11) DEFAULT NULL COMMENT '范围，格式为JSON串',
  `select_data` varchar(100) DEFAULT NULL COMMENT '范围，格式为JSON串',
  `state` int(10) DEFAULT NULL COMMENT '选品状态 0 审核未通过，1审核通过',
  `is_valid` tinyint(4) DEFAULT NULL COMMENT '有效状态：0删除，1正常',
  `create_oper_type` int(6) DEFAULT NULL COMMENT '创建者类型',
  `modify_oper_type` int(6) DEFAULT NULL COMMENT '修改者类型',
  `audit_log` int(10) DEFAULT NULL COMMENT '审核日志',
  `audit_oper` int(10) DEFAULT NULL COMMENT '审核人',
  `audit_date` datetime DEFAULT NULL COMMENT '最终审核日期',
  `create_oper` varchar(50) NOT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `modify_oper` varchar(50) DEFAULT NULL COMMENT '修改人',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
);

-- ----------------------------
-- Records of tbl_promotion_range
-- ----------------------------

-- ----------------------------
-- Table structure for `tbl_promotion_vendor`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_promotion_vendor`;
CREATE TABLE `tbl_promotion_vendor` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '活动选取范围ID',
  `promotion_id` int(10) NOT NULL COMMENT '活动ID',
  `vendor_id` char(6) DEFAULT NULL COMMENT '供应商ID',
  `is_valid` tinyint(4) DEFAULT NULL COMMENT '有效状态：0删除，1正常',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
);

-- ----------------------------
-- Records of tbl_promotion_vendor
-- ----------------------------

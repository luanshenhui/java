/*
Navicat Oracle Data Transfer
Oracle Client Version : 10.2.0.5.0

Source Server         : dev_zhangshiqiang
Source Server Version : 110200
Source Host           : 172.16.75.18:1521
Source Schema         : DEV_ZHANGSHIQIANG

Target Server Type    : ORACLE
Target Server Version : 110200
File Encoding         : 65001

Date: 2016-12-15 13:47:27
*/


-- ----------------------------
-- Table structure for DCA_TRACE_USER_ROLE
-- ----------------------------
DROP TABLE "DEV_ZHANGSHIQIANG"."DCA_TRACE_USER_ROLE";
CREATE TABLE "DEV_ZHANGSHIQIANG"."DCA_TRACE_USER_ROLE" (
"ROLE_ID" NVARCHAR2(50) NOT NULL ,
"ORG_ID" NVARCHAR2(50) NULL ,
"ROLE_NAME" NVARCHAR2(150) NULL ,
"USER_ID_LIST" NVARCHAR2(2000) NULL ,
"ROLE_PARENT_ID" NVARCHAR2(50) NULL ,
"DEPT_ID" NVARCHAR2(50) NULL ,
"ROLE_RANK" NUMBER NULL ,
"CREATE_PERSON" NVARCHAR2(64) NULL ,
"CREATE_DATE" DATE NULL ,
"UPDATE_PERSON" NVARCHAR2(64) NULL ,
"UPDATE_DATE" DATE NULL ,
"DEL_FLAG" NVARCHAR2(2) NULL 
)
LOGGING
NOCOMPRESS
NOCACHE

;

-- ----------------------------
-- Checks structure for table DCA_TRACE_USER_ROLE
-- ----------------------------
ALTER TABLE "DEV_ZHANGSHIQIANG"."DCA_TRACE_USER_ROLE" ADD CHECK ("ROLE_ID" IS NOT NULL);

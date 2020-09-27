/*
Navicat Oracle Data Transfer
Oracle Client Version : 10.2.0.3.0

Source Server         : 172.16.2.199
Source Server Version : 100200
Source Host           : localhost:1521
Source Schema         : HONGLING01

Target Server Type    : ORACLE
Target Server Version : 100200
File Encoding         : 65001

Date: 2012-04-26 14:08:21
*/


-- ----------------------------
-- Table structure for "CROSSRULE"
-- ----------------------------
DROP TABLE "CROSSRULE";

  CREATE TABLE "HONGLING01"."CROSSRULE" 
   (	"ID" NUMBER, 
	"RULES" NVARCHAR2(300), 
	 PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" 
 ;

-- ----------------------------
-- Records of CROSSRULE
-- ----------------------------

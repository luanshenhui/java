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

Date: 2012-04-20 09:13:32
*/


-- ----------------------------
-- Table structure for "FABRIC"
-- ----------------------------
DROP TABLE "FABRIC";

  CREATE TABLE "HONGLING01"."FABRIC" 
   (	"CODE" VARCHAR2(20) NOT NULL ENABLE, 
	"WEIGHT" NUMBER, 
	"PRICE" NUMBER, 
	"SERIESID" NUMBER NOT NULL ENABLE, 
	"COLORID" NUMBER NOT NULL ENABLE, 
	"FLOWERID" NUMBER NOT NULL ENABLE, 
	"COMPOSITIONID" NUMBER NOT NULL ENABLE, 
	"CATEGORYID" NUMBER, 
	"ID" NUMBER NOT NULL ENABLE, 
	"ISSTOP" NUMBER, 
	"FABRICSUPPLYID" VARCHAR2(32), 
	"FABRICSUPPLYCODE" VARCHAR2(100), 
	"FABRICSUPPLYCATEGORYID" NUMBER, 
	"SHAZHI" VARCHAR2(1000), 
	 CHECK ("CODE" IS NOT NULL) ENABLE, 
	 CHECK ("SERIESID" IS NOT NULL) ENABLE, 
	 CHECK ("COLORID" IS NOT NULL) ENABLE, 
	 CHECK ("FLOWERID" IS NOT NULL) ENABLE, 
	 CHECK ("COMPOSITIONID" IS NOT NULL) ENABLE, 
	 CONSTRAINT "SYS_C005445" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "USERS" 
 ;

-- ----------------------------
-- Records of FABRIC
-- ----------------------------
INSERT INTO "FABRIC" VALUES ('MBD333', '111', '111', '8006', '8010', '8015', '8020', '8001', '17', '10051', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('MBD888', '280', '100', '8006', '8011', '8015', '8020', '8001', '29', '10051', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK509A', '280', null, '8006', '8011', '8015', '8020', '8001', '31', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK507A', '280', '1200', '8006', '8011', '8015', '8020', '8001', '25', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK546A', '270', null, '8006', '8012', '8015', '8020', '8001', '33', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL507A', '270', null, '8006', '8011', '8016', '8020', '8001', '36', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL547A', '270', null, '8006', '8013', '8016', '8020', '8001', '38', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBH274A', '290', null, '8006', '8013', '8018', '8020', '8001', '48', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK508A', '280', null, '8006', '8013', '8015', '8020', '8001', '50', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK057A', '260', null, '8006', '8011', '8015', '8020', '8001', '53', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL611A', '280', null, '8006', '8010', '8016', '8020', '8001', '61', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL552A', '300', '22', '8008', '8013', '8018', '8020', '8050', '65', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL551A', '300', '22', '8008', '8013', '8018', '8020', '8050', '66', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL617A', '280', null, '8006', '8012', '8016', '8020', '8001', '72', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL618A', '280', null, '8006', '8013', '8018', '8020', '8001', '82', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL634A', '280', null, '8006', '8013', '8015', '8022', '8001', '89', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL642A', '280', null, '8006', '8010', '8016', '8022', '8001', '97', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL648A', '280', null, '8006', '8013', '8016', '8022', '8001', '103', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL659A', '280', null, '8006', '8010', '8018', '8022', '8001', '114', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL662A', '280', null, '8006', '8013', '8018', '8022', '8001', '117', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL586A', '270', null, '8007', '8013', '8015', '8022', '8001', '121', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL592A', '270', null, '8007', '8012', '8015', '8022', '8001', '128', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL599A', '270', null, '8007', '8012', '8016', '8022', '8001', '138', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL544A', '270', null, '8007', '8011', '8017', '8022', '8001', '144', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL608A', '270', null, '8007', '8010', '8018', '8021', '8001', '151', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL669A', '290', null, '8008', '8012', '8016', '8022', '8001', '158', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('CAM159A', null, '46', '-1', '-1', '-1', '-1', '8030', '170', '10050', null, null, '10320', '50/1*50/1');
INSERT INTO "FABRIC" VALUES ('MBL548A', '270', null, '8006', '8013', '8016', '8020', '8001', '39', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL508A', '270', null, '8006', '8013', '8017', '8020', '8001', '42', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL643A', '280', null, '8006', '8011', '8016', '8022', '8001', '98', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBK611A', '270', null, '8006', '8011', '8017', '8020', '8001', '44', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK711A', '260', null, '8006', '8010', '8015', '8020', '8001', '21', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK712A', '260', null, '8006', '8010', '8015', '8020', '8001', '23', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK055A', '270', null, '8006', '8011', '8015', '8020', '8001', '26', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL503A', '280', null, '8006', '8013', '8015', '8020', '8001', '28', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK590A', '210', null, '8006', '8010', '8018', '8020', '8001', '46', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK065A', '280', null, '8006', '8013', '8015', '8020', '8001', '49', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK504A', '270', null, '8006', '8013', '8015', '8020', '8001', '51', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL638A', '280', null, '8006', '8013', '8017', '8022', '8001', '93', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL640A', '280', null, '8006', '8011', '8017', '8022', '8001', '95', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL645A', '280', null, '8006', '8012', '8016', '8022', '8001', '100', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL647A', '280', null, '8006', '8013', '8016', '8022', '8001', '102', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL652A', '280', null, '8006', '8010', '8016', '8022', '8001', '107', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL655A', '280', null, '8006', '8011', '8015', '8022', '8001', '110', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL660A', '280', null, '8006', '8011', '8018', '8022', '8001', '115', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBK421A', '230', null, '8007', '8011', '8015', '8022', '8001', '127', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBK612A', '270', null, '8007', '8011', '8018', '8020', '8001', '129', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL597A', '270', null, '8007', '8012', '8016', '8022', '8001', '134', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL601A', '270', null, '8007', '8013', '8017', '8022', '8001', '141', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL603A', '270', null, '8007', '8013', '8018', '8022', '8001', '146', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL610A', '270', null, '8007', '8012', '8018', '8021', '8001', '153', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBK725A', '300', null, '8008', '8013', '8018', '8022', '8001', '161', '10050', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('MBK253A', '280', null, '8008', '8013', '8016', '8022', '8001', '166', '10050', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('CAM157A', null, '46', '8008', '-1', '-1', '-1', '8030', '171', '10050', null, null, '10320', '60/1*60/1');
INSERT INTO "FABRIC" VALUES ('MBK053A', '270', null, '8006', '8010', '8015', '8020', '8001', '18', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK709A', '270', null, '8006', '8010', '8015', '8020', '8001', '20', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL546A', '260', null, '8006', '8013', '8016', '8020', '8001', '37', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK613A', '310', null, '8006', '8011', '8016', '8020', '8001', '41', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL509A', '270', null, '8006', '8011', '8017', '8020', '8001', '43', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK589A', '210', null, '8006', '8013', '8018', '8020', '8001', '47', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK505A', '270', null, '8006', '8011', '8015', '8020', '8001', '52', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK056A', '260', null, '8006', '8010', '8015', '8020', '8001', '55', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK100A', '260', null, '8006', '8011', '8017', '8020', '8001', '59', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL612A', '280', null, '8006', '8013', '8016', '8020', '8001', '63', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL613A', '280', null, '8006', '8012', '8016', '8020', '8001', '64', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL615A', '280', null, '8006', '8013', '8016', '8020', '8001', '70', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL621A', '280', null, '8006', '8010', '8016', '8020', '8001', '73', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL623A', '280', null, '8006', '8011', '8016', '8020', '8001', '75', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL626A', '280', null, '8006', '8013', '8018', '8022', '8001', '78', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL619A', '280', null, '8006', '8013', '8018', '8020', '8001', '83', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL620A', '280', null, '8006', '8011', '8018', '8020', '8001', '84', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL632A', '280', null, '8006', '8010', '8015', '8022', '8001', '87', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL633A', '280', null, '8006', '8013', '8015', '8022', '8001', '88', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL635A', '280', null, '8006', '8013', '8015', '8022', '8001', '90', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL636A', '280', null, '8006', '8012', '8015', '8022', '8001', '91', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL639A', '280', null, '8006', '8013', '8017', '8022', '8001', '94', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL644A', '280', null, '8006', '8011', '8016', '8022', '8001', '99', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL646A', '280', null, '8006', '8013', '8016', '8022', '8001', '101', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL650A', '280', null, '8006', '8011', '8016', '8022', '8001', '105', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL651A', '280', null, '8006', '8012', '8016', '8022', '8001', '106', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL654A', '280', null, '8006', '8011', '8015', '8022', '8001', '109', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL656A', '280', null, '8006', '8010', '8018', '8022', '8001', '111', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL657A', '280', null, '8006', '8012', '8018', '8022', '8001', '112', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL663A', '280', null, '8006', '8011', '8018', '8022', '8001', '118', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL664A', '280', null, '8006', '8012', '8018', '8022', '8001', '119', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL591A', '270', null, '8007', '8012', '8015', '8022', '8001', '126', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL593A', '270', null, '8007', '8013', '8016', '8022', '8001', '130', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL595A', '270', null, '8007', '8011', '8016', '8022', '8001', '132', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL541A', '260', null, '8007', '8011', '8016', '8020', '8001', '135', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL598A', '270', null, '8007', '8013', '8016', '8022', '8001', '137', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL600A', '270', null, '8007', '8013', '8017', '8022', '8001', '140', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL602A', '270', null, '8007', '8013', '8016', '8022', '8001', '142', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL605A', '270', null, '8007', '8013', '8018', '8022', '8001', '148', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL606A', '270', null, '8007', '8013', '8018', '8022', '8001', '149', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL607A', '270', null, '8007', '8010', '8018', '8021', '8001', '150', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL609A', '270', null, '8007', '8010', '8018', '8021', '8001', '152', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL666A', '290', null, '8008', '8013', '8017', '8022', '8001', '155', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL667A', '290', null, '8008', '8012', '8017', '8022', '8001', '156', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL668A', '290', null, '8008', '8013', '8016', '8022', '8001', '157', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL670A', '290', null, '8008', '8013', '8016', '8022', '8001', '159', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBK263A', '300', null, '8008', '8013', '8015', '8022', '8001', '160', '10050', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('MBK268A', '310', null, '8008', '8012', '8015', '8022', '8001', '168', '10050', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('MBK708A', '270', null, '8006', '8010', '8015', '8020', '8001', '19', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK710A', '260', null, '8006', '8010', '8015', '8020', '8001', '22', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK052A', '270', null, '8006', '8013', '8015', '8020', '8001', '24', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL502A', '280', null, '8006', '8013', '8015', '8020', '8001', '27', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL506A', '270', null, '8006', '8011', '8016', '8020', '8001', '35', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK514A', '270', null, '8006', '8011', '8015', '8020', '8001', '32', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL505A', '270', null, '8006', '8013', '8016', '8020', '8001', '34', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBF344A', '270', null, '8006', '8011', '8016', '8020', '8001', '40', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK544A', '270', null, '8006', '8012', '8017', '8020', '8001', '45', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBK538A', '270', null, '8006', '8012', '8015', '8020', '8001', '54', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK548A', '280', null, '8006', '8012', '8015', '8020', '8001', '56', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK549A', '270', null, '8006', '8010', '8015', '8020', '8001', '57', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK103A', '260', null, '8006', '8012', '8015', '8020', '8001', '58', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBK098A', '260', null, '8006', '8013', '8017', '8020', '8001', '60', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('CAK342A', null, null, '8033', '8036', '8041', '8055', '8030', '62', '10050', null, null, '10320', '100/2*100/2');
INSERT INTO "FABRIC" VALUES ('MBG099B', '320', null, '8006', '8011', '8016', '8020', '8001', '67', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBE407A', '260', null, '8006', '8011', '8016', '8020', '8001', '68', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL614A', '280', null, '8006', '8013', '8016', '8020', '8001', '69', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL616A', '280', null, '8006', '8011', '8016', '8020', '8001', '71', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL622A', '280', null, '8006', '8011', '8016', '8020', '8001', '74', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL624A', '280', null, '8006', '8012', '8016', '8020', '8001', '76', '10050', null, null, '10320', '140S');
INSERT INTO "FABRIC" VALUES ('MBL625A', '280', null, '8006', '8013', '8018', '8022', '8001', '77', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL627A', '280', null, '8006', '8010', '8018', '8022', '8001', '79', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL628A', '280', null, '8006', '8011', '8018', '8022', '8001', '80', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL629A', '280', null, '8006', '8012', '8018', '8022', '8001', '81', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL630A', '280', null, '8006', '8010', '8015', '8022', '8001', '85', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL631A', '280', null, '8006', '8010', '8015', '8022', '8001', '86', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL637A', '280', null, '8006', '8013', '8017', '8022', '8001', '92', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL641A', '280', null, '8006', '8012', '8017', '8022', '8001', '96', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL649A', '280', null, '8006', '8010', '8016', '8022', '8001', '104', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL653A', '280', null, '8006', '8013', '8016', '8022', '8001', '108', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL658A', '280', null, '8006', '8013', '8018', '8022', '8001', '113', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL661A', '280', null, '8006', '8012', '8018', '8022', '8001', '116', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL585A', '270', null, '8007', '8010', '8015', '8022', '8001', '120', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL587A', '270', null, '8007', '8013', '8015', '8022', '8001', '122', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL588A', '270', null, '8007', '8013', '8015', '8022', '8001', '123', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL589A', '270', null, '8007', '8013', '8015', '8022', '8001', '124', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL590A', '270', null, '8007', '8011', '8015', '8022', '8001', '125', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL594A', '270', null, '8007', '8010', '8016', '8022', '8001', '131', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL596A', '270', null, '8007', '8011', '8016', '8022', '8001', '133', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL542A', '280', null, '8007', '8011', '8016', '8020', '8001', '136', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBI808A', '310', null, '8007', '8010', '8017', '8020', '8001', '139', '10050', null, null, '10320', '130S');
INSERT INTO "FABRIC" VALUES ('MBL543A', '270', null, '8007', '8013', '8017', '8022', '8001', '143', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL545A', '260', null, '8007', '8012', '8017', '8022', '8001', '145', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL604A', '270', null, '8007', '8010', '8018', '8022', '8001', '147', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBL665A', '290', null, '8008', '8013', '8017', '8022', '8001', '154', '10050', null, null, '10320', '120S');
INSERT INTO "FABRIC" VALUES ('MBK726A', '300', null, '8008', '8012', '8018', '8022', '8001', '163', '10050', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('MBK264A', '300', null, '8008', '8013', '8015', '8022', '8001', '164', '10050', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('MBK267A', '300', '12', '8008', '8012', '8015', '8022', '8001', '165', '10050', null, null, '10320', null);
INSERT INTO "FABRIC" VALUES ('CAM158A', '1', '46', '8032', '8037', '8042', '8055', '8030', '172', '10050', null, null, '10320', '50/1*50/1');
INSERT INTO "FABRIC" VALUES ('MBK551A', '280', '140', '8006', '8010', '8016', '8020', '8001', '174', '10050', null, null, '10320', '140S');

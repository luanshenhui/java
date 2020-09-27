/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.6.13 : Database - iframework
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`iframework` /*!40100 DEFAULT CHARACTER SET utf8 */;

/*Table structure for table `wf_activity` */

DROP TABLE IF EXISTS `wf_activity`;

CREATE TABLE `wf_activity` (
  `ACT_ID` varchar(64) NOT NULL COMMENT '活动ID',
  `PROC_VERSION` varchar(64) NOT NULL COMMENT '流程版本',
  `PROC_ID` varchar(64) NOT NULL COMMENT '流程ID',
  `APP_ID` varchar(64) DEFAULT NULL COMMENT '应用程序ID',
  `ACT_NAME` varchar(64) NOT NULL COMMENT '活动名称',
  `ACT_DESC` varchar(255) DEFAULT NULL COMMENT '活动描述',
  `ACT_TYPE` int(11) NOT NULL COMMENT '活动类型\n            0手动活动，1自动活动，2子流程活动，3开始活动，4完结活动，5分支活动，6并发活动，7聚合活动',
  `OPERATION_LEVEL` int(11) NOT NULL DEFAULT '1' COMMENT '操作级别：0：节点，1：工作项',
  `ASSIGN_RULE` int(11) NOT NULL COMMENT '办理方式\n            0：单人，1：所有人，2：条件，3：角色',
  `AUTO_ACCEPT` int(11) NOT NULL COMMENT '作业项目，自动接受，进入作业中状态\n            0不自动接受，1自动接受',
  `OVERDUE_TIMELIMIT` varchar(32) DEFAULT NULL COMMENT '超时时限',
  `OVERDUE_RDATA` varchar(64) DEFAULT NULL COMMENT '超时变量',
  `OVERDUE_ACTION` int(11) DEFAULT NULL COMMENT '超时动作',
  `OVERDUE_APP` varchar(64) DEFAULT NULL COMMENT '超时应用',
  `REMIND_TIMELIMIT` varchar(32) DEFAULT NULL COMMENT '催办时限',
  `REMIND_RDATA` varchar(64) DEFAULT NULL COMMENT '催办变量',
  `REMIND_ACTION` int(11) DEFAULT NULL COMMENT '催办动作',
  `REMIND_APP` varchar(64) DEFAULT NULL COMMENT '催办应用',
  `REMIND_INTERVAL` varchar(32) DEFAULT NULL COMMENT '催办间隔',
  `REMIND_COUNT` int(11) DEFAULT NULL COMMENT '催办次数',
  `EXTEND_PROP` varchar(1024) DEFAULT NULL COMMENT '扩展属性',
  `PRE_CONDITION` varchar(1024) DEFAULT NULL COMMENT '前置条件',
  `POST_CONDITION` varchar(1024) DEFAULT NULL COMMENT '后置条件',
  `MERGE_ACT_ID` varchar(64) DEFAULT NULL COMMENT '汇聚活动ID',
  `MERGE_TYPE` int(11) DEFAULT NULL COMMENT '汇聚类型\n            0与汇聚，1条件汇聚',
  PRIMARY KEY (`ACT_ID`),
  KEY `FK_REL_WF_ACTIVITIES` (`PROC_VERSION`,`PROC_ID`),
  KEY `FK_REL_WF_ACTIVITY_APP` (`APP_ID`),
  CONSTRAINT `FK_REL_WF_ACTIVITIES` FOREIGN KEY (`PROC_VERSION`, `PROC_ID`) REFERENCES `wf_process` (`PROC_VERSION`, `PROC_ID`),
  CONSTRAINT `FK_REL_WF_ACTIVITY_APP` FOREIGN KEY (`APP_ID`) REFERENCES `wf_application` (`APP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动';

/*Data for the table `wf_activity` */

insert  into `wf_activity`(`ACT_ID`,`PROC_VERSION`,`PROC_ID`,`APP_ID`,`ACT_NAME`,`ACT_DESC`,`ACT_TYPE`,`OPERATION_LEVEL`,`ASSIGN_RULE`,`AUTO_ACCEPT`,`OVERDUE_TIMELIMIT`,`OVERDUE_RDATA`,`OVERDUE_ACTION`,`OVERDUE_APP`,`REMIND_TIMELIMIT`,`REMIND_RDATA`,`REMIND_ACTION`,`REMIND_APP`,`REMIND_INTERVAL`,`REMIND_COUNT`,`EXTEND_PROP`,`PRE_CONDITION`,`POST_CONDITION`,`MERGE_ACT_ID`,`MERGE_TYPE`) values ('1439625872990','1','4b3cbbd13eb3424880424d4e2034dbf2',NULL,'开始活动',NULL,3,1,0,0,NULL,NULL,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),('1439625890948','1','4b3cbbd13eb3424880424d4e2034dbf2',NULL,'报销申请',NULL,0,1,0,1,'0',NULL,0,NULL,'0',NULL,0,NULL,'0',NULL,NULL,NULL,NULL,NULL,0),('1439625893956','1','4b3cbbd13eb3424880424d4e2034dbf2',NULL,'报销审核',NULL,0,1,0,1,'0',NULL,0,NULL,'0',NULL,0,NULL,'0',NULL,NULL,NULL,NULL,NULL,0),('1439625897148','1','4b3cbbd13eb3424880424d4e2034dbf2',NULL,'报销打款',NULL,0,1,0,1,'0',NULL,0,NULL,'0',NULL,0,NULL,'0',NULL,NULL,NULL,NULL,NULL,0),('1439625900091','1','4b3cbbd13eb3424880424d4e2034dbf2',NULL,'结束活动',NULL,4,1,0,0,NULL,NULL,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0);

/*Table structure for table `wf_activity_event` */

DROP TABLE IF EXISTS `wf_activity_event`;

CREATE TABLE `wf_activity_event` (
  `ACT_EVENT_ID` varchar(64) NOT NULL COMMENT '活动事件ID',
  `ACT_ID` varchar(64) NOT NULL COMMENT '活动ID',
  `APP_ID` varchar(64) NOT NULL COMMENT '应用程序ID',
  `ACT_EVENT_CATE` int(11) NOT NULL COMMENT '事件分类。0：活动实例事件 1：作业项目事件',
  `ACT_EVENT_TYPE` int(11) NOT NULL COMMENT '事件类型\n            活动事件：0初始化，1开始，3挂起，4恢复，5激活，6去活化，7放弃，8完成\n            作业项事件：\n            0初始化，1接收，2暂停，3暂停恢复，4取消接收，5终止/放弃，6完成',
  PRIMARY KEY (`ACT_EVENT_ID`),
  KEY `FK_REL_WF_ACT_EVENT` (`ACT_ID`),
  KEY `FK_REL_WF_ACT_EVENT_APP` (`APP_ID`),
  CONSTRAINT `FK_REL_WF_ACT_EVENT` FOREIGN KEY (`ACT_ID`) REFERENCES `wf_activity` (`ACT_ID`),
  CONSTRAINT `FK_REL_WF_ACT_EVENT_APP` FOREIGN KEY (`APP_ID`) REFERENCES `wf_application` (`APP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动事件';

/*Data for the table `wf_activity_event` */

/*Table structure for table `wf_activity_instance` */

DROP TABLE IF EXISTS `wf_activity_instance`;

CREATE TABLE `wf_activity_instance` (
  `ACTIVITY_INST_ID` varchar(64) NOT NULL COMMENT '活动实例ID',
  `PROC_INSTANCE_ID` varchar(64) NOT NULL COMMENT '流程实例ID',
  `ACTIVITY_ID` varchar(64) NOT NULL COMMENT '活动定义ID',
  `PREV_ACT_INST_ID` varchar(1024) DEFAULT NULL COMMENT '前一活动实例ID',
  `MERGE_ACT_ID` varchar(64) DEFAULT NULL COMMENT '汇聚活动ID',
  `NAME` varchar(64) DEFAULT NULL COMMENT '活动实例名称',
  `TYPE` int(11) DEFAULT NULL COMMENT '活动实例类型',
  `SUB_PROCESS_ID` varchar(64) DEFAULT NULL COMMENT '子流程定义',
  `SUB_PROC_INST_ID` varchar(64) DEFAULT NULL COMMENT '子流程实例ID',
  `APPLICATION_ID` varchar(64) DEFAULT NULL COMMENT '应用程序',
  `CURRENT_STATUS` int(11) NOT NULL COMMENT '当前状态',
  `HAS_OVERTIME` int(11) DEFAULT NULL COMMENT '是否已超时，0未超时，1已超时',
  `HAS_REMINDER` int(11) DEFAULT NULL COMMENT '是否已催办。0未催办，1已催办',
  `PARALLELTYPE` int(11) DEFAULT NULL COMMENT '并行类型',
  `WHENOVERTIME` int(11) DEFAULT NULL COMMENT '超时时间',
  `SUSPEND_COUNT` int(11) DEFAULT NULL COMMENT '挂起时间',
  `EXT_PROP` varchar(1024) DEFAULT NULL COMMENT '扩展属性',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `COMPLETE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '完成时间',
  `HAS_WORKITEM` int(11) DEFAULT NULL COMMENT '是否创建了工作项',
  `BUSINESS_ID` varchar(64) DEFAULT NULL COMMENT '业务主键',
  `PASSEL_ID` varchar(1024) NOT NULL COMMENT '批次号',
  `PARALLEL_PATH` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`ACTIVITY_INST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动实例';

/*Data for the table `wf_activity_instance` */

insert  into `wf_activity_instance`(`ACTIVITY_INST_ID`,`PROC_INSTANCE_ID`,`ACTIVITY_ID`,`PREV_ACT_INST_ID`,`MERGE_ACT_ID`,`NAME`,`TYPE`,`SUB_PROCESS_ID`,`SUB_PROC_INST_ID`,`APPLICATION_ID`,`CURRENT_STATUS`,`HAS_OVERTIME`,`HAS_REMINDER`,`PARALLELTYPE`,`WHENOVERTIME`,`SUSPEND_COUNT`,`EXT_PROP`,`CREATE_TIME`,`COMPLETE_TIME`,`HAS_WORKITEM`,`BUSINESS_ID`,`PASSEL_ID`,`PARALLEL_PATH`) values ('81b05f75bbf04f1e9c4a98c76af76614','102a9fa9cdee42f297f050a6eb4e6d68','1439625872990',NULL,NULL,'开始活动',3,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-15 16:15:12','2015-08-15 16:15:12',0,NULL,'ede5ab0c42b442b6849bc33bf9a97993',NULL),('b86fa59ddc3a412e95e1c9bc437ef124','102a9fa9cdee42f297f050a6eb4e6d68','1439625900091','bd3acd6d572c434db27aa8fdc8bc25dc',NULL,'结束活动',4,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-15 16:33:23','2015-08-15 16:33:23',0,NULL,'ede5ab0c42b442b6849bc33bf9a97993',NULL),('bd3acd6d572c434db27aa8fdc8bc25dc','102a9fa9cdee42f297f050a6eb4e6d68','1439625897148','fd13e85d448749fcb313da8371e32c40',NULL,'报销打款',0,NULL,NULL,NULL,5,0,0,NULL,NULL,0,NULL,'2015-08-15 16:33:23','2015-08-15 16:33:23',1,NULL,'ede5ab0c42b442b6849bc33bf9a97993',NULL),('e9b7e9c57bd24e39a892a9bf1e9c6fa2','102a9fa9cdee42f297f050a6eb4e6d68','1439625890948','81b05f75bbf04f1e9c4a98c76af76614',NULL,'报销申请',0,NULL,NULL,NULL,5,0,0,NULL,NULL,0,NULL,'2015-08-15 16:15:22','2015-08-15 16:15:22',1,NULL,'ede5ab0c42b442b6849bc33bf9a97993',NULL),('fd13e85d448749fcb313da8371e32c40','102a9fa9cdee42f297f050a6eb4e6d68','1439625893956','e9b7e9c57bd24e39a892a9bf1e9c6fa2',NULL,'报销审核',0,NULL,NULL,NULL,5,0,0,NULL,NULL,0,NULL,'2015-08-15 16:31:23','2015-08-15 16:31:23',1,NULL,'ede5ab0c42b442b6849bc33bf9a97993',NULL);

/*Table structure for table `wf_activity_instance_h` */

DROP TABLE IF EXISTS `wf_activity_instance_h`;

CREATE TABLE `wf_activity_instance_h` (
  `ACTIVITY_INST_ID` varchar(64) NOT NULL COMMENT '活动实例ID',
  `PROC_INSTANCE_ID` varchar(64) NOT NULL COMMENT '流程实例ID',
  `ACTIVITY_ID` varchar(64) NOT NULL COMMENT '活动定义ID',
  `PREV_ACT_INST_ID` varchar(1024) DEFAULT NULL COMMENT '前一活动实例ID',
  `MERGE_ACT_ID` varchar(64) DEFAULT NULL COMMENT '汇聚活动ID',
  `NAME` varchar(64) DEFAULT NULL COMMENT '活动实例名称',
  `TYPE` int(11) DEFAULT NULL COMMENT '活动实例类型',
  `SUB_PROCESS_ID` varchar(64) DEFAULT NULL COMMENT '子流程定义',
  `SUB_PROC_INST_ID` varchar(64) DEFAULT NULL COMMENT '子流程实例ID',
  `APPLICATION_ID` varchar(64) DEFAULT NULL COMMENT '应用程序',
  `CURRENT_STATUS` int(11) NOT NULL COMMENT '当前状态',
  `HAS_OVERTIME` int(11) DEFAULT NULL COMMENT '是否已超时，0未超时，1已超时',
  `HAS_REMINDER` int(11) DEFAULT NULL COMMENT '是否已催办。0未催办，1已催办',
  `PARALLELTYPE` int(11) DEFAULT NULL COMMENT '并行类型',
  `WHENOVERTIME` int(11) DEFAULT NULL COMMENT '超时时间',
  `SUSPEND_COUNT` int(11) DEFAULT NULL COMMENT '挂起时间',
  `EXT_PROP` varchar(1024) DEFAULT NULL COMMENT '扩展属性',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `COMPLETE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '完成时间',
  `HAS_WORKITEM` int(11) DEFAULT NULL COMMENT '是否创建了工作项',
  `BUSINESS_ID` varchar(64) DEFAULT NULL COMMENT '业务主键',
  `PASSEL_ID` varchar(1024) NOT NULL COMMENT '批次号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动实例_历史';

/*Data for the table `wf_activity_instance_h` */

/*Table structure for table `wf_activity_participant` */

DROP TABLE IF EXISTS `wf_activity_participant`;

CREATE TABLE `wf_activity_participant` (
  `ACT_PARTI_ID` varchar(64) NOT NULL COMMENT '活动参与者ID',
  `ACT_ID` varchar(64) NOT NULL COMMENT '活动ID',
  `IS_KEY_PARTI` int(11) NOT NULL COMMENT '是否主送参与者：0：否，1：是。',
  `PARTICIPANT_TYPE` int(11) NOT NULL COMMENT '参与者类型。\n            0人员，1角色，2组织单元，3岗位，4相关数据，5流程实例创建者',
  `PARTICIPANT_ID` varchar(64) NOT NULL COMMENT '参与者ID',
  `PARTICIPANT_NAME` varchar(64) DEFAULT NULL COMMENT '参与者名称',
  PRIMARY KEY (`ACT_PARTI_ID`),
  KEY `FK_REL_WF_ACTI_PARTI` (`ACT_ID`),
  CONSTRAINT `FK_REL_WF_ACTI_PARTI` FOREIGN KEY (`ACT_ID`) REFERENCES `wf_activity` (`ACT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动参与者';

/*Data for the table `wf_activity_participant` */

insert  into `wf_activity_participant`(`ACT_PARTI_ID`,`ACT_ID`,`IS_KEY_PARTI`,`PARTICIPANT_TYPE`,`PARTICIPANT_ID`,`PARTICIPANT_NAME`) values ('269db20681724a12a9d67b4f1ca43a1e','1439625890948',1,5,'processInitCreator','实例创建者'),('9d3a42c934f141e0a5fd5fe815542279','1439625897148',1,3,'583512e1eb784dadb0d53fa9dca4d381','出纳'),('b102b9fe38394b1582ca72106773028a','1439625893956',1,3,'bf11d09d35b54d2f8d36e4f045d5d85e','财务部经理');

/*Table structure for table `wf_activity_subproc` */

DROP TABLE IF EXISTS `wf_activity_subproc`;

CREATE TABLE `wf_activity_subproc` (
  `ACT_SUBPROC_ID` varchar(64) NOT NULL COMMENT '活动子流程ID',
  `ACT_ID` varchar(64) DEFAULT NULL COMMENT '活动ID',
  `COUPLE_TYPE` int(11) DEFAULT NULL COMMENT '是否紧耦合。1：紧耦合，0：松耦合',
  `SUB_PROC_ID` varchar(64) DEFAULT NULL COMMENT '紧耦合流程ID',
  `SUB_PROC_VER` varchar(64) DEFAULT NULL COMMENT '紧耦合流程版本',
  `IS_ASYNC` int(11) DEFAULT NULL COMMENT '是否异步\n            1：异步，0：同步',
  `IS_STATIC_SUBPROC` int(11) DEFAULT NULL COMMENT '是否静态子流程，1：静态子流程，0：动态子流程',
  `DYN_SUBPROC_RDATA` varchar(64) DEFAULT NULL COMMENT '存放动态子流程的ID+VERSION的相关数据变量',
  PRIMARY KEY (`ACT_SUBPROC_ID`),
  KEY `FK_REL_WF_ACT_SUBPROC` (`ACT_ID`),
  CONSTRAINT `FK_REL_WF_ACT_SUBPROC` FOREIGN KEY (`ACT_ID`) REFERENCES `wf_activity` (`ACT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活动子流程';

/*Data for the table `wf_activity_subproc` */

/*Table structure for table `wf_application` */

DROP TABLE IF EXISTS `wf_application`;

CREATE TABLE `wf_application` (
  `APP_ID` varchar(64) NOT NULL COMMENT '应用程序ID',
  `PROC_VERSION` varchar(64) NOT NULL COMMENT '流程版本',
  `PROC_ID` varchar(64) NOT NULL COMMENT '流程ID',
  `APP_NAME` varchar(32) NOT NULL COMMENT '应用程序名称',
  `APP_DESC` varchar(255) DEFAULT NULL COMMENT '应用程序描述',
  `SYNCH_OR_ASYNCH` int(11) NOT NULL COMMENT '同步异步\n            0同步，1异步',
  `APP_TYPE` int(11) NOT NULL COMMENT '应用程序类型\n            0：Java，1：WebService，2：URL，3：EXE',
  `APP_URL` varchar(1024) DEFAULT NULL COMMENT '应用程序URL',
  `APP_HOST` varchar(32) DEFAULT NULL COMMENT '应用程序主机地址',
  PRIMARY KEY (`APP_ID`),
  KEY `FK_REL_WF_PROC_APPLICATION` (`PROC_VERSION`,`PROC_ID`),
  CONSTRAINT `FK_REL_WF_PROC_APPLICATION` FOREIGN KEY (`PROC_VERSION`, `PROC_ID`) REFERENCES `wf_process` (`PROC_VERSION`, `PROC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应用程序';

/*Data for the table `wf_application` */

/*Table structure for table `wf_appmsg_queue` */

DROP TABLE IF EXISTS `wf_appmsg_queue`;

CREATE TABLE `wf_appmsg_queue` (
  `MESSAGE_ID` varchar(64) NOT NULL COMMENT '消息标识',
  `MSG_APP_TYPE` varchar(64) DEFAULT NULL COMMENT '消息应用类型',
  `BUILDTIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `PRIORITY` int(11) DEFAULT '0' COMMENT '优先级',
  `EVENT_SOURCE` varchar(64) DEFAULT NULL COMMENT '事件来源',
  `SOURCE_OPERATION` int(11) NOT NULL COMMENT '来源操作人',
  `STATE` int(11) DEFAULT NULL COMMENT '状态',
  `TYPE` int(11) NOT NULL COMMENT '类型',
  `BODY` varchar(3000) DEFAULT NULL COMMENT '消息体',
  `HOST_ADDRESS` varchar(64) DEFAULT NULL COMMENT '主机地址',
  `LOCKOWNER` varchar(100) DEFAULT NULL COMMENT '锁定所有者',
  `LOCKTIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '锁定时间',
  `RETRIES` int(11) DEFAULT '0' COMMENT '重试次数',
  `EXCEPTION` varchar(4000) DEFAULT NULL COMMENT '异常信息',
  `VERSION` int(11) DEFAULT '0' COMMENT '版本号',
  PRIMARY KEY (`MESSAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应用程序消息队列';

/*Data for the table `wf_appmsg_queue` */

/*Table structure for table `wf_biz_category` */

DROP TABLE IF EXISTS `wf_biz_category`;

CREATE TABLE `wf_biz_category` (
  `BIZ_CATE_ID` varchar(64) NOT NULL COMMENT '分类ID',
  `BIZ_CATE_PARENT_ID` varchar(64) DEFAULT NULL COMMENT '父分类ID',
  `BIZ_CATE_NAME` varchar(64) NOT NULL COMMENT '分类名称',
  `BIZ_CATE_DESC` varchar(128) DEFAULT NULL COMMENT '分类描述',
  PRIMARY KEY (`BIZ_CATE_ID`),
  KEY `FK_REL_WF_PARENT_CATEGORY` (`BIZ_CATE_PARENT_ID`),
  CONSTRAINT `FK_REL_WF_PARENT_CATEGORY` FOREIGN KEY (`BIZ_CATE_PARENT_ID`) REFERENCES `wf_biz_category` (`BIZ_CATE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务分类';

/*Data for the table `wf_biz_category` */

insert  into `wf_biz_category`(`BIZ_CATE_ID`,`BIZ_CATE_PARENT_ID`,`BIZ_CATE_NAME`,`BIZ_CATE_DESC`) values ('1d370556bb344eb2ac611d9788682912',NULL,'办公自动化',NULL);

/*Table structure for table `wf_org_delegate` */

DROP TABLE IF EXISTS `wf_org_delegate`;

CREATE TABLE `wf_org_delegate` (
  `DELE_ID` varchar(32) NOT NULL COMMENT '权限代理ID',
  `USER_ID` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `TRUSTOR_ID` varchar(32) DEFAULT NULL COMMENT '用户ID',
  `DELE_NAME` varchar(32) NOT NULL COMMENT '权限代理名称',
  `DELE_DESCRIPTION` varchar(255) DEFAULT NULL COMMENT '权限代理描述信息',
  `DELE_TIME_BEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '权限代理生效时间',
  `DELE_TIME_END` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '权限代理失效时间',
  `DELE_ALL_PRIVIL` char(1) NOT NULL COMMENT '是否委托所有权限（包括组织、岗位、角色）1是，0否',
  PRIMARY KEY (`DELE_ID`),
  KEY `AK_AK_SYS_C006453_JT_ORG_D` (`DELE_NAME`),
  KEY `FK_FK_JT_ORG_D_TRUSTEE_I_JT_ORG_U` (`USER_ID`),
  KEY `FK_FK_JT_ORG_D_TRUSTOR_I_JT_ORG_U` (`TRUSTOR_ID`),
  CONSTRAINT `FK_FK_JT_ORG_D_TRUSTEE_I_JT_ORG_U` FOREIGN KEY (`USER_ID`) REFERENCES `wf_org_user` (`USER_ID`),
  CONSTRAINT `FK_FK_JT_ORG_D_TRUSTOR_I_JT_ORG_U` FOREIGN KEY (`TRUSTOR_ID`) REFERENCES `wf_org_user` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_delegate` */

insert  into `wf_org_delegate`(`DELE_ID`,`USER_ID`,`TRUSTOR_ID`,`DELE_NAME`,`DELE_DESCRIPTION`,`DELE_TIME_BEGIN`,`DELE_TIME_END`,`DELE_ALL_PRIVIL`) values ('bcb4edf06ff341b7adb5b2d28b0f1c89','adminUser','07b73cc563634ac29251cc9df679a855','lsh','66','2017-04-21 16:37:39','2017-04-29 16:37:44','0');

/*Table structure for table `wf_org_deleitem` */

DROP TABLE IF EXISTS `wf_org_deleitem`;

CREATE TABLE `wf_org_deleitem` (
  `DELE_ID` varchar(32) NOT NULL COMMENT '权限代理ID',
  `DI_PRIV_ID` varchar(32) NOT NULL COMMENT '权限id（组织、岗位、角色）',
  `DI_PRIV_TYPE` varchar(15) NOT NULL COMMENT '权限类型（ORG、STATION、ROLE）',
  `DI_PRIV_NAME` varchar(32) DEFAULT NULL COMMENT '权限名称（组织、岗位、角色）',
  PRIMARY KEY (`DELE_ID`,`DI_PRIV_ID`),
  CONSTRAINT `FK_FK_JT_ORG_D_DELE_ID_JT_ORG_D` FOREIGN KEY (`DELE_ID`) REFERENCES `wf_org_delegate` (`DELE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_deleitem` */

insert  into `wf_org_deleitem`(`DELE_ID`,`DI_PRIV_ID`,`DI_PRIV_TYPE`,`DI_PRIV_NAME`) values ('bcb4edf06ff341b7adb5b2d28b0f1c89','00ecd710ce874576a9342996142cee7e','ORG','财务部');

/*Table structure for table `wf_org_dictionary` */

DROP TABLE IF EXISTS `wf_org_dictionary`;

CREATE TABLE `wf_org_dictionary` (
  `DICT_CODE` varchar(32) NOT NULL COMMENT '编号',
  `DICT_NAME` varchar(32) NOT NULL COMMENT '名称',
  `DICT_TYPE` varchar(32) NOT NULL COMMENT '类型：组织类型unittype、元素类型element',
  PRIMARY KEY (`DICT_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_dictionary` */

insert  into `wf_org_dictionary`(`DICT_CODE`,`DICT_NAME`,`DICT_TYPE`) values ('CODE1','部门','unittype'),('CODE2','按钮','element'),('CODE3','文本框','element'),('CODE4','下拉列表','element');

/*Table structure for table `wf_org_fw_favorite_t` */

DROP TABLE IF EXISTS `wf_org_fw_favorite_t`;

CREATE TABLE `wf_org_fw_favorite_t` (
  `MENU_CODE` varchar(32) NOT NULL COMMENT '菜单编号',
  `USER_ID` varchar(16) NOT NULL COMMENT '用户id',
  `SYSTEM_ID` varchar(4) DEFAULT NULL COMMENT '菜单所在的系统（一级菜单）',
  `FAVORITE_NAME` varchar(64) NOT NULL COMMENT '快捷收藏显示名称',
  `FAVORITE_ORDER` decimal(4,0) DEFAULT NULL COMMENT '快捷收藏显示顺序',
  `PAGE_LINK` varchar(384) NOT NULL COMMENT '菜单链接地址'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_fw_favorite_t` */

/*Table structure for table `wf_org_fw_mainpage` */

DROP TABLE IF EXISTS `wf_org_fw_mainpage`;

CREATE TABLE `wf_org_fw_mainpage` (
  `RESOURCEID` varchar(2) NOT NULL,
  `RESOURCETYPE` varchar(10) NOT NULL COMMENT 'MAINPAGE',
  `RESOURCENAME` varchar(20) NOT NULL COMMENT '名称',
  `RESOURCEVALUE` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_fw_mainpage` */

/*Table structure for table `wf_org_menu` */

DROP TABLE IF EXISTS `wf_org_menu`;

CREATE TABLE `wf_org_menu` (
  `MENU_CODE` varchar(32) NOT NULL COMMENT '菜单编号',
  `PARENT_MENU_CODE` varchar(32) DEFAULT NULL COMMENT '菜单编号',
  `MENU_NAME` varchar(32) NOT NULL COMMENT '菜单名称',
  `MENU_AREA` varchar(32) DEFAULT NULL COMMENT '目标区域',
  `MENU_LOCATION` varchar(256) DEFAULT NULL COMMENT '菜单位置',
  `MENU_IMG_LOCATION` varchar(256) DEFAULT NULL COMMENT '图片位置',
  `MENU_DESC` varchar(256) DEFAULT NULL COMMENT '菜单描述',
  `MENU_LEVEL` decimal(6,0) NOT NULL COMMENT '菜单级别',
  `MENU_ORDER` decimal(6,0) NOT NULL COMMENT '菜单排序',
  `MENU_TYPE` varchar(15) DEFAULT NULL COMMENT '菜单类型:menu，element',
  `MENU_IS_DEFAULT` varchar(1) NOT NULL COMMENT '是否缺省菜单项,1：缺省菜单，0：非缺省菜单',
  `MENU_ELEMENT_ID` varchar(32) DEFAULT NULL COMMENT '页面元素ID',
  `MENU_ELEMENT_TYPE` varchar(32) DEFAULT NULL COMMENT '页面元素类型',
  `MENU_CATEGORY` varchar(32) DEFAULT NULL COMMENT '菜单业务类型',
  PRIMARY KEY (`MENU_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_menu` */

insert  into `wf_org_menu`(`MENU_CODE`,`PARENT_MENU_CODE`,`MENU_NAME`,`MENU_AREA`,`MENU_LOCATION`,`MENU_IMG_LOCATION`,`MENU_DESC`,`MENU_LEVEL`,`MENU_ORDER`,`MENU_TYPE`,`MENU_IS_DEFAULT`,`MENU_ELEMENT_ID`,`MENU_ELEMENT_TYPE`,`MENU_CATEGORY`) values ('03222a9c04b94d29a3ae059ceefee9a3','408eb15dc9c540a3b524c04012e36496','岗位明细页面','content','/view/organization/position/StationDetail.jsp',NULL,NULL,3,1,'PAGE','0','StationDetail.jsp',NULL,NULL),('0ab5187d2d3c452cb3f5295f3f832ab8','8197b1234b0840afb7bc4c0ff9f7ac4a','管理授权','content','/view/authorization/privilege/PrivilegeMain.jsp?isAdminRole=true',NULL,'管理授权菜单项',2,6,'MENU','0',NULL,NULL,NULL),('0ee43a36ef0f4c8ea776dde2ca3c234b','50aa7e98aee045eb9c0fa4f4630b49a9','应用监控','content','/view/workflow/management/monitor/ApplicationMonitor.jsp','','',2,5,'MENU','0',NULL,NULL,NULL),('1','RootMenu','首页','content','/index.jsp',NULL,NULL,1,1,'MENU','0',NULL,NULL,NULL),('12f2ec1d60d8420f992be85047d559be','882260d847dd45eaa2e5b305c782e77a','用户权限调整页面','content','/view/organization/user/UserPrivilegeAdjust.jsp',NULL,NULL,3,2,'PAGE','0','UserPrivilegeAdjust.jsp',NULL,NULL),('13df40b814524b21b8ceb2db2d6ccef3','6f6ff146e3d9452db3df9c8a82d3f4ff','角色列表页面','content','/view/organization/role/RoleList.jsp',NULL,NULL,3,0,'PAGE','0','RoleList.jsp',NULL,NULL),('2bf86444b1da45bfa6c907914787fa79','50aa7e98aee045eb9c0fa4f4630b49a9','人员效率报表','content','/view/workflow/report/peopleReport.jsp','','',2,8,'MENU','0',NULL,NULL,NULL),('2e1a2b75d64345509386ce0ba7a0ba52','50aa7e98aee045eb9c0fa4f4630b49a9','流程监控','content','/view/workflow/management/monitor/ProcInstMonitor.jsp','','',2,3,'MENU','0',NULL,NULL,NULL),('39cdc2a0f634443a9023442360f833f9','a5e2a683102143cc8afa5e9700200200','委托列表页面','content','/view/authorization/delegate/DelegateList.jsp',NULL,NULL,3,0,'PAGE','0','DelegateList.jsp',NULL,NULL),('3d4335ad78d24bbf90c8178bf0e57505','50aa7e98aee045eb9c0fa4f4630b49a9','待办作业','content','/view/workflow/management/workitem/todo.jsp','','',2,1,'MENU','0',NULL,NULL,NULL),('408eb15dc9c540a3b524c04012e36496','8197b1234b0840afb7bc4c0ff9f7ac4a','岗位管理','content','/view/organization/position/StationMain.jsp',NULL,'岗位管理菜单项',2,2,'MENU','0',NULL,NULL,NULL),('4dd66e7c1530465c84943796e2a56a39','50aa7e98aee045eb9c0fa4f4630b49a9','已办作业','content','/view/workflow/management/workitem/history.jsp','','',2,2,'MENU','0',NULL,NULL,NULL),('50316aa3e45f459c881f748498adae39','8197b1234b0840afb7bc4c0ff9f7ac4a','业务授权','content','/view/authorization/privilege/PrivilegeMain.jsp',NULL,'业务授权菜单项',2,5,'MENU','0',NULL,NULL,NULL),('50aa7e98aee045eb9c0fa4f4630b49a9','RootMenu','业务流程管理','content','','','',1,3,'MENU','0',NULL,NULL,NULL),('6b238bfeef244f07a286097f38ff20ac','6f6ff146e3d9452db3df9c8a82d3f4ff','角色明细页面','content','/view/organization/role/RoleDetail.jsp',NULL,NULL,3,1,'PAGE','0','RoleDetail.jsp',NULL,NULL),('6e3b76aabbb94fafb35854e606dd7edd','9725e3dd0eeb440ab76771c21a2e271b','菜单管理页面','content','/view/authorization/menu/MenuMain.jsp',NULL,NULL,3,0,'PAGE','0','MenuMain.jsp',NULL,NULL),('6f6ff146e3d9452db3df9c8a82d3f4ff','8197b1234b0840afb7bc4c0ff9f7ac4a','角色管理','content','/view/organization/role/RoleList.jsp',NULL,'角色管理菜单项',2,1,'MENU','0',NULL,NULL,NULL),('707862dd326342f0af5c57d4a4a94d0f','50aa7e98aee045eb9c0fa4f4630b49a9','流程定义报表','content','/view/workflow/report/processDefineReport.jsp','','',2,7,'MENU','0',NULL,NULL,NULL),('7895a531479d4292a6f910ac23c8ece4','882260d847dd45eaa2e5b305c782e77a','用户列表页面','content','/view/organization/user/UserList.jsp',NULL,NULL,3,0,'PAGE','0','UserList.jsp',NULL,NULL),('8197b1234b0840afb7bc4c0ff9f7ac4a','RootMenu','系统管理','content','/view/organization/unit/UnitTree.jsp',NULL,'系统管理菜单项',1,2,'MENU','0',NULL,NULL,NULL),('882260d847dd45eaa2e5b305c782e77a','8197b1234b0840afb7bc4c0ff9f7ac4a','人员管理','content','/view/organization/user/UserList.jsp',NULL,'人员管理菜单项',2,3,'MENU','0',NULL,NULL,NULL),('8ed15648ada44b2c99053b0694bbf920','882260d847dd45eaa2e5b305c782e77a','用户选择页面','content','/view/organization/user/UserSelect.jsp',NULL,NULL,3,3,'PAGE','0','UserSelect.jsp',NULL,NULL),('9039de2a9f0649ca842ea0db8fbde4fd','9fe27d00c8dd4b35b1912b1dd2d426d3','组织树页面','content','/view/organization/unit/UnitTree.jsp',NULL,NULL,3,0,'PAGE','0','UnitTree.jsp',NULL,NULL),('96d483f8153b4d08b96beed3c64ba84e','9fe27d00c8dd4b35b1912b1dd2d426d3','组织明细页面','content','/view/organization/unit/UnitDetail.jsp',NULL,NULL,3,1,'PAGE','0','UnitDetail.jsp',NULL,NULL),('9725e3dd0eeb440ab76771c21a2e271b','8197b1234b0840afb7bc4c0ff9f7ac4a','菜单管理','content','/view/authorization/menu/MenuMain.jsp',NULL,'菜单管理菜单项',2,4,'MENU','0',NULL,NULL,NULL),('9af760c399f446169bc4934b9a3ad596','a5e2a683102143cc8afa5e9700200200','委托明细页面','content','/view/authorization/delegate/DelegateDetail.jsp',NULL,NULL,3,0,'PAGE','0','DelegateDetail.jsp',NULL,NULL),('9c548aa7ce5144329d6e98c7dddb8eae','50aa7e98aee045eb9c0fa4f4630b49a9','超时监控','content','/view/workflow/management/monitor/OvertimeReminderMonitor.jsp','','',2,4,'MENU','0',NULL,NULL,NULL),('9d2aa5b97a354541b4bb8ead7a0c974b','9fe27d00c8dd4b35b1912b1dd2d426d3','组织选择页面','content','/view/organization/unit/UnitSelect.jsp',NULL,NULL,3,2,'PAGE','0','UnitSelect.jsp',NULL,NULL),('9fe27d00c8dd4b35b1912b1dd2d426d3','8197b1234b0840afb7bc4c0ff9f7ac4a','组织管理','content','/view/organization/unit/UnitTree.jsp',NULL,'组织管理菜单项',2,0,'MENU','0',NULL,NULL,NULL),('a5e2a683102143cc8afa5e9700200200','8197b1234b0840afb7bc4c0ff9f7ac4a','权限委托','content','/view/authorization/delegate/DelegateList.jsp',NULL,'权限委托菜单项',2,7,'MENU','0',NULL,NULL,NULL),('aac5fc7d73424c8ab3c84f393269474a','8197b1234b0840afb7bc4c0ff9f7ac4a','新建页面','content',NULL,NULL,NULL,2,8,'PAGE','0',NULL,NULL,NULL),('b07f4f873eab4b44b7dbb38a1ff9cdc5','6f6ff146e3d9452db3df9c8a82d3f4ff','角色选择页面','content','/view/organization/role/RoleSelect.jsp',NULL,NULL,3,2,'PAGE','0','RoleSelect.jsp',NULL,NULL),('bc5357be429846ba8f61ccb33853926a','50aa7e98aee045eb9c0fa4f4630b49a9','流程设计','content','/view/workflow/wfbizcategory/WfBizCategoryList.jsp','','',2,0,'MENU','0',NULL,NULL,NULL),('bc65d63baa7f42ae84ab5ca64c6ef59e','408eb15dc9c540a3b524c04012e36496','岗位树页面','content','/view/organization/position/StationMain.jsp',NULL,NULL,3,0,'PAGE','0','StationMain.jsp',NULL,NULL),('d2eec7d5211d454d8f804a9ef4b4d865','9fe27d00c8dd4b35b1912b1dd2d426d3','岗位选择页面','content','/view/organization/unit/StationSelect.jsp',NULL,NULL,3,3,'PAGE','0','StationSelect.jsp',NULL,NULL),('f24d4b501ce84fb79e5634026dc0f8a3','0ab5187d2d3c452cb3f5295f3f832ab8','管理授权管理页面','content','/view/authorization/privilege/PrivilegeMain.jsp?isAdminRole=true',NULL,NULL,3,0,'PAGE','0','PrivilegeMain.jsp',NULL,NULL),('f56914f1ca2d47a3a341d212b3ddf6be','882260d847dd45eaa2e5b305c782e77a','用户明细页面','content','/view/organization/user/UserDetail.jsp',NULL,NULL,3,1,'PAGE','0','UserDetail.jsp',NULL,NULL),('f90a02125b5b45e88beb8775034a1264','50316aa3e45f459c881f748498adae39','业务授权管理页面','content','/view/authorization/privilege/PrivilegeMain.jsp',NULL,NULL,3,0,'PAGE','0','PrivilegeMain.jsp',NULL,NULL),('fb1f0faa7f1e4e289b0d7b6feca26f81','50aa7e98aee045eb9c0fa4f4630b49a9','流程实例报表','content','/view/workflow/report/processInstanceReport.jsp','','',2,6,'MENU','0',NULL,NULL,NULL),('RootMenu',NULL,'RootMenu',NULL,NULL,NULL,NULL,0,0,NULL,'0',NULL,NULL,NULL);

/*Table structure for table `wf_org_resource_authority` */

DROP TABLE IF EXISTS `wf_org_resource_authority`;

CREATE TABLE `wf_org_resource_authority` (
  `RESOURCE_AUTHORITY_ID` varchar(32) NOT NULL COMMENT '授权ID',
  `AUTHORITY_DESC` varchar(255) DEFAULT NULL COMMENT '授权描述信息',
  `ROLE_ID` varchar(32) NOT NULL COMMENT '角色ID',
  `ROLE_TYPE` varchar(32) NOT NULL COMMENT '角色类型：role，position，unit, user(人员权限调整)',
  `RESOURCE_ID` varchar(128) NOT NULL COMMENT '资源ID',
  `AUTHORITY_TYPE` varchar(32) NOT NULL COMMENT '授权类型：assignable，available',
  PRIMARY KEY (`RESOURCE_AUTHORITY_ID`),
  KEY `AK_AK_SYS_C006487_JT_ORG_R` (`ROLE_ID`,`ROLE_TYPE`,`RESOURCE_ID`,`AUTHORITY_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_resource_authority` */

insert  into `wf_org_resource_authority`(`RESOURCE_AUTHORITY_ID`,`AUTHORITY_DESC`,`ROLE_ID`,`ROLE_TYPE`,`RESOURCE_ID`,`AUTHORITY_TYPE`) values ('0051ecab853f432897e63aad58167ab6',NULL,'adminRole','role','1','available'),('030995d5aef9497db2f88b2bfdb5733d',NULL,'03be97502d8746c6a99c5e672ba4191d','role','12f2ec1d60d8420f992be85047d559be','available'),('048ecf07cee748c7b3e4e139dadc3704',NULL,'05aa30697de043b6b7361bb25c1fe937','role','1','available'),('04d99334603a44a6b46c3c1cc6e78b1a',NULL,'adminRole','role','f56914f1ca2d47a3a341d212b3ddf6be','available'),('06a0eacfa28046a3937f5e9963135c2f',NULL,'03be97502d8746c6a99c5e672ba4191d','role','50316aa3e45f459c881f748498adae39','assignable'),('07a096c5d9d6455d8409ea5ecc68e481',NULL,'adminRole','role','9039de2a9f0649ca842ea0db8fbde4fd','available'),('0886bf0d0c0e48548db43619f8c947c9',NULL,'adminRole','role','bc65d63baa7f42ae84ab5ca64c6ef59e','assignable'),('08c074c55978468093fa71e36b9880fe',NULL,'614756793ade4eae872263a5b8cd86dd','user','882260d847dd45eaa2e5b305c782e77a','available'),('08ed6a4afd0f406b914499c3ef2e41a4',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','6f6ff146e3d9452db3df9c8a82d3f4ff','available'),('099eecc16c154e778f7a35bc7a08c24c',NULL,'03be97502d8746c6a99c5e672ba4191d','role','2bf86444b1da45bfa6c907914787fa79','assignable'),('0ae6af1149bc43fab8e615b179172702',NULL,'6c88dd0445c64474b58ead33ec68846e','role','2e1a2b75d64345509386ce0ba7a0ba52','available'),('0cc852d62723482ea8888303299e055d',NULL,'adminRole','role','f56914f1ca2d47a3a341d212b3ddf6be','available'),('0ccddc5d3efb4d7a899278924b88faeb',NULL,'03be97502d8746c6a99c5e672ba4191d','role','2e1a2b75d64345509386ce0ba7a0ba52','available'),('0f82467464e943bc83a23e4977a22907',NULL,'adminRole','role','13df40b814524b21b8ceb2db2d6ccef3','available'),('108538a4086d43bf8b002be7c4509afb',NULL,'adminRole','role','7895a531479d4292a6f910ac23c8ece4','available'),('10d257b0f1c64b7cacc06ca59ac33350',NULL,'03be97502d8746c6a99c5e672ba4191d','role','a5e2a683102143cc8afa5e9700200200','available'),('12e72739b329459d81524c91b26cfc6b',NULL,'05aa30697de043b6b7361bb25c1fe937','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('13678d32c85749a7a2ef70d2895e578a',NULL,'03be97502d8746c6a99c5e672ba4191d','role','6b238bfeef244f07a286097f38ff20ac','assignable'),('142ac93fdac54ad2a9c4f147b9bc5851',NULL,'adminRole','role','882260d847dd45eaa2e5b305c782e77a','available'),('1563fc0ac40b49b6a400dbf4dbb91697',NULL,'adminRole','role','408eb15dc9c540a3b524c04012e36496','available'),('17c6eab846fd46d39bc3e57391658f25',NULL,'03be97502d8746c6a99c5e672ba4191d','role','2e1a2b75d64345509386ce0ba7a0ba52','assignable'),('1882daf862ba46c08eda765654fda76b',NULL,'03be97502d8746c6a99c5e672ba4191d','role','0ee43a36ef0f4c8ea776dde2ca3c234b','available'),('18a4d291320443bf802f59be4e0464a0',NULL,'adminRole','role','9af760c399f446169bc4934b9a3ad596','available'),('1c941ed31f0d444f94d6b83a8dd76a34',NULL,'adminRole','role','96d483f8153b4d08b96beed3c64ba84e','available'),('1cb3c37a673c4ab2b686faf6220f43c8',NULL,'adminRole','role','0ab5187d2d3c452cb3f5295f3f832ab8','available'),('1d65d255f13c44888a1d28a19e10268c',NULL,'03be97502d8746c6a99c5e672ba4191d','role','f90a02125b5b45e88beb8775034a1264','assignable'),('1e272fb0aeb34e60a4c7ab3d6d7ac22c',NULL,'adminRole','role','d2eec7d5211d454d8f804a9ef4b4d865','available'),('1ea1ac08d9d748ac9ca7800fa5a2752d',NULL,'adminRole','role','50316aa3e45f459c881f748498adae39','assignable'),('1f399a280be14ee99b7a101967b53b43',NULL,'05aa30697de043b6b7361bb25c1fe937','role','882260d847dd45eaa2e5b305c782e77a','available'),('200a99a2bc9b4734b2011b6c88c5415b',NULL,'03be97502d8746c6a99c5e672ba4191d','role','707862dd326342f0af5c57d4a4a94d0f','available'),('201060df0ba440229e6edec111563500',NULL,'adminRole','role','96d483f8153b4d08b96beed3c64ba84e','assignable'),('20ce13dc54ec4fab8ab5f259e65a629a',NULL,'614756793ade4eae872263a5b8cd86dd','user','9725e3dd0eeb440ab76771c21a2e271b','available'),('215727d6d993422297b3996e410aaea8',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','fb1f0faa7f1e4e289b0d7b6feca26f81','available'),('21971e7685d14b3e97d82c68de102738',NULL,'adminRole','role','3d4335ad78d24bbf90c8178bf0e57505','available'),('227ecf4d019448eb8d707c6b559c679d',NULL,'adminRole','role','1','available'),('22b53fd6b25749229098e8b4d429adb8',NULL,'05aa30697de043b6b7361bb25c1fe937','role','0ee43a36ef0f4c8ea776dde2ca3c234b','available'),('23417634642a4ac892f92d9ec90cb80a',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','707862dd326342f0af5c57d4a4a94d0f','available'),('250cd47cee434dd1a20fb93a37248166',NULL,'03be97502d8746c6a99c5e672ba4191d','role','0ab5187d2d3c452cb3f5295f3f832ab8','available'),('2679dc2054de49468e058fa4fed877c5',NULL,'05aa30697de043b6b7361bb25c1fe937','role','fb1f0faa7f1e4e289b0d7b6feca26f81','available'),('291911b576424b2d82351878cd6847ec',NULL,'03be97502d8746c6a99c5e672ba4191d','role','7895a531479d4292a6f910ac23c8ece4','assignable'),('29edb009dbc54c0bb3ba7da9080ac593',NULL,'03be97502d8746c6a99c5e672ba4191d','role','03222a9c04b94d29a3ae059ceefee9a3','assignable'),('2acf9c9f46924a12884e9827778738bc',NULL,'adminRole','role','1','available'),('2b992c2fddd14978a7de59395abd9ab2',NULL,'adminRole','role','f24d4b501ce84fb79e5634026dc0f8a3','assignable'),('2d7300a24a824897b033c14e654a3bd1',NULL,'adminRole','role','f24d4b501ce84fb79e5634026dc0f8a3','available'),('2d74c14ada8840ae90ab45df5d404fd8',NULL,'adminRole','role','6f6ff146e3d9452db3df9c8a82d3f4ff','assignable'),('2ddf4dddfede4833adafb07ee1f63d53',NULL,'05aa30697de043b6b7361bb25c1fe937','role','9c548aa7ce5144329d6e98c7dddb8eae','available'),('2f068b260b4f4c228f4522333b77e9ac',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9fe27d00c8dd4b35b1912b1dd2d426d3','assignable'),('31f50e73468f42eba5abaa2932d2207b',NULL,'adminRole','role','f90a02125b5b45e88beb8775034a1264','available'),('33f32be0e60945839be68fa90ec5a688',NULL,'03be97502d8746c6a99c5e672ba4191d','role','bc5357be429846ba8f61ccb33853926a','assignable'),('35b8614f48bd45afb2f47b5610248f50',NULL,'03be97502d8746c6a99c5e672ba4191d','role','6e3b76aabbb94fafb35854e606dd7edd','assignable'),('37bf7a2569de48bcbdbba5efee6a4ffd',NULL,'adminRole','role','39cdc2a0f634443a9023442360f833f9','available'),('3a0a7df3f3dd4c618284577563121f7f',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','bc5357be429846ba8f61ccb33853926a','available'),('3bb780039fd04999aacb50efe9d1c2cb',NULL,'adminRole','role','9fe27d00c8dd4b35b1912b1dd2d426d3','available'),('3c4f8bf4ad494edfb3a18d2746591a22',NULL,'adminRole','role','a5e2a683102143cc8afa5e9700200200','available'),('3d3f292336244437b0f90fd88c21e4f7',NULL,'adminRole','role','f24d4b501ce84fb79e5634026dc0f8a3','available'),('3f56c50bdf084228b0f63b32f03e9414',NULL,'adminRole','role','a5e2a683102143cc8afa5e9700200200','available'),('400b01c1290e43f1b31aff32ed13af29',NULL,'adminRole','role','12f2ec1d60d8420f992be85047d559be','assignable'),('45185825ca3f4d2890620474ac53ef87',NULL,'adminRole','role','882260d847dd45eaa2e5b305c782e77a','available'),('46c59082ad674b66ae8775fb66d53687',NULL,'adminRole','role','13df40b814524b21b8ceb2db2d6ccef3','available'),('477694f95261420091cb89399c12e17a',NULL,'05aa30697de043b6b7361bb25c1fe937','role','7895a531479d4292a6f910ac23c8ece4','available'),('47b56eb7907a437f82e48de6008b6b25',NULL,'adminRole','role','b07f4f873eab4b44b7dbb38a1ff9cdc5','available'),('47d9d3dad6534b45a5c3169a04eaf36e',NULL,'03be97502d8746c6a99c5e672ba4191d','role','8ed15648ada44b2c99053b0694bbf920','available'),('48d1c3afac7d4100a98651770f5402ce',NULL,'03be97502d8746c6a99c5e672ba4191d','role','50316aa3e45f459c881f748498adae39','available'),('494e16b0c0684e70827904d192149a7e',NULL,'adminRole','role','50aa7e98aee045eb9c0fa4f4630b49a9','available'),('498b8704e08746b187a6ae9b7c0dd578',NULL,'adminRole','role','0ab5187d2d3c452cb3f5295f3f832ab8','available'),('49b5c1089fb7459a9289f0b1d93eb2ec',NULL,'adminRole','role','0ab5187d2d3c452cb3f5295f3f832ab8','assignable'),('4c2526e9321f4b878379df19ddb36cfd',NULL,'adminRole','role','12f2ec1d60d8420f992be85047d559be','available'),('4fa93d4d228640cbb6f734f6bec8b102',NULL,'6c88dd0445c64474b58ead33ec68846e','role','9c548aa7ce5144329d6e98c7dddb8eae','available'),('50257bf399be49ef8d9ee6af2efcf5b3',NULL,'6c88dd0445c64474b58ead33ec68846e','role','50aa7e98aee045eb9c0fa4f4630b49a9','available'),('510ca401bac24d1da2ad42fab0c0bfed',NULL,'03be97502d8746c6a99c5e672ba4191d','role','4dd66e7c1530465c84943796e2a56a39','available'),('51461890c5e6402a829aa5fc80382ef3',NULL,'03be97502d8746c6a99c5e672ba4191d','role','3d4335ad78d24bbf90c8178bf0e57505','assignable'),('51954ca7fb21426cae7df936f87f9484',NULL,'adminRole','role','9d2aa5b97a354541b4bb8ead7a0c974b','available'),('51ebca26d1cb4f24b3bb6b7e2d19175a',NULL,'03be97502d8746c6a99c5e672ba4191d','role','1','available'),('51f79477f48649329a65bce232e04b66',NULL,'adminRole','role','408eb15dc9c540a3b524c04012e36496','available'),('53860f3d9bf84dbd8596ec84833e62c0',NULL,'adminRole','role','9725e3dd0eeb440ab76771c21a2e271b','available'),('53cfc03995084e22ade2bfda7b82054c',NULL,'03be97502d8746c6a99c5e672ba4191d','role','aac5fc7d73424c8ab3c84f393269474a','assignable'),('559bdb7aa53f49009c8927a19a257c74',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','2bf86444b1da45bfa6c907914787fa79','available'),('575481394c1c4b6fa02698dd9b6e09d3',NULL,'03be97502d8746c6a99c5e672ba4191d','role','a5e2a683102143cc8afa5e9700200200','assignable'),('58780cbe7e2b4633a1c099806160a8bc',NULL,'adminRole','role','f90a02125b5b45e88beb8775034a1264','assignable'),('59e7b643f9c446f19ac629b2277b2162',NULL,'adminRole','role','fb1f0faa7f1e4e289b0d7b6feca26f81','available'),('5ab4ac4b491c4db19f56ba18beb97d72',NULL,'03be97502d8746c6a99c5e672ba4191d','role','d2eec7d5211d454d8f804a9ef4b4d865','assignable'),('5d36d84c1e244cd881fe62c943333595',NULL,'03be97502d8746c6a99c5e672ba4191d','role','03222a9c04b94d29a3ae059ceefee9a3','available'),('5eafa5fab79d438ab6ff7a0665f7db83',NULL,'adminRole','role','f90a02125b5b45e88beb8775034a1264','available'),('5f728c82d75f446b89b7e55d818abe1e',NULL,'adminRole','role','6f6ff146e3d9452db3df9c8a82d3f4ff','available'),('5fdcd552a8384894ae69abed5e77cc9d',NULL,'03be97502d8746c6a99c5e672ba4191d','role','882260d847dd45eaa2e5b305c782e77a','available'),('5fe21989480845009667afdfdc88ee8b',NULL,'03be97502d8746c6a99c5e672ba4191d','role','@','assignable'),('61224bcbd4784ba28f75c3e6e0dba114',NULL,'adminRole','role','1','assignable'),('616fccd2650844fb8c8be358d407d62f',NULL,'adminRole','role','50316aa3e45f459c881f748498adae39','available'),('618dffd6229c4380864bfd381e9c2316',NULL,'adminRole','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('6227f7541ebc420bba65d2af1ebb1b15',NULL,'adminRole','role','d2eec7d5211d454d8f804a9ef4b4d865','assignable'),('6246bf3019cd49a3a36f5929c11346a6',NULL,'adminRole','role','9039de2a9f0649ca842ea0db8fbde4fd','assignable'),('633b9a9a564e401587b4b8997bc74957',NULL,'03be97502d8746c6a99c5e672ba4191d','role','2bf86444b1da45bfa6c907914787fa79','available'),('6351ce17ff0f4a70bfff34760840e737',NULL,'03be97502d8746c6a99c5e672ba4191d','role','1','assignable'),('64f3280fdcbb4d9cb68f7319fc3dd7d9',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9d2aa5b97a354541b4bb8ead7a0c974b','available'),('67c7aff4be114241b1823e1a40114ed3',NULL,'adminRole','role','408eb15dc9c540a3b524c04012e36496','assignable'),('694857881a9a497d9238a9597377cc02',NULL,'adminRole','role','a5e2a683102143cc8afa5e9700200200','available'),('69c05cd7f13b4581a8d22a3e96b0c748',NULL,'adminRole','role','9fe27d00c8dd4b35b1912b1dd2d426d3','available'),('69cbd3513cbe4e7aa161d5fcb6079145',NULL,'adminRole','role','f56914f1ca2d47a3a341d212b3ddf6be','assignable'),('6a34ddf0c7524a5a9b23b852fe4fa8fd',NULL,'03be97502d8746c6a99c5e672ba4191d','role','408eb15dc9c540a3b524c04012e36496','available'),('6a710ed9a2ef42c9b51a859234c689ab',NULL,'adminRole','role','f24d4b501ce84fb79e5634026dc0f8a3','available'),('6b3b8747798a489189def16c133ed087',NULL,'adminRole','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('6ce7f80eb22e4629a23379eb649d693e',NULL,'6c88dd0445c64474b58ead33ec68846e','role','1','available'),('6da1413db8c8442c99dc4498f6e99b4e',NULL,'03be97502d8746c6a99c5e672ba4191d','role','3d4335ad78d24bbf90c8178bf0e57505','available'),('6df72e019b8f43d281a474e7e5308709',NULL,'03be97502d8746c6a99c5e672ba4191d','role','8197b1234b0840afb7bc4c0ff9f7ac4a','assignable'),('6e941a7744a34aa69b9781bc9be30363',NULL,'6c88dd0445c64474b58ead33ec68846e','role','0ee43a36ef0f4c8ea776dde2ca3c234b','available'),('6f0042dc40f14d88a8751b4f5cbeda67',NULL,'03be97502d8746c6a99c5e672ba4191d','role','39cdc2a0f634443a9023442360f833f9','available'),('714ae84529c04a9f85ed7640b391bf46',NULL,'adminRole','role','9fe27d00c8dd4b35b1912b1dd2d426d3','assignable'),('7226dacb9c7b49a0b0b3f3c6eabb9cdd',NULL,'03be97502d8746c6a99c5e672ba4191d','role','7895a531479d4292a6f910ac23c8ece4','available'),('737b41de885c47f484dd0b225c33f2bd',NULL,'adminRole','role','f90a02125b5b45e88beb8775034a1264','available'),('74cb7b2e728e4b8691f12c4d93a838f2',NULL,'03be97502d8746c6a99c5e672ba4191d','role','96d483f8153b4d08b96beed3c64ba84e','assignable'),('773bca207fdf42ed9e0950e182734e8b',NULL,'03be97502d8746c6a99c5e672ba4191d','role','12f2ec1d60d8420f992be85047d559be','assignable'),('77cf99d88eba45318c42792ab2a3cbe4',NULL,'05aa30697de043b6b7361bb25c1fe937','role','12f2ec1d60d8420f992be85047d559be','available'),('782ae5d6664a4686a951e76ade292045',NULL,'adminRole','role','707862dd326342f0af5c57d4a4a94d0f','available'),('78c49d361142446f985dcf8cf811db23',NULL,'adminRole','role','6b238bfeef244f07a286097f38ff20ac','available'),('7ab92a176e884e5b928f8362785702e5',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','408eb15dc9c540a3b524c04012e36496','available'),('7bf1610f02b045f2a3a6a992e202577b',NULL,'05aa30697de043b6b7361bb25c1fe937','role','3d4335ad78d24bbf90c8178bf0e57505','available'),('7d6e94e42d324ddea11d24885c87c179',NULL,'adminRole','role','9725e3dd0eeb440ab76771c21a2e271b','available'),('7e612586950242e2ab726e5a69074782',NULL,'adminRole','role','9725e3dd0eeb440ab76771c21a2e271b','assignable'),('7f8f9124cd684943bfb9f2172c0e2aac',NULL,'adminRole','role','2bf86444b1da45bfa6c907914787fa79','available'),('7fff1d84ccb4433d9c1757352d9adb0a',NULL,'03be97502d8746c6a99c5e672ba4191d','role','d2eec7d5211d454d8f804a9ef4b4d865','available'),('80ee59f802c949f883b88f29451b9a1f',NULL,'03be97502d8746c6a99c5e672ba4191d','role','39cdc2a0f634443a9023442360f833f9','assignable'),('81a1ec553a504d3e81ff978b7703ecd4',NULL,'05aa30697de043b6b7361bb25c1fe937','role','2e1a2b75d64345509386ce0ba7a0ba52','available'),('81d140bb48bc43b18196646554f8029e',NULL,'03be97502d8746c6a99c5e672ba4191d','role','f24d4b501ce84fb79e5634026dc0f8a3','available'),('83d77b79717846339a325837c4f03aab',NULL,'adminRole','role','7895a531479d4292a6f910ac23c8ece4','available'),('84c2bde5cd3e42f99b75fba63a651228',NULL,'adminRole','role','0ee43a36ef0f4c8ea776dde2ca3c234b','available'),('86618b9f68e44ad48c85dc1151f5c010',NULL,'05aa30697de043b6b7361bb25c1fe937','role','39cdc2a0f634443a9023442360f833f9','available'),('86d62d6176dd4447ab59d69d3287e1f3',NULL,'adminRole','role','9d2aa5b97a354541b4bb8ead7a0c974b','available'),('873319ec52d44c25b2e14af8e7a4d264',NULL,'03be97502d8746c6a99c5e672ba4191d','role','6f6ff146e3d9452db3df9c8a82d3f4ff','available'),('8908441174884484ac11d5fd21186a06',NULL,'adminRole','role','8197b1234b0840afb7bc4c0ff9f7ac4a','assignable'),('8953d5363c8142b89e8b7cf2d6279b1c',NULL,'adminRole','role','2e1a2b75d64345509386ce0ba7a0ba52','available'),('8ad42003e453405eb3e810d9eab0b1e5',NULL,'adminRole','role','9d2aa5b97a354541b4bb8ead7a0c974b','available'),('8b5cc6027f474a008ac76f0838ec696b',NULL,'05aa30697de043b6b7361bb25c1fe937','role','8ed15648ada44b2c99053b0694bbf920','available'),('8badb1e3663443a09da0a126a4eed8c7',NULL,'adminRole','role','13df40b814524b21b8ceb2db2d6ccef3','assignable'),('8c55ca5c225f4500b8ead50464ea8e97',NULL,'05aa30697de043b6b7361bb25c1fe937','role','f56914f1ca2d47a3a341d212b3ddf6be','available'),('8c5d9c1823a74352a2c9663ebf7aca3d',NULL,'adminRole','role','96d483f8153b4d08b96beed3c64ba84e','available'),('8d60a14b549846e79ba920a359ce6095',NULL,'adminRole','role','4dd66e7c1530465c84943796e2a56a39','available'),('8e9f54b4ad814715b4758c8c5a3aa2f2',NULL,'05aa30697de043b6b7361bb25c1fe937','role','2bf86444b1da45bfa6c907914787fa79','available'),('8f45d0f9313643af9a1c287012d09893',NULL,'adminRole','role','1','available'),('8f9f13b2acf14e7f8177c1f0982c067f',NULL,'03be97502d8746c6a99c5e672ba4191d','role','b07f4f873eab4b44b7dbb38a1ff9cdc5','assignable'),('923184b6ff3743628d90552ddd604942',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','50316aa3e45f459c881f748498adae39','available'),('9360af8f0f8b4120beac9256a7484e78',NULL,'adminRole','role','8ed15648ada44b2c99053b0694bbf920','assignable'),('944ec9d265044d3cbdb5b327d5731c8c',NULL,'adminRole','role','6e3b76aabbb94fafb35854e606dd7edd','available'),('947a125495b8402ba2c127c47c69500a',NULL,'03be97502d8746c6a99c5e672ba4191d','role','fb1f0faa7f1e4e289b0d7b6feca26f81','available'),('94ae33a2cb154fa9ba88438725f6b1e1',NULL,'adminRole','role','6e3b76aabbb94fafb35854e606dd7edd','available'),('95c57d1915524a8fbf98cb7499610105',NULL,'6c88dd0445c64474b58ead33ec68846e','role','3d4335ad78d24bbf90c8178bf0e57505','available'),('9615fad71ba94e9caf9f1ad39d23ad51',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','9725e3dd0eeb440ab76771c21a2e271b','available'),('9733220114114642aff35b8aba805e2d',NULL,'adminRole','role','7895a531479d4292a6f910ac23c8ece4','assignable'),('975d72f0fd4b4984a15c9f5ae5b4b08c',NULL,'df5765e8339d4de2ad8d1eefebc3a1aa','user','9fe27d00c8dd4b35b1912b1dd2d426d3','available'),('9790c453b7e44c72a83e34aa195ca5a6',NULL,'adminRole','role','bc65d63baa7f42ae84ab5ca64c6ef59e','available'),('98b67b22bcf94891961e49c3c782d612',NULL,'03be97502d8746c6a99c5e672ba4191d','role','bc65d63baa7f42ae84ab5ca64c6ef59e','assignable'),('9a9726d2c99e40b597cc707f16d616e3',NULL,'adminRole','role','9fe27d00c8dd4b35b1912b1dd2d426d3','available'),('9b46d4c1a4c542b5a5ce14d396e5d235',NULL,'adminRole','role','408eb15dc9c540a3b524c04012e36496','available'),('9bdbf61600c94c5691b7b9c2f4ff16c6',NULL,'adminRole','role','03222a9c04b94d29a3ae059ceefee9a3','available'),('9d9e5954fc39468cb206ce59df6a71ce',NULL,'adminRole','role','6b238bfeef244f07a286097f38ff20ac','assignable'),('a05831c586e846439be5d8c5730ee997',NULL,'03be97502d8746c6a99c5e672ba4191d','role','0ab5187d2d3c452cb3f5295f3f832ab8','assignable'),('a380422754a34e93b61791e70a41dc1d',NULL,'adminRole','role','03222a9c04b94d29a3ae059ceefee9a3','available'),('a438ec6cfc9a42d58b144e236e7fe1ab',NULL,'adminRole','role','RootMenu','available'),('a47d8f7121974542bd4747644e86b4d8',NULL,'03be97502d8746c6a99c5e672ba4191d','role','707862dd326342f0af5c57d4a4a94d0f','assignable'),('a555c9627eef472f8065c063160739da',NULL,'adminRole','role','8ed15648ada44b2c99053b0694bbf920','available'),('a59387856781409a9069e91685013b69',NULL,'03be97502d8746c6a99c5e672ba4191d','role','6f6ff146e3d9452db3df9c8a82d3f4ff','assignable'),('a733207bac6f4e6a95cdeaa747ef4000',NULL,'adminRole','role','6b238bfeef244f07a286097f38ff20ac','available'),('a7cab5ff8583407bb7ce14073c385e2b',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','9fe27d00c8dd4b35b1912b1dd2d426d3','available'),('a80180aa791c4d2c9f98d426e2860838',NULL,'614756793ade4eae872263a5b8cd86dd','user','50316aa3e45f459c881f748498adae39','available'),('a81ee33917784652bef2fc5f7a39c363',NULL,'adminRole','role','9af760c399f446169bc4934b9a3ad596','assignable'),('a88da81c4a2a4182acd6baf22a55b7df',NULL,'adminRole','role','6e3b76aabbb94fafb35854e606dd7edd','available'),('ab848894768d411581065837cd7da460',NULL,'adminRole','role','03222a9c04b94d29a3ae059ceefee9a3','available'),('ac50c67e7e444fd8ae579f6129c5ccb3',NULL,'6c88dd0445c64474b58ead33ec68846e','role','39cdc2a0f634443a9023442360f833f9','available'),('ac70fc8c5d2143d990a084f8814803e2',NULL,'03be97502d8746c6a99c5e672ba4191d','role','882260d847dd45eaa2e5b305c782e77a','assignable'),('ad0dfc72663945a5a150fa6e83a94265',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9725e3dd0eeb440ab76771c21a2e271b','available'),('adc6c07ee4cf4728ae398f5686f6aa52',NULL,'adminRole','role','0ab5187d2d3c452cb3f5295f3f832ab8','available'),('ae0e9a48f75b47e89a1f825d9b3d3301',NULL,'03be97502d8746c6a99c5e672ba4191d','role','f56914f1ca2d47a3a341d212b3ddf6be','available'),('b045f238c1cc4d809241ec64dd1470db',NULL,'adminRole','role','9d2aa5b97a354541b4bb8ead7a0c974b','assignable'),('b04f75f76b424d60b3c95497fbf949ec',NULL,'adminRole','role','882260d847dd45eaa2e5b305c782e77a','assignable'),('b0999b4511994a67a0f8e37f502f6ae1',NULL,'adminRole','role','882260d847dd45eaa2e5b305c782e77a','available'),('b16bf509aac2453ea438398080f32a48',NULL,'df5765e8339d4de2ad8d1eefebc3a1aa','user','6f6ff146e3d9452db3df9c8a82d3f4ff','available'),('b2a07acb379045d8a03e9c9eccb19c67',NULL,'03be97502d8746c6a99c5e672ba4191d','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('b2d9e6009bbc439f92668bba2d8f9a47',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','882260d847dd45eaa2e5b305c782e77a','available'),('b308f978a0ad4074b058d6ef671b9d61',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9af760c399f446169bc4934b9a3ad596','available'),('b4fa455e47f24ff18a7ae9f0fe312f17',NULL,'05aa30697de043b6b7361bb25c1fe937','role','50aa7e98aee045eb9c0fa4f4630b49a9','assignable'),('b5fcc2bc48ed47bdb1f62d6c796b1a5c',NULL,'adminRole','role','39cdc2a0f634443a9023442360f833f9','assignable'),('b6e1db94983646d0bf86338646c31a4f',NULL,'adminRole','role','03222a9c04b94d29a3ae059ceefee9a3','assignable'),('b7eb3aa828494bc9864b54ae5ba429b1',NULL,'05aa30697de043b6b7361bb25c1fe937','role','9af760c399f446169bc4934b9a3ad596','available'),('b8740f9457c04cd18de490b6d5765cbd',NULL,'03be97502d8746c6a99c5e672ba4191d','role','f90a02125b5b45e88beb8775034a1264','available'),('b8786181b7a142b7a9fd4aec95154228',NULL,'adminRole','role','9af760c399f446169bc4934b9a3ad596','available'),('b90c4579bd594006b1d24afe61b269f7',NULL,'adminRole','role','12f2ec1d60d8420f992be85047d559be','available'),('bcc1b443a55343989527e1e378516782',NULL,'03be97502d8746c6a99c5e672ba4191d','role','13df40b814524b21b8ceb2db2d6ccef3','assignable'),('bd4fd70cd57d405ba74b14f7190c8243',NULL,'adminRole','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('bd67a736d4e64d219586e71d55fa95f3',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9725e3dd0eeb440ab76771c21a2e271b','assignable'),('bd9ff7058ddd43738badf0b01919996b',NULL,'03be97502d8746c6a99c5e672ba4191d','role','bc65d63baa7f42ae84ab5ca64c6ef59e','available'),('be2c7357983f48e386a1ba44ba20bd7e',NULL,'adminRole','role','d2eec7d5211d454d8f804a9ef4b4d865','available'),('be619046ed5743ddbc34bb3ecb98cc12',NULL,'adminRole','role','50316aa3e45f459c881f748498adae39','available'),('beaf58dd44c14508b5ae8b0f81914580',NULL,'03be97502d8746c6a99c5e672ba4191d','role','50aa7e98aee045eb9c0fa4f4630b49a9','available'),('c1c4e09f27d44d67a9d67f9e1056060a',NULL,'6c88dd0445c64474b58ead33ec68846e','role','4dd66e7c1530465c84943796e2a56a39','available'),('c3862eeda25f4b89b1544e53d08faa7f',NULL,'03be97502d8746c6a99c5e672ba4191d','role','6b238bfeef244f07a286097f38ff20ac','available'),('c6851632ca614882b2c4b37564bd5c7c',NULL,'adminRole','role','1','available'),('c6f78729baa1475e8b85f40dedcfa974',NULL,'adminRole','role','f56914f1ca2d47a3a341d212b3ddf6be','available'),('c816aaf097ee416c8c39cc787644645e',NULL,'adminRole','role','6f6ff146e3d9452db3df9c8a82d3f4ff','available'),('c8f33ad80c5046adbccb0186becbd8c0',NULL,'05aa30697de043b6b7361bb25c1fe937','role','bc5357be429846ba8f61ccb33853926a','available'),('cb669bdb25f44631bf65d482c5beefe2',NULL,'03be97502d8746c6a99c5e672ba4191d','role','6e3b76aabbb94fafb35854e606dd7edd','available'),('cc5093c68c2f4472b3501b0891976faa',NULL,'03be97502d8746c6a99c5e672ba4191d','role','50aa7e98aee045eb9c0fa4f4630b49a9','assignable'),('cfa5ddd2f4e8454a87b6d5893739950e',NULL,'adminRole','role','6f6ff146e3d9452db3df9c8a82d3f4ff','available'),('cfaaa16ba1694240afde6c901d91b1f3',NULL,'03be97502d8746c6a99c5e672ba4191d','role','96d483f8153b4d08b96beed3c64ba84e','available'),('d1e6f6ab7984477d8bcbefb980b551ef',NULL,'03be97502d8746c6a99c5e672ba4191d','role','b07f4f873eab4b44b7dbb38a1ff9cdc5','available'),('d20eac5f7275474aae24a5706e75a99d',NULL,'adminRole','role','12f2ec1d60d8420f992be85047d559be','available'),('d374e905c4e34036a8e1f2c5143c4ba3',NULL,'03be97502d8746c6a99c5e672ba4191d','role','13df40b814524b21b8ceb2db2d6ccef3','available'),('d41c4dc7e6884a9a84c780618189dfeb',NULL,'adminRole','role','b07f4f873eab4b44b7dbb38a1ff9cdc5','available'),('d4c8d98bac91469d82fca75c53171c4e',NULL,'adminRole','role','a5e2a683102143cc8afa5e9700200200','assignable'),('d61bba0d52db421b8c1d374f7463d52b',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9039de2a9f0649ca842ea0db8fbde4fd','assignable'),('d629c12d4e004d83aa56d9df7b62fa70',NULL,'05aa30697de043b6b7361bb25c1fe937','role','50aa7e98aee045eb9c0fa4f4630b49a9','available'),('d6e82163cadf400c988219e74d351a22',NULL,'adminRole','role','9725e3dd0eeb440ab76771c21a2e271b','available'),('d7178a02ad2740c58de8aeebddcba11a',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9fe27d00c8dd4b35b1912b1dd2d426d3','available'),('d75893f8cac6411bb610daf2949cf37e',NULL,'adminRole','role','6b238bfeef244f07a286097f38ff20ac','available'),('d769f865c9454e2e82d5137065bf3b38',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9039de2a9f0649ca842ea0db8fbde4fd','available'),('d8705358ce0b488b9d622703b65317a7',NULL,'6c88dd0445c64474b58ead33ec68846e','role','a5e2a683102143cc8afa5e9700200200','available'),('dbf81dd6597a40fa9a6ca9738ba64b8a',NULL,'adminRole','role','9039de2a9f0649ca842ea0db8fbde4fd','available'),('dc6a058623214870a81474bb4ff86b10',NULL,'6c88dd0445c64474b58ead33ec68846e','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('dd14d291e17346689ef3823a7cdc765c',NULL,'adminRole','role','7895a531479d4292a6f910ac23c8ece4','available'),('dd6a595ac133421aafc21db9d8ea518a',NULL,'05aa30697de043b6b7361bb25c1fe937','role','707862dd326342f0af5c57d4a4a94d0f','available'),('de7d962d40384f04be9d70b9b9500a92',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9c548aa7ce5144329d6e98c7dddb8eae','assignable'),('df7379c8b2fb4b218269a8c402baf0cd',NULL,'adminRole','role','bc5357be429846ba8f61ccb33853926a','available'),('df8ff1f7922a494d9c69f048dbe19e2d',NULL,'adminRole','role','96d483f8153b4d08b96beed3c64ba84e','available'),('e00e6ec456b04614a409844e527a6674',NULL,'1906ff5a2f8240cfac6b2fe618d15d33','user','0ab5187d2d3c452cb3f5295f3f832ab8','available'),('e2a47613f8cd4849b3d5bfaa74832288',NULL,'03be97502d8746c6a99c5e672ba4191d','role','bc5357be429846ba8f61ccb33853926a','available'),('e2eb0c944076486dbb80f5012420291c',NULL,'adminRole','role','b07f4f873eab4b44b7dbb38a1ff9cdc5','available'),('e4d14cbb29e34ad9b9b063f8ee4b2df3',NULL,'adminRole','role','50316aa3e45f459c881f748498adae39','available'),('e5e4a2352a5b4831955037e62f9d6152',NULL,'05aa30697de043b6b7361bb25c1fe937','role','a5e2a683102143cc8afa5e9700200200','available'),('e793506a4d9d4bc680b87c4597043033',NULL,'adminRole','role','13df40b814524b21b8ceb2db2d6ccef3','available'),('e901d864c59841c6a8f316aade1b467d',NULL,'adminRole','role','6e3b76aabbb94fafb35854e606dd7edd','assignable'),('e9b6076df8d34b26a0d4469a4a4162c0',NULL,'03be97502d8746c6a99c5e672ba4191d','role','0ee43a36ef0f4c8ea776dde2ca3c234b','assignable'),('e9f6ac9a85a847778f415f0c51a2eb71',NULL,'adminRole','role','8ed15648ada44b2c99053b0694bbf920','available'),('ea75601da78b42c0ab3cc566fecb6d11',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9d2aa5b97a354541b4bb8ead7a0c974b','assignable'),('edf282f6d32f4de8abfa73dafd14be1a',NULL,'03be97502d8746c6a99c5e672ba4191d','role','408eb15dc9c540a3b524c04012e36496','assignable'),('f0533147f9e9460682b6367c8409974d',NULL,'adminRole','role','9c548aa7ce5144329d6e98c7dddb8eae','available'),('f0fc551d0bd14136aada5aec6fd8caa6',NULL,'adminRole','role','39cdc2a0f634443a9023442360f833f9','available'),('f2c7008d0f8a4ffdacce97233b182402',NULL,'03be97502d8746c6a99c5e672ba4191d','role','4dd66e7c1530465c84943796e2a56a39','assignable'),('f47e7886cd944caf9258e55ade93360c',NULL,'03be97502d8746c6a99c5e672ba4191d','role','fb1f0faa7f1e4e289b0d7b6feca26f81','assignable'),('f549766ecf2341e1aa3a5b747a00e050',NULL,'adminRole','role','bc65d63baa7f42ae84ab5ca64c6ef59e','available'),('f5d531a2c68c4f48bced5e07491073e3',NULL,'adminRole','role','d2eec7d5211d454d8f804a9ef4b4d865','available'),('f61601a5497749fd998957a6f5aeeae7',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9c548aa7ce5144329d6e98c7dddb8eae','available'),('f673ebe537c14268815f608161648a39',NULL,'adminRole','role','bc65d63baa7f42ae84ab5ca64c6ef59e','available'),('f725bcb00a744fd28008943df220161b',NULL,'03be97502d8746c6a99c5e672ba4191d','role','f24d4b501ce84fb79e5634026dc0f8a3','assignable'),('f73e793763a9453282780ab604b637d4',NULL,'adminRole','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('fa017d1db88b458d8e049881195429e5',NULL,'03be97502d8746c6a99c5e672ba4191d','role','9af760c399f446169bc4934b9a3ad596','assignable'),('fab9c5b04b574794a3d7dd33626e3545',NULL,'adminRole','role','9039de2a9f0649ca842ea0db8fbde4fd','available'),('fafaa8bca5214112813c75a606fca20d',NULL,'05aa30697de043b6b7361bb25c1fe937','role','4dd66e7c1530465c84943796e2a56a39','available'),('fc115372cdbd4fadaffe2cb63f77126c',NULL,'adminRole','role','8197b1234b0840afb7bc4c0ff9f7ac4a','available'),('fc8437ec7d594eae96196d7db1b829ab',NULL,'03be97502d8746c6a99c5e672ba4191d','role','f56914f1ca2d47a3a341d212b3ddf6be','assignable'),('fdc9710a89a24089ba0a3c629bdbef4e',NULL,'03be97502d8746c6a99c5e672ba4191d','role','8ed15648ada44b2c99053b0694bbf920','assignable'),('fe676283400f4b80801a99c2cad20b0c',NULL,'adminRole','role','8ed15648ada44b2c99053b0694bbf920','available'),('fee7036ce0f6465b9b504c9de0ef95ff',NULL,'6c88dd0445c64474b58ead33ec68846e','role','9af760c399f446169bc4934b9a3ad596','available'),('fee9ea47f07d439985374092e1f2b9b2',NULL,'adminRole','role','b07f4f873eab4b44b7dbb38a1ff9cdc5','assignable');

/*Table structure for table `wf_org_role` */

DROP TABLE IF EXISTS `wf_org_role`;

CREATE TABLE `wf_org_role` (
  `ROLE_ID` varchar(32) NOT NULL COMMENT '角色ID',
  `PARENT_ROLE_ID` varchar(32) DEFAULT NULL COMMENT '角色ID',
  `ROLE_NAME` varchar(32) NOT NULL COMMENT '角色名称',
  `ROLE_DESCRIPTION` varchar(255) DEFAULT NULL COMMENT '角色描述信息',
  `IS_ADMINROLE` varchar(6) NOT NULL COMMENT '是否是管理角色：是，否',
  `ROLE_TIME_BEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '角色生效时间',
  `ROLE_TIME_END` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '角色失效时间',
  `USER_NUMBERS` decimal(10,0) DEFAULT NULL COMMENT '角色基数约束',
  `IS_UNIQUE` decimal(1,0) DEFAULT NULL COMMENT '角色唯一约束，角色是否只能分配给一个人',
  PRIMARY KEY (`ROLE_ID`),
  KEY `AK_AK_SYS_C006424_JT_ORG_R` (`ROLE_NAME`),
  KEY `FK_FK_JT_ORG_R_PARENT_RO_JT_ORG_R` (`PARENT_ROLE_ID`),
  CONSTRAINT `FK_FK_JT_ORG_R_PARENT_RO_JT_ORG_R` FOREIGN KEY (`PARENT_ROLE_ID`) REFERENCES `wf_org_role` (`ROLE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_role` */

insert  into `wf_org_role`(`ROLE_ID`,`PARENT_ROLE_ID`,`ROLE_NAME`,`ROLE_DESCRIPTION`,`IS_ADMINROLE`,`ROLE_TIME_BEGIN`,`ROLE_TIME_END`,`USER_NUMBERS`,`IS_UNIQUE`) values ('03be97502d8746c6a99c5e672ba4191d','adminRole','总经理','','是','2015-08-15 14:00:50','2015-08-15 14:00:50',-1,0),('05aa30697de043b6b7361bb25c1fe937','adminRole','部门经理','','是','2015-08-15 14:22:29','2015-08-15 14:22:29',-1,0),('6c88dd0445c64474b58ead33ec68846e','adminRole','工人','','否','2015-08-15 14:23:02','2015-08-15 14:23:02',-1,0),('adminRole',NULL,'adminRole','管理角色','是','2013-10-23 16:22:42','2013-10-23 16:22:42',-1,0);

/*Table structure for table `wf_org_role_unit` */

DROP TABLE IF EXISTS `wf_org_role_unit`;

CREATE TABLE `wf_org_role_unit` (
  `UNIT_ID` varchar(32) NOT NULL COMMENT '组织单元ID',
  `ROLE_ID` varchar(32) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`UNIT_ID`,`ROLE_ID`),
  KEY `FK_FK_JT_ORG_R_FK_BUSIRO_JT_ORG_R` (`ROLE_ID`),
  CONSTRAINT `FK_FK_JT_ORG_R_FK_BUSIRO_JT_ORG_R` FOREIGN KEY (`ROLE_ID`) REFERENCES `wf_org_role` (`ROLE_ID`),
  CONSTRAINT `FK_FK_JT_ORG_R_FK_UNIT_B_JT_ORG_U` FOREIGN KEY (`UNIT_ID`) REFERENCES `wf_org_unit` (`UNIT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_role_unit` */

insert  into `wf_org_role_unit`(`UNIT_ID`,`ROLE_ID`) values ('00ecd710ce874576a9342996142cee7e','05aa30697de043b6b7361bb25c1fe937'),('5ea66f74c3244cf7ac1d371581c28426','05aa30697de043b6b7361bb25c1fe937'),('607c2c26339c4247948b9dab3c869c06','05aa30697de043b6b7361bb25c1fe937');

/*Table structure for table `wf_org_station` */

DROP TABLE IF EXISTS `wf_org_station`;

CREATE TABLE `wf_org_station` (
  `STATION_ID` varchar(32) NOT NULL COMMENT '岗位ID',
  `UNIT_ID` varchar(32) DEFAULT NULL COMMENT '组织单元ID',
  `PARENT_STATION_ID` varchar(32) DEFAULT NULL COMMENT '岗位ID',
  `STATION_NAME` varchar(32) NOT NULL COMMENT '岗位名称',
  `STATION_DESCRIPTION` varchar(255) DEFAULT NULL COMMENT '岗位描述信息',
  `STATION_TIME_BEGIN` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '岗位生效时间',
  `STATION_TIME_END` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '岗位失效时间',
  `USER_NUMBERS` decimal(10,0) DEFAULT NULL COMMENT '岗位基数约束',
  PRIMARY KEY (`STATION_ID`),
  KEY `FK_FK_JT_ORG_S_PARENT_ST_JT_ORG_S` (`PARENT_STATION_ID`),
  KEY `FK_FK_JT_ORG_S_UNIT_ID_JT_ORG_U` (`UNIT_ID`),
  CONSTRAINT `FK_FK_JT_ORG_S_PARENT_ST_JT_ORG_S` FOREIGN KEY (`PARENT_STATION_ID`) REFERENCES `wf_org_station` (`STATION_ID`),
  CONSTRAINT `FK_FK_JT_ORG_S_UNIT_ID_JT_ORG_U` FOREIGN KEY (`UNIT_ID`) REFERENCES `wf_org_unit` (`UNIT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_station` */

insert  into `wf_org_station`(`STATION_ID`,`UNIT_ID`,`PARENT_STATION_ID`,`STATION_NAME`,`STATION_DESCRIPTION`,`STATION_TIME_BEGIN`,`STATION_TIME_END`,`USER_NUMBERS`) values ('508d0a302c4e450ba03f7859e3c9992b','bae29fe892524ed68a623bd8c7c29b19',NULL,'code','','2017-04-20 09:07:24','2017-04-20 09:07:24',1);

/*Table structure for table `wf_org_unit` */

DROP TABLE IF EXISTS `wf_org_unit`;

CREATE TABLE `wf_org_unit` (
  `UNIT_ID` varchar(32) NOT NULL COMMENT '组织单元ID',
  `PARENT_UNIT_ID` varchar(32) DEFAULT NULL COMMENT '组织单元ID',
  `STATION_ID` varchar(32) DEFAULT NULL COMMENT '岗位ID',
  `UNIT_NAME` varchar(32) NOT NULL COMMENT '组织单元名称',
  `UNIT_DESCRIPTION` varchar(255) DEFAULT NULL COMMENT '组织单元描述信息',
  `UNIT_TYPE` varchar(30) DEFAULT NULL COMMENT '组织单元类型',
  PRIMARY KEY (`UNIT_ID`),
  KEY `FK_FK_JT_ORG_U_PARENT_UN_JT_ORG_U` (`PARENT_UNIT_ID`),
  KEY `FK_FK_JT_ORG_U_UNIT_LEAD_JT_ORG_S` (`STATION_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_PARENT_UN_JT_ORG_U` FOREIGN KEY (`PARENT_UNIT_ID`) REFERENCES `wf_org_unit` (`UNIT_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_UNIT_LEAD_JT_ORG_S` FOREIGN KEY (`STATION_ID`) REFERENCES `wf_org_station` (`STATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_unit` */

insert  into `wf_org_unit`(`UNIT_ID`,`PARENT_UNIT_ID`,`STATION_ID`,`UNIT_NAME`,`UNIT_DESCRIPTION`,`UNIT_TYPE`) values ('00ecd710ce874576a9342996142cee7e','RootUnit',NULL,'财务部','',''),('1f5a652891d940c1bb9bc4b92050d1bf','RootUnit',NULL,'公关部','','CODE1'),('5ea66f74c3244cf7ac1d371581c28426','RootUnit',NULL,'生产部','',''),('603fab5696264a1eb0bc827e72137dc2','RootUnit',NULL,'保安部','什么','CODE1'),('607c2c26339c4247948b9dab3c869c06','RootUnit',NULL,'采购部','',''),('6b46afd5a0c04cafb97a866dbbf3e6dc','86f90a631ffb4e3f81b450521ab3ad74',NULL,'101连','无','CODE1'),('86f90a631ffb4e3f81b450521ab3ad74','RootUnit',NULL,'公安部','公安','CODE1'),('b286cbe6ed824907923206d3a495c87a','5ea66f74c3244cf7ac1d371581c28426',NULL,'32432','324','CODE1'),('bae29fe892524ed68a623bd8c7c29b19','RootUnit',NULL,'测试部','',''),('dc9e6e286236427da5de7f6136141213','86f90a631ffb4e3f81b450521ab3ad74',NULL,'102排','无','CODE1'),('f91457c2428b42c8b59cc0dbdc53f499','RootUnit',NULL,'也一样','',''),('RootUnit',NULL,NULL,'根组织单元',NULL,'部门');

/*Table structure for table `wf_org_unit_ext` */

DROP TABLE IF EXISTS `wf_org_unit_ext`;

CREATE TABLE `wf_org_unit_ext` (
  `UNIT_ID` varchar(32) NOT NULL COMMENT '组织单元ID',
  `UNIT_EMAIL` varchar(32) DEFAULT NULL,
  `UNIT_DATE` varchar(32) DEFAULT NULL,
  `UNIT_NUM` varchar(32) DEFAULT NULL,
  `UNIT_FLOAT` varchar(32) DEFAULT NULL,
  `UNIT_COMBOBOX` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`UNIT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_unit_ext` */

insert  into `wf_org_unit_ext`(`UNIT_ID`,`UNIT_EMAIL`,`UNIT_DATE`,`UNIT_NUM`,`UNIT_FLOAT`,`UNIT_COMBOBOX`) values ('00ecd710ce874576a9342996142cee7e','','','','',''),('1f5a652891d940c1bb9bc4b92050d1bf','','','','',''),('5ea66f74c3244cf7ac1d371581c28426','','','','',''),('603fab5696264a1eb0bc827e72137dc2','','','','',''),('607c2c26339c4247948b9dab3c869c06','','','','',''),('6b46afd5a0c04cafb97a866dbbf3e6dc','','','','',''),('86f90a631ffb4e3f81b450521ab3ad74','','','','',''),('b286cbe6ed824907923206d3a495c87a','','','','',''),('bae29fe892524ed68a623bd8c7c29b19','','','','',''),('dc9e6e286236427da5de7f6136141213','','','','',''),('f91457c2428b42c8b59cc0dbdc53f499','','','','','');

/*Table structure for table `wf_org_user` */

DROP TABLE IF EXISTS `wf_org_user`;

CREATE TABLE `wf_org_user` (
  `USER_ID` varchar(32) NOT NULL COMMENT '用户ID',
  `USER_ACCOUNT` varchar(32) NOT NULL COMMENT '用户帐号',
  `USER_FULLNAME` varchar(32) NOT NULL COMMENT '用户全名',
  `USER_PASSWORD` varchar(32) NOT NULL COMMENT '用户密码',
  `USER_DESCRIPTION` varchar(255) DEFAULT NULL COMMENT '用户描述信息',
  `USER_PASSWORD_CHANGED` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '密码最后一次修改时间',
  `USER_ACCOUNT_ENABLED` char(1) NOT NULL COMMENT '帐号是否启用',
  `USER_ACCOUNT_LOCKED` char(1) NOT NULL COMMENT '帐号是否锁定',
  `USER_ACCOUNT_CREATED` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '帐号创建时间',
  PRIMARY KEY (`USER_ID`),
  KEY `AK_AK_SYS_C006449_JT_ORG_U` (`USER_ACCOUNT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_user` */

insert  into `wf_org_user`(`USER_ID`,`USER_ACCOUNT`,`USER_FULLNAME`,`USER_PASSWORD`,`USER_DESCRIPTION`,`USER_PASSWORD_CHANGED`,`USER_ACCOUNT_ENABLED`,`USER_ACCOUNT_LOCKED`,`USER_ACCOUNT_CREATED`) values ('07b73cc563634ac29251cc9df679a855','mafuren','马夫人','aY1RoZ2KEhzlgUmde3AWaA==','','2017-04-12 11:12:21','1','0','2015-08-15 14:19:25'),('1906ff5a2f8240cfac6b2fe618d15d33','ganbaobao','甘宝宝','aY1RoZ2KEhzlgUmde3AWaA==','','2017-04-12 09:26:38','1','1','2015-08-15 14:20:56'),('1f2763cf8a214a02ba82b24056fa27da','saodiseng','扫地僧','aY1RoZ2KEhzlgUmde3AWaA==','','2015-08-15 14:17:46','1','0','2015-08-15 14:11:28'),('55eb3bededf34345ba760d8b0137219e','fengboe','风波恶','aY1RoZ2KEhzlgUmde3AWaA==','','2017-04-12 09:28:32','1','1','2015-08-15 14:20:36'),('614756793ade4eae872263a5b8cd86dd','xiaocui','小翠','aY1RoZ2KEhzlgUmde3AWaA==','','2015-08-15 14:20:01','1','0','2015-08-15 14:20:01'),('65db5a844f404082adfe7cf3b0582be7','44444','admin4','MQfZ5IuWxqXdXS5Wq5LZVA==','','2017-04-12 14:35:38','1','0','2017-04-12 14:35:39'),('a4186f77109d4ad98cb5be993246d476','luansh','lsh','s2O5RPxv+ghkISVyMyDJFQ==','','2017-04-12 11:33:40','1','0','2017-04-12 11:33:40'),('adminUser','admin','admin','xMpCOKC5I4INzFCab3WEmw==','','2017-04-12 11:13:12','1','0','2013-10-23 16:22:42'),('b3e451bbcdbc4d2b8236c1423558ad72','daobaifeng','刀白凤','aY1RoZ2KEhzlgUmde3AWaA==','','2015-08-15 14:18:24','1','0','2015-08-15 14:13:16'),('df5765e8339d4de2ad8d1eefebc3a1aa','masw','马士伟','xMpCOKC5I4INzFCab3WEmw==','','2017-04-11 09:48:08','1','0','2017-04-11 09:48:08'),('e6dbc4f4b2b04feab645cc33eac7b6bf','dingchunqiu','丁春秋','aY1RoZ2KEhzlgUmde3AWaA==','','2015-08-15 14:18:50','1','0','2015-08-15 14:12:47');

/*Table structure for table `wf_org_user_exclude` */

DROP TABLE IF EXISTS `wf_org_user_exclude`;

CREATE TABLE `wf_org_user_exclude` (
  `USER_ID` varchar(32) NOT NULL,
  `RESOURCE_ID` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_user_exclude` */

insert  into `wf_org_user_exclude`(`USER_ID`,`RESOURCE_ID`) values ('55eb3bededf34345ba760d8b0137219e','9c548aa7ce5144329d6e98c7dddb8eae');

/*Table structure for table `wf_org_user_ext` */

DROP TABLE IF EXISTS `wf_org_user_ext`;

CREATE TABLE `wf_org_user_ext` (
  `USER_ID` varchar(32) NOT NULL,
  `USER_EMAIL` varchar(32) DEFAULT NULL,
  `USER_DATE` varchar(32) DEFAULT NULL,
  `USER_NUM` varchar(32) DEFAULT NULL,
  `USER_FLOAT` varchar(32) DEFAULT NULL,
  `USER_COMBOBOX` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_user_ext` */

insert  into `wf_org_user_ext`(`USER_ID`,`USER_EMAIL`,`USER_DATE`,`USER_NUM`,`USER_FLOAT`,`USER_COMBOBOX`) values ('07b73cc563634ac29251cc9df679a855','','','','',''),('1906ff5a2f8240cfac6b2fe618d15d33','','','','',''),('1f2763cf8a214a02ba82b24056fa27da','','','','',''),('55eb3bededf34345ba760d8b0137219e','','','','',''),('614756793ade4eae872263a5b8cd86dd','','','','',''),('65db5a844f404082adfe7cf3b0582be7','','','','',''),('a4186f77109d4ad98cb5be993246d476','','','','',''),('adminUser','','','','',''),('b3e451bbcdbc4d2b8236c1423558ad72','','','','',''),('df5765e8339d4de2ad8d1eefebc3a1aa','','','','',''),('e6dbc4f4b2b04feab645cc33eac7b6bf','','','','','');

/*Table structure for table `wf_org_user_role` */

DROP TABLE IF EXISTS `wf_org_user_role`;

CREATE TABLE `wf_org_user_role` (
  `USER_ID` varchar(32) NOT NULL COMMENT '用户ID',
  `ROLE_ID` varchar(32) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`USER_ID`,`ROLE_ID`),
  KEY `FK_FK_JT_ORG_U_FK_BUSIRO_JT_ORG_R` (`ROLE_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_FK_BUSIRO_JT_ORG_R` FOREIGN KEY (`ROLE_ID`) REFERENCES `wf_org_role` (`ROLE_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_FK_USER_B_JT_ORG_U` FOREIGN KEY (`USER_ID`) REFERENCES `wf_org_user` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_user_role` */

insert  into `wf_org_user_role`(`USER_ID`,`ROLE_ID`) values ('1f2763cf8a214a02ba82b24056fa27da','03be97502d8746c6a99c5e672ba4191d'),('a4186f77109d4ad98cb5be993246d476','03be97502d8746c6a99c5e672ba4191d'),('07b73cc563634ac29251cc9df679a855','05aa30697de043b6b7361bb25c1fe937'),('55eb3bededf34345ba760d8b0137219e','05aa30697de043b6b7361bb25c1fe937'),('e6dbc4f4b2b04feab645cc33eac7b6bf','05aa30697de043b6b7361bb25c1fe937'),('1906ff5a2f8240cfac6b2fe618d15d33','6c88dd0445c64474b58ead33ec68846e'),('614756793ade4eae872263a5b8cd86dd','6c88dd0445c64474b58ead33ec68846e'),('a4186f77109d4ad98cb5be993246d476','6c88dd0445c64474b58ead33ec68846e'),('b3e451bbcdbc4d2b8236c1423558ad72','6c88dd0445c64474b58ead33ec68846e'),('adminUser','adminRole');

/*Table structure for table `wf_org_user_station` */

DROP TABLE IF EXISTS `wf_org_user_station`;

CREATE TABLE `wf_org_user_station` (
  `USER_ID` varchar(32) NOT NULL COMMENT '用户ID',
  `STATION_ID` varchar(32) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`USER_ID`,`STATION_ID`),
  KEY `FK_FK_JT_ORG_U_FK_STATIO_JT_ORG_S` (`STATION_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_FK_STATIO_JT_ORG_S` FOREIGN KEY (`STATION_ID`) REFERENCES `wf_org_station` (`STATION_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_FK_USER_S_JT_ORG_U` FOREIGN KEY (`USER_ID`) REFERENCES `wf_org_user` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_user_station` */

/*Table structure for table `wf_org_user_unit` */

DROP TABLE IF EXISTS `wf_org_user_unit`;

CREATE TABLE `wf_org_user_unit` (
  `UNIT_ID` varchar(32) NOT NULL COMMENT '组织单元ID',
  `USER_ID` varchar(32) NOT NULL COMMENT '用户ID',
  PRIMARY KEY (`UNIT_ID`,`USER_ID`),
  KEY `FK_FK_JT_ORG_U_FK_USER_U_JT_ORG_U` (`USER_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_FK_UNIT_U_JT_ORG_U` FOREIGN KEY (`UNIT_ID`) REFERENCES `wf_org_unit` (`UNIT_ID`),
  CONSTRAINT `FK_FK_JT_ORG_U_FK_USER_U_JT_ORG_U` FOREIGN KEY (`USER_ID`) REFERENCES `wf_org_user` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_org_user_unit` */

insert  into `wf_org_user_unit`(`UNIT_ID`,`USER_ID`) values ('1f5a652891d940c1bb9bc4b92050d1bf','07b73cc563634ac29251cc9df679a855'),('5ea66f74c3244cf7ac1d371581c28426','07b73cc563634ac29251cc9df679a855'),('b286cbe6ed824907923206d3a495c87a','07b73cc563634ac29251cc9df679a855'),('607c2c26339c4247948b9dab3c869c06','1906ff5a2f8240cfac6b2fe618d15d33'),('6b46afd5a0c04cafb97a866dbbf3e6dc','1906ff5a2f8240cfac6b2fe618d15d33'),('603fab5696264a1eb0bc827e72137dc2','1f2763cf8a214a02ba82b24056fa27da'),('86f90a631ffb4e3f81b450521ab3ad74','1f2763cf8a214a02ba82b24056fa27da'),('dc9e6e286236427da5de7f6136141213','1f2763cf8a214a02ba82b24056fa27da'),('RootUnit','1f2763cf8a214a02ba82b24056fa27da'),('607c2c26339c4247948b9dab3c869c06','55eb3bededf34345ba760d8b0137219e'),('6b46afd5a0c04cafb97a866dbbf3e6dc','55eb3bededf34345ba760d8b0137219e'),('1f5a652891d940c1bb9bc4b92050d1bf','614756793ade4eae872263a5b8cd86dd'),('5ea66f74c3244cf7ac1d371581c28426','614756793ade4eae872263a5b8cd86dd'),('b286cbe6ed824907923206d3a495c87a','614756793ade4eae872263a5b8cd86dd'),('00ecd710ce874576a9342996142cee7e','a4186f77109d4ad98cb5be993246d476'),('5ea66f74c3244cf7ac1d371581c28426','a4186f77109d4ad98cb5be993246d476'),('607c2c26339c4247948b9dab3c869c06','a4186f77109d4ad98cb5be993246d476'),('bae29fe892524ed68a623bd8c7c29b19','a4186f77109d4ad98cb5be993246d476'),('00ecd710ce874576a9342996142cee7e','adminUser'),('bae29fe892524ed68a623bd8c7c29b19','adminUser'),('00ecd710ce874576a9342996142cee7e','b3e451bbcdbc4d2b8236c1423558ad72'),('bae29fe892524ed68a623bd8c7c29b19','b3e451bbcdbc4d2b8236c1423558ad72'),('00ecd710ce874576a9342996142cee7e','df5765e8339d4de2ad8d1eefebc3a1aa'),('bae29fe892524ed68a623bd8c7c29b19','df5765e8339d4de2ad8d1eefebc3a1aa'),('00ecd710ce874576a9342996142cee7e','e6dbc4f4b2b04feab645cc33eac7b6bf'),('bae29fe892524ed68a623bd8c7c29b19','e6dbc4f4b2b04feab645cc33eac7b6bf');

/*Table structure for table `wf_overtime_deal` */

DROP TABLE IF EXISTS `wf_overtime_deal`;

CREATE TABLE `wf_overtime_deal` (
  `INSTANCE_ID` varchar(64) NOT NULL COMMENT '实例标识',
  `TIMER_TYPE` int(11) NOT NULL COMMENT '是超时，还是预警',
  `OCCUR_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '状态变化',
  `PROLONG_TIME` int(11) DEFAULT NULL COMMENT '时间间隔',
  `REMIND_COUNT` int(11) DEFAULT NULL COMMENT '提醒次数',
  `CURRENT_STATE` int(11) DEFAULT NULL COMMENT '当前状态',
  `OBJECTTYPE` int(11) DEFAULT NULL COMMENT '对象类型',
  `CREATE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '新建时间',
  `TIME_OUT_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '过期时间',
  `SCHEDULE_TYPE` varchar(64) DEFAULT NULL COMMENT '计划类型',
  `WARNING_COUNT` int(11) DEFAULT NULL COMMENT '预警次数',
  `WARNING_INTERVAL` int(11) DEFAULT NULL COMMENT '预警间隔',
  `EXCEPTION` varchar(4000) DEFAULT NULL COMMENT '异常信息',
  PRIMARY KEY (`INSTANCE_ID`,`TIMER_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='超时处理';

/*Data for the table `wf_overtime_deal` */

/*Table structure for table `wf_proc_creator_monitor` */

DROP TABLE IF EXISTS `wf_proc_creator_monitor`;

CREATE TABLE `wf_proc_creator_monitor` (
  `PCM_ID` varchar(64) NOT NULL COMMENT '流程创建监控者ID',
  `PROC_VERSION` varchar(64) NOT NULL COMMENT '流程版本',
  `PROC_ID` varchar(64) NOT NULL COMMENT '流程ID',
  `PCM_TYPE` int(11) NOT NULL COMMENT '流程创建监控者类型，0：创建者，1：监控者',
  `PARTICIPANT_TYPE` int(11) NOT NULL COMMENT '参与者类型\n            0人员，1角色，2组织单元，3岗位',
  `PARTICIPANT_ID` varchar(64) NOT NULL COMMENT '参与者ID',
  `PARTICIPANT_NAME` varchar(64) DEFAULT NULL COMMENT '参与者名称',
  PRIMARY KEY (`PCM_ID`),
  KEY `FK_REL_WF_PROC_PARTI` (`PROC_VERSION`,`PROC_ID`),
  CONSTRAINT `FK_REL_WF_PROC_PARTI` FOREIGN KEY (`PROC_VERSION`, `PROC_ID`) REFERENCES `wf_process` (`PROC_VERSION`, `PROC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程创建者与监控者';

/*Data for the table `wf_proc_creator_monitor` */

/*Table structure for table `wf_process` */

DROP TABLE IF EXISTS `wf_process`;

CREATE TABLE `wf_process` (
  `PROC_ID` varchar(64) NOT NULL COMMENT '流程ID',
  `PROC_VERSION` varchar(64) NOT NULL COMMENT '流程版本',
  `PROC_CATEGORY` varchar(64) DEFAULT NULL COMMENT '流程分类',
  `PROC_NAME` varchar(255) NOT NULL COMMENT '流程名称',
  `PROC_DESC` varchar(255) DEFAULT NULL COMMENT '流程描述',
  `START_NODE` varchar(64) DEFAULT NULL COMMENT '开始结点',
  `BUILDER` varchar(64) DEFAULT NULL COMMENT '创建人',
  `BUILD_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `MODIFIED_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '修改时间',
  `OVERDUE_TIMELIMIT` varchar(32) DEFAULT NULL COMMENT '超时时限',
  `OVERDUE_RDATA` varchar(64) DEFAULT NULL COMMENT '超时变量',
  `OVERDUE_ACTION` int(11) DEFAULT NULL COMMENT '超时动作\n            0等待，1终止，2挂起，3应用程序',
  `OVERDUE_APP` varchar(64) DEFAULT NULL COMMENT '超时应用',
  `REMIND_TIMELIMIT` varchar(32) DEFAULT NULL COMMENT '催办时限',
  `REMIND_RDATA` varchar(64) DEFAULT NULL COMMENT '催办变量',
  `REMIND_ACTION` int(11) DEFAULT NULL COMMENT '催办动作\n            0默认，1应用程序',
  `REMIND_APP` varchar(64) DEFAULT NULL COMMENT '催办应用',
  `REMIND_INTERVAL` varchar(32) DEFAULT NULL COMMENT '催办间隔',
  `REMIND_TIMES` int(11) DEFAULT NULL COMMENT '催办次数',
  `EXTEND_PROP` varchar(1024) DEFAULT NULL COMMENT '扩展属性',
  `PRE_CONDITION` varchar(1024) DEFAULT NULL COMMENT '前置条件',
  `POST_CONDITION` varchar(1024) DEFAULT NULL COMMENT '后置条件',
  `IS_ACTIVE_VERSION` int(11) NOT NULL DEFAULT '0' COMMENT '激活状态\n            0：未激活，1：激活',
  `HAS_PROC_INST` int(11) NOT NULL DEFAULT '0' COMMENT '流程是否被实例化过\n            0：不存在，1：存在',
  `PROC_XML` text COMMENT '流程XML文件',
  PRIMARY KEY (`PROC_VERSION`,`PROC_ID`),
  KEY `FK_REL_WF_PROC_CATEGORY` (`PROC_CATEGORY`),
  CONSTRAINT `FK_REL_WF_PROC_CATEGORY` FOREIGN KEY (`PROC_CATEGORY`) REFERENCES `wf_biz_category` (`BIZ_CATE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程';

/*Data for the table `wf_process` */

insert  into `wf_process`(`PROC_ID`,`PROC_VERSION`,`PROC_CATEGORY`,`PROC_NAME`,`PROC_DESC`,`START_NODE`,`BUILDER`,`BUILD_TIME`,`MODIFIED_TIME`,`OVERDUE_TIMELIMIT`,`OVERDUE_RDATA`,`OVERDUE_ACTION`,`OVERDUE_APP`,`REMIND_TIMELIMIT`,`REMIND_RDATA`,`REMIND_ACTION`,`REMIND_APP`,`REMIND_INTERVAL`,`REMIND_TIMES`,`EXTEND_PROP`,`PRE_CONDITION`,`POST_CONDITION`,`IS_ACTIVE_VERSION`,`HAS_PROC_INST`,`PROC_XML`) values ('4b3cbbd13eb3424880424d4e2034dbf2','1','1d370556bb344eb2ac611d9788682912','报销审批流程',NULL,NULL,'adminUser','2015-08-15 16:15:12','2015-08-15 16:06:18','0',NULL,0,NULL,'0',NULL,0,NULL,'0',0,NULL,NULL,NULL,1,1,'<process id=\"4b3cbbd13eb3424880424d4e2034dbf2\" version=\"1\" name=\"\">\n  <activity id=\"1439625890948\" name=\"报销申请\" x=\"361\" y=\"175\" imgUrl=\"resource/images/ihand_default.png\" activityType=\"manualNode\"/>\n  <activity id=\"1439625893956\" name=\"报销审核\" x=\"646\" y=\"177\" imgUrl=\"resource/images/ihand_default.png\" activityType=\"manualNode\"/>\n  <activity id=\"1439625897148\" name=\"报销打款\" x=\"928\" y=\"178\" imgUrl=\"resource/images/ihand_default.png\" activityType=\"manualNode\"/>\n  <activity id=\"1439625872990\" name=\"开始活动\" x=\"180\" y=\"179\" imgUrl=\"resource/images/display_star.png\" activityType=\"srartNode\"/>\n  <activity id=\"1439625900091\" name=\"结束活动\" x=\"1257\" y=\"187\" imgUrl=\"resource/images/display_end.png\" activityType=\"finishNode\"/>\n  <transition id=\"1439625902909\" fromActivity=\"1439625872990\" toActivity=\"1439625890948\" name=\"传输线1\">\n    <segment x=\"201\" y=\"200\" x2=\"361\" y2=\"200\"/>\n  </transition>\n  <transition id=\"1439625905172\" fromActivity=\"1439625890948\" toActivity=\"1439625893956\" name=\"传输线2\">\n    <segment x=\"421\" y=\"200\" x2=\"646\" y2=\"200\"/>\n  </transition>\n  <transition id=\"1439625907459\" fromActivity=\"1439625893956\" toActivity=\"1439625897148\" name=\"传输线3\">\n    <segment x=\"706\" y=\"202\" x2=\"928\" y2=\"202\"/>\n  </transition>\n  <transition id=\"1439625910036\" fromActivity=\"1439625897148\" toActivity=\"1439625900091\" name=\"传输线4\">\n    <segment x=\"988\" y=\"203\" x2=\"1257\" y2=\"203\"/>\n  </transition>\n</process>');

/*Table structure for table `wf_process_event` */

DROP TABLE IF EXISTS `wf_process_event`;

CREATE TABLE `wf_process_event` (
  `PROC_EVENT_ID` varchar(64) NOT NULL COMMENT '流程事件ID',
  `PROC_VERSION` varchar(64) NOT NULL COMMENT '流程版本',
  `PROC_ID` varchar(64) NOT NULL COMMENT '流程ID',
  `APP_ID` varchar(64) NOT NULL COMMENT '应用程序ID',
  `PROC_EVENT_TYPE` int(11) NOT NULL COMMENT '流程事件类型\n            0初始化，1开始，2重新开始，3挂起，4恢复，5激活，6去活化，7放弃，8完成',
  PRIMARY KEY (`PROC_EVENT_ID`),
  KEY `FK_REL_WF_PROC_EVENT` (`PROC_VERSION`,`PROC_ID`),
  KEY `FK_REL_WF_PROC_EVENT_APP` (`APP_ID`),
  CONSTRAINT `FK_REL_WF_PROC_EVENT` FOREIGN KEY (`PROC_VERSION`, `PROC_ID`) REFERENCES `wf_process` (`PROC_VERSION`, `PROC_ID`),
  CONSTRAINT `FK_REL_WF_PROC_EVENT_APP` FOREIGN KEY (`APP_ID`) REFERENCES `wf_application` (`APP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程事件';

/*Data for the table `wf_process_event` */

/*Table structure for table `wf_process_instance` */

DROP TABLE IF EXISTS `wf_process_instance`;

CREATE TABLE `wf_process_instance` (
  `PROC_INSTANCE_ID` varchar(64) NOT NULL COMMENT '流程实例标识',
  `PROCESS_ID` varchar(64) DEFAULT NULL COMMENT '流程定义标识',
  `PROCESS_VER` varchar(64) DEFAULT NULL COMMENT '流程定义版本号',
  `PROCESS_NAME` varchar(255) DEFAULT NULL COMMENT '流程定义名称',
  `PROCESS_CATEGORY` varchar(64) DEFAULT NULL COMMENT '流程定义分类',
  `PARENT_PROC_INST_ID` varchar(64) DEFAULT NULL COMMENT '父流程实例ID',
  `PARENT_ACT_INST_ID` varchar(64) DEFAULT NULL COMMENT '父活动实例ID',
  `NAME` varchar(255) DEFAULT NULL COMMENT '实例名称',
  `CREATER_ID` varchar(64) DEFAULT NULL COMMENT '创建者标识',
  `CURRENT_STATUS` int(11) NOT NULL COMMENT '当前状态',
  `HAS_OVERTIME` int(11) DEFAULT NULL COMMENT '是否已超时\n            0未超时，1已超时，null=0',
  `HAS_REMINDER` int(11) DEFAULT NULL COMMENT '是否有催办\n            0未催办，1已催办，null=0',
  `START_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '启动时间',
  `COMPLETE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '完成时间',
  `BUSINESS_ID` varchar(64) DEFAULT NULL COMMENT '业务主键',
  PRIMARY KEY (`PROC_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程实例';

/*Data for the table `wf_process_instance` */

insert  into `wf_process_instance`(`PROC_INSTANCE_ID`,`PROCESS_ID`,`PROCESS_VER`,`PROCESS_NAME`,`PROCESS_CATEGORY`,`PARENT_PROC_INST_ID`,`PARENT_ACT_INST_ID`,`NAME`,`CREATER_ID`,`CURRENT_STATUS`,`HAS_OVERTIME`,`HAS_REMINDER`,`START_TIME`,`COMPLETE_TIME`,`BUSINESS_ID`) values ('102a9fa9cdee42f297f050a6eb4e6d68','4b3cbbd13eb3424880424d4e2034dbf2','1','报销审批流程','1d370556bb344eb2ac611d9788682912',NULL,NULL,'新建流程实例','adminUser',5,0,0,'2015-08-15 16:33:23','2015-08-15 16:33:23',NULL);

/*Table structure for table `wf_process_instance_h` */

DROP TABLE IF EXISTS `wf_process_instance_h`;

CREATE TABLE `wf_process_instance_h` (
  `PROC_INSTANCE_ID` varchar(64) NOT NULL COMMENT '流程实例标识',
  `PROCESS_ID` varchar(64) DEFAULT NULL COMMENT '流程定义标识',
  `PROCESS_VER` varchar(64) DEFAULT NULL COMMENT '流程定义版本号',
  `PROCESS_NAME` varchar(255) DEFAULT NULL COMMENT '流程定义名称',
  `PROCESS_CATEGORY` varchar(64) DEFAULT NULL COMMENT '流程定义分类',
  `PARENT_PROC_INST_ID` varchar(64) DEFAULT NULL COMMENT '父流程实例ID',
  `PARENT_ACT_INST_ID` varchar(64) DEFAULT NULL COMMENT '父活动实例ID',
  `NAME` varchar(255) DEFAULT NULL COMMENT '实例名称',
  `CREATER_ID` varchar(64) DEFAULT NULL COMMENT '创建者标识',
  `CURRENT_STATUS` int(11) NOT NULL COMMENT '当前状态',
  `HAS_OVERTIME` int(11) DEFAULT NULL COMMENT '是否已超时\n            0未超时，1已超时，null=0',
  `HAS_REMINDER` int(11) DEFAULT NULL COMMENT '是否有催办\n            0未催办，1已催办，null=0',
  `START_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '启动时间',
  `COMPLETE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '完成时间',
  `BUSINESS_ID` varchar(64) DEFAULT NULL COMMENT '业务主键'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程实例_历史';

/*Data for the table `wf_process_instance_h` */

/*Table structure for table `wf_qrtz_job_details` */

DROP TABLE IF EXISTS `wf_qrtz_job_details`;

CREATE TABLE `wf_qrtz_job_details` (
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_VOLATILE` varchar(1) NOT NULL,
  `IS_STATEFUL` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`JOB_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_job_details` */

insert  into `wf_qrtz_job_details`(`JOB_NAME`,`JOB_GROUP`,`DESCRIPTION`,`JOB_CLASS_NAME`,`IS_DURABLE`,`IS_VOLATILE`,`IS_STATEFUL`,`REQUESTS_RECOVERY`,`JOB_DATA`) values ('WF_ENGINE_WALKER','WorkflowGroup',NULL,'com.dhc.workflow.engine.EngineWalker','0','0','0','0','��\0sr\0org.quartz.JobDataMap���迩��\0\0xr\0&org.quartz.utils.StringKeyDirtyFlagMap�����](\0Z\0allowsTransientDataxr\0org.quartz.utils.DirtyFlagMap�.�(v\n�\0Z\0dirtyL\0mapt\0Ljava/util/Map;xp\0sr\0java.util.HashMap���`�\0F\0\nloadFactorI\0	thresholdxp?@\0\0\0\0\0w\0\0\0\0\0\0\0x\0');

/*Table structure for table `wf_qrtz_job_listeners` */

DROP TABLE IF EXISTS `wf_qrtz_job_listeners`;

CREATE TABLE `wf_qrtz_job_listeners` (
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `JOB_LISTENER` varchar(200) NOT NULL,
  PRIMARY KEY (`JOB_NAME`,`JOB_GROUP`,`JOB_LISTENER`),
  CONSTRAINT `wf_qrtz_job_listeners_ibfk_1` FOREIGN KEY (`JOB_NAME`, `JOB_GROUP`) REFERENCES `wf_qrtz_job_details` (`JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_job_listeners` */

/*Table structure for table `wf_qrtz_locks` */

DROP TABLE IF EXISTS `wf_qrtz_locks`;

CREATE TABLE `wf_qrtz_locks` (
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_locks` */

insert  into `wf_qrtz_locks`(`LOCK_NAME`) values ('CALENDAR_ACCESS'),('JOB_ACCESS'),('MISFIRE_ACCESS'),('STATE_ACCESS'),('TRIGGER_ACCESS');

/*Table structure for table `wf_qrtz_paused_trigger_grps` */

DROP TABLE IF EXISTS `wf_qrtz_paused_trigger_grps`;

CREATE TABLE `wf_qrtz_paused_trigger_grps` (
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_paused_trigger_grps` */

/*Table structure for table `wf_qrtz_scheduler_state` */

DROP TABLE IF EXISTS `wf_qrtz_scheduler_state`;

CREATE TABLE `wf_qrtz_scheduler_state` (
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_scheduler_state` */

/*Table structure for table `wf_qrtz_simple_triggers` */

DROP TABLE IF EXISTS `wf_qrtz_simple_triggers`;

CREATE TABLE `wf_qrtz_simple_triggers` (
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `wf_qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `wf_qrtz_triggers` (`TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_simple_triggers` */

insert  into `wf_qrtz_simple_triggers`(`TRIGGER_NAME`,`TRIGGER_GROUP`,`REPEAT_COUNT`,`REPEAT_INTERVAL`,`TIMES_TRIGGERED`) values ('WF_ENGINE_WALKER.Trigger','WorkflowGroup',9999999,3000000,1);

/*Table structure for table `wf_qrtz_trigger_listeners` */

DROP TABLE IF EXISTS `wf_qrtz_trigger_listeners`;

CREATE TABLE `wf_qrtz_trigger_listeners` (
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `TRIGGER_LISTENER` varchar(200) NOT NULL,
  PRIMARY KEY (`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_LISTENER`),
  CONSTRAINT `wf_qrtz_trigger_listeners_ibfk_1` FOREIGN KEY (`TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `wf_qrtz_triggers` (`TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_trigger_listeners` */

/*Table structure for table `wf_qrtz_triggers` */

DROP TABLE IF EXISTS `wf_qrtz_triggers`;

CREATE TABLE `wf_qrtz_triggers` (
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `IS_VOLATILE` varchar(1) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `JOB_NAME` (`JOB_NAME`,`JOB_GROUP`),
  CONSTRAINT `wf_qrtz_triggers_ibfk_1` FOREIGN KEY (`JOB_NAME`, `JOB_GROUP`) REFERENCES `wf_qrtz_job_details` (`JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wf_qrtz_triggers` */

insert  into `wf_qrtz_triggers`(`TRIGGER_NAME`,`TRIGGER_GROUP`,`JOB_NAME`,`JOB_GROUP`,`IS_VOLATILE`,`DESCRIPTION`,`NEXT_FIRE_TIME`,`PREV_FIRE_TIME`,`PRIORITY`,`TRIGGER_STATE`,`TRIGGER_TYPE`,`START_TIME`,`END_TIME`,`CALENDAR_NAME`,`MISFIRE_INSTR`,`JOB_DATA`) values ('WF_ENGINE_WALKER.Trigger','WorkflowGroup','WF_ENGINE_WALKER','WorkflowGroup','0',NULL,1439631915699,1439628915699,5,'WAITING','SIMPLE',1439628915699,0,NULL,0,'');

/*Table structure for table `wf_rdata_instance` */

DROP TABLE IF EXISTS `wf_rdata_instance`;

CREATE TABLE `wf_rdata_instance` (
  `PROC_INSTANCE_ID` varchar(64) NOT NULL COMMENT '流程实例ID',
  `RDATA_ID` varchar(64) NOT NULL COMMENT '相关数据ID',
  `RDATA_NAME` varchar(64) DEFAULT NULL COMMENT '相关数据名称',
  `RDATA_TYPE` int(11) DEFAULT NULL COMMENT '相关数据类型',
  `RDATA_VALUE` varchar(1024) DEFAULT NULL COMMENT '相关数据值',
  PRIMARY KEY (`PROC_INSTANCE_ID`,`RDATA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='相关数据实例';

/*Data for the table `wf_rdata_instance` */

/*Table structure for table `wf_rdata_instance_h` */

DROP TABLE IF EXISTS `wf_rdata_instance_h`;

CREATE TABLE `wf_rdata_instance_h` (
  `PROC_INSTANCE_ID` varchar(64) NOT NULL COMMENT '流程实例ID',
  `RDATA_ID` varchar(64) NOT NULL COMMENT '相关数据ID',
  `RDATA_NAME` varchar(64) DEFAULT NULL COMMENT '相关数据名称',
  `RDATA_TYPE` int(11) DEFAULT NULL COMMENT '相关数据类型',
  `RDATA_VALUE` varchar(1024) DEFAULT NULL COMMENT '相关数据值'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='相关数据历史';

/*Data for the table `wf_rdata_instance_h` */

/*Table structure for table `wf_relate_data` */

DROP TABLE IF EXISTS `wf_relate_data`;

CREATE TABLE `wf_relate_data` (
  `RDATA_ID` varchar(64) NOT NULL COMMENT '相关数据ID',
  `PROC_VERSION` varchar(64) NOT NULL COMMENT '流程版本',
  `PROC_ID` varchar(64) NOT NULL COMMENT '流程ID',
  `RDATA_NAME` varchar(64) NOT NULL COMMENT '相关数据名称',
  `RDATA_TYPE` int(11) NOT NULL DEFAULT '0' COMMENT '相关数据类型\n            0字符串，1数值',
  `DEFAULT_VALUE` varchar(255) DEFAULT NULL COMMENT '相关数据缺省值',
  `RDATA_DESC` varchar(255) DEFAULT NULL COMMENT '相关数据描述',
  PRIMARY KEY (`RDATA_ID`),
  KEY `AK_AK_PROCESS_RDATA_NAME` (`PROC_VERSION`,`PROC_ID`,`RDATA_NAME`),
  CONSTRAINT `FK_REL_WF_RELATEDATA` FOREIGN KEY (`PROC_VERSION`, `PROC_ID`) REFERENCES `wf_process` (`PROC_VERSION`, `PROC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='相关数据';

/*Data for the table `wf_relate_data` */

/*Table structure for table `wf_sys_agent` */

DROP TABLE IF EXISTS `wf_sys_agent`;

CREATE TABLE `wf_sys_agent` (
  `AGENT_ID` varchar(64) NOT NULL COMMENT '工作项代理ID',
  `ORIGIN_USER` varchar(64) NOT NULL COMMENT '原用户',
  `ORIGIN_USER_NAME` varchar(64) DEFAULT NULL,
  `AGENT_USER` varchar(64) NOT NULL COMMENT '代理用户',
  `AGENT_USER_NAME` varchar(64) DEFAULT NULL,
  `START_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '开始时间',
  `END_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '结束时间',
  `PROC_TMP_ID` varchar(64) NOT NULL COMMENT '流程定义ID',
  `PROC_TMP_NAME` varchar(255) DEFAULT NULL COMMENT '流程定义名称',
  `CATEGORY_ID` varchar(64) NOT NULL COMMENT '分类ID',
  `CATEGORY_NAME` varchar(64) DEFAULT NULL COMMENT '分类名称',
  `CREATER_ID` varchar(64) NOT NULL COMMENT '创建人ID',
  `CREATER_NAME` varchar(64) DEFAULT NULL COMMENT '创建人姓名',
  PRIMARY KEY (`AGENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工作项代理';

/*Data for the table `wf_sys_agent` */

/*Table structure for table `wf_sys_workday` */

DROP TABLE IF EXISTS `wf_sys_workday`;

CREATE TABLE `wf_sys_workday` (
  `WORKDAY_ID` varchar(64) NOT NULL COMMENT '工作日ID',
  `PSN_ID` varchar(64) DEFAULT NULL COMMENT '人员ID',
  `WORKDAY_TYPE` int(11) DEFAULT NULL COMMENT '工作日类型',
  `WORKDAY_STATE` int(11) DEFAULT NULL COMMENT '工作日状态',
  `FROM_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '开始时间',
  `TO_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '结束时间',
  `WEEK_DAY` int(11) DEFAULT NULL COMMENT '周天',
  `MONTH_DAY` int(11) DEFAULT NULL COMMENT '月天',
  PRIMARY KEY (`WORKDAY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工作日';

/*Data for the table `wf_sys_workday` */

/*Table structure for table `wf_transition` */

DROP TABLE IF EXISTS `wf_transition`;

CREATE TABLE `wf_transition` (
  `TRANS_ID` varchar(64) NOT NULL COMMENT '传输线ID',
  `PROC_VERSION` varchar(64) NOT NULL COMMENT '流程版本',
  `PROC_ID` varchar(64) NOT NULL COMMENT '流程ID',
  `FROM_ACT_ID` varchar(64) NOT NULL COMMENT '来源活动',
  `TO_ACT_ID` varchar(64) NOT NULL COMMENT '目标活动',
  `ROUTE_PRIORITY` int(11) NOT NULL COMMENT '路由优先级',
  `ROUTE_CONDITION` varchar(1024) DEFAULT NULL COMMENT '路由条件',
  `TRANS_NAME` varchar(32) DEFAULT NULL COMMENT '传输线名称',
  `TRANS_DESC` varchar(255) DEFAULT NULL COMMENT '传输线描述',
  PRIMARY KEY (`TRANS_ID`),
  KEY `FK_REL_WF_ACT_FROM` (`FROM_ACT_ID`),
  KEY `FK_REL_WF_ACT_TO` (`TO_ACT_ID`),
  KEY `FK_REL_WF_TRANSITION` (`PROC_VERSION`,`PROC_ID`),
  CONSTRAINT `FK_REL_WF_ACT_FROM` FOREIGN KEY (`FROM_ACT_ID`) REFERENCES `wf_activity` (`ACT_ID`),
  CONSTRAINT `FK_REL_WF_ACT_TO` FOREIGN KEY (`TO_ACT_ID`) REFERENCES `wf_activity` (`ACT_ID`),
  CONSTRAINT `FK_REL_WF_TRANSITION` FOREIGN KEY (`PROC_VERSION`, `PROC_ID`) REFERENCES `wf_process` (`PROC_VERSION`, `PROC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='传输线';

/*Data for the table `wf_transition` */

insert  into `wf_transition`(`TRANS_ID`,`PROC_VERSION`,`PROC_ID`,`FROM_ACT_ID`,`TO_ACT_ID`,`ROUTE_PRIORITY`,`ROUTE_CONDITION`,`TRANS_NAME`,`TRANS_DESC`) values ('1439625902909','1','4b3cbbd13eb3424880424d4e2034dbf2','1439625872990','1439625890948',0,NULL,'传输线1',NULL),('1439625905172','1','4b3cbbd13eb3424880424d4e2034dbf2','1439625890948','1439625893956',0,NULL,'传输线2',NULL),('1439625907459','1','4b3cbbd13eb3424880424d4e2034dbf2','1439625893956','1439625897148',0,NULL,'传输线3',NULL),('1439625910036','1','4b3cbbd13eb3424880424d4e2034dbf2','1439625897148','1439625900091',0,NULL,'传输线4',NULL);

/*Table structure for table `wf_workitem` */

DROP TABLE IF EXISTS `wf_workitem`;

CREATE TABLE `wf_workitem` (
  `WORKITEM_INS_ID` varchar(64) NOT NULL COMMENT '工作项ID',
  `PROC_INSTANCE_ID` varchar(64) DEFAULT NULL COMMENT '流程实例ID',
  `ACTIVITY_INS_ID` varchar(64) NOT NULL COMMENT '活动实例ID',
  `NAME` varchar(64) DEFAULT NULL COMMENT '工作项名称',
  `CURRENT_STATUS` int(11) NOT NULL COMMENT '当前状态',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `ACCEPT_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '接收时间',
  `COMPLETE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '完成时间',
  `HAS_OVERTIME` int(11) DEFAULT NULL COMMENT '是否有超时',
  `ALREADY_OVERDUED` int(11) DEFAULT NULL COMMENT '是否超时',
  `SEND_TYPE` int(11) DEFAULT NULL COMMENT '办理方法.\n            0主送，1抄送',
  `PARTICIPANT_ID` varchar(64) DEFAULT NULL COMMENT '源参与者标识',
  `PARTICIPANT_NAME` varchar(32) DEFAULT NULL COMMENT '源参与者名称',
  `PARTICIPANT_TYPE` int(11) DEFAULT NULL COMMENT '源参与者类型',
  `HAS_SUBSTITUTED` int(11) DEFAULT NULL COMMENT '是否代理工作项',
  `ACTOR_ID` varchar(64) DEFAULT NULL COMMENT '代理参与者标识',
  `ACTOR_NAME` varchar(64) DEFAULT NULL COMMENT '代理参与者名称',
  `ACTOR_TYPE` int(11) DEFAULT NULL COMMENT '代理参与者类型',
  `EXT_PROP` varchar(1024) DEFAULT NULL COMMENT '扩展属性',
  `BUSINESSKEY` varchar(64) DEFAULT NULL COMMENT '业务主键',
  `RESULT_MEMO` varchar(255) DEFAULT NULL COMMENT '作业结果备注',
  PRIMARY KEY (`WORKITEM_INS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='作业项目';

/*Data for the table `wf_workitem` */

insert  into `wf_workitem`(`WORKITEM_INS_ID`,`PROC_INSTANCE_ID`,`ACTIVITY_INS_ID`,`NAME`,`CURRENT_STATUS`,`CREATE_TIME`,`ACCEPT_TIME`,`COMPLETE_TIME`,`HAS_OVERTIME`,`ALREADY_OVERDUED`,`SEND_TYPE`,`PARTICIPANT_ID`,`PARTICIPANT_NAME`,`PARTICIPANT_TYPE`,`HAS_SUBSTITUTED`,`ACTOR_ID`,`ACTOR_NAME`,`ACTOR_TYPE`,`EXT_PROP`,`BUSINESSKEY`,`RESULT_MEMO`) values ('19e89741362b44ce8b99e2f219234a33','102a9fa9cdee42f297f050a6eb4e6d68','e9b7e9c57bd24e39a892a9bf1e9c6fa2','报销申请',4,'2015-08-15 16:15:22','2015-08-15 16:15:12','2015-08-15 16:15:22',0,0,0,'adminUser','admin',0,0,NULL,NULL,NULL,NULL,NULL,NULL),('5dacdef3286342988ed77775dcbd3c84','102a9fa9cdee42f297f050a6eb4e6d68','fd13e85d448749fcb313da8371e32c40','报销审核',4,'2015-08-15 16:31:23','2015-08-15 16:15:22','2015-08-15 16:31:23',0,0,0,'bf11d09d35b54d2f8d36e4f045d5d85e','财务部经理',3,0,NULL,NULL,NULL,NULL,NULL,NULL),('6898d26dd9394c6b939c96c43c0c0209','102a9fa9cdee42f297f050a6eb4e6d68','bd3acd6d572c434db27aa8fdc8bc25dc','报销打款',4,'2015-08-15 16:33:23','2015-08-15 16:31:23','2015-08-15 16:33:23',0,0,0,'583512e1eb784dadb0d53fa9dca4d381','出纳',3,0,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `wf_workitem_h` */

DROP TABLE IF EXISTS `wf_workitem_h`;

CREATE TABLE `wf_workitem_h` (
  `WORKITEM_INS_ID` varchar(64) NOT NULL COMMENT '工作项ID',
  `PROC_INSTANCE_ID` varchar(64) DEFAULT NULL COMMENT '流程实例ID',
  `ACTIVITY_INS_ID` varchar(64) NOT NULL COMMENT '活动实例ID',
  `NAME` varchar(64) DEFAULT NULL COMMENT '工作项名称',
  `CURRENT_STATUS` int(11) NOT NULL COMMENT '当前状态',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `ACCEPT_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '接收时间',
  `COMPLETE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '完成时间',
  `HAS_OVERTIME` int(11) DEFAULT NULL COMMENT '是否有超时',
  `ALREADY_OVERDUED` int(11) DEFAULT NULL COMMENT '是否超时',
  `SEND_TYPE` int(11) DEFAULT NULL COMMENT '办理方法.\n            0主送，1抄送',
  `PARTICIPANT_ID` varchar(64) DEFAULT NULL COMMENT '源参与者标识',
  `PARTICIPANT_NAME` varchar(32) DEFAULT NULL COMMENT '源参与者名称',
  `PARTICIPANT_TYPE` int(11) DEFAULT NULL COMMENT '源参与者类型',
  `HAS_SUBSTITUTED` int(11) DEFAULT NULL COMMENT '是否代理工作项',
  `ACTOR_ID` varchar(64) DEFAULT NULL COMMENT '代理参与者标识',
  `ACTOR_NAME` varchar(64) DEFAULT NULL COMMENT '代理参与者名称',
  `ACTOR_TYPE` int(11) DEFAULT NULL COMMENT '代理参与者类型',
  `EXT_PROP` varchar(1024) DEFAULT NULL COMMENT '扩展属性',
  `BUSINESSKEY` varchar(64) DEFAULT NULL COMMENT '业务主键',
  `RESULT_MEMO` varchar(255) DEFAULT NULL COMMENT '作业结果备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='作业项目_历史';

/*Data for the table `wf_workitem_h` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

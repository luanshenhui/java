package com.hepowdhc.dcapp.modules.common.utils;

public class Constant {

	/**
	 * xxxxx
	 */
	public static final String XXXX_1 = "1";
	public static final String XXXX_2 = "2";

	/**
	 * 分割用符号
	 */
	public static final String SSX_C = "\\|\\|";
	public static final String SSX = "||";
	public static final String MINUS = "-";
	public static final String COLON = ":";
	public static final String COMMA = ",";

	/**
	 * 性别
	 */
	public static final String SEX_MALE = "1";// 男
	public static final String SEX_FEMALE = "2";// 女

	/**
	 * 主题库删除时对应提示信息的标志位
	 */
	public static final int TOPICLIB_DEL_SUC = 1;
	public static final int TOPICLIB_DEL_UNSUC = 2;

	/**
	 * 新增主题库时对应提示信息的标志位
	 */
	public static final int TOPICLIB_SAVE_SUC = 3;
	public static final int TOPICLIB_SAVE_UNSUC = 4;

	/**
	 * 主题库状态 0：停用 1：启用 2:已删除
	 */
	public static final String TOPICISSHOW_0 = "0";
	public static final String TOPICISSHOW_1 = "1";
	public static final String TOPICISSHOW_2 = "2";

	/**
	 * 主题库删除时对应提示信息的标志位 复选框选中“on”
	 */
	public static final String BOXCHECKED = "on";

	/**
	 * 保存关联物理表的时候页面是否发生变化 发生变化即可保存跳转：0 无可保存的操作：1
	 */
	public static final String REF_CHANGE_0 = "0";
	public static final String REF_UNCHANGE_1 = "1";

	/**
	 * 告警状态 1：告警中 2：已消警
	 */
	public static final String ALARMSTATUS_1 = "1";
	public static final String ALARMSTATUS_2 = "2";

	/**
	 * 界定动作 1：界定;2：撤销界定;3：转发界定
	 */
	public static final String DEFINE_ACTION_1 = "1";
	public static final String DEFINE_ACTION_2 = "2";
	public static final String DEFINE_ACTION_3 = "3";

	/**
	 * 界定状态 1:风险;2：非风险;3:未界定
	 */
	public static final String DEFINE_STATUS_1 = "1";
	public static final String DEFINE_STATUS_2 = "2";
	public static final String DEFINE_STATUS_3 = "3";

	/**
	 * 风险转发标识 0:未转发;1:转发
	 */
	public static final String RISK_TRANS_FLAG_0 = "0";
	public static final String RISK_TRANS_FLAG_1 = "1";

	/**
	 * 是否有界定权限 0:否;1：是
	 */
	public static final String IS_DEFINE_POWER_0 = "0";
	public static final String IS_DEFINE_POWER_1 = "1";

	/**
	 * 预警/风险维度 1:时间约束 2:行为约束 3:职能约束 4:互证约束
	 */
	public static final String ALARM_TYPE_1 = "1";
	public static final String ALARM_TYPE_2 = "2";
	public static final String ALARM_TYPE_3 = "3";
	public static final String ALARM_TYPE_4 = "4";

	/**
	 * 风险等级 10:高;20:中;30:低
	 */
	public static final String RISK_LEVEL_10 = "10";
	public static final String RISK_LEVEL_20 = "20";
	public static final String RISK_LEVEL_30 = "30";

	/**
	 * 预警/风险级别 1:绿色 2:黄色 3:橙色4:红色
	 */
	public static final String ALARM_LEVEL_1 = "1";
	public static final String ALARM_LEVEL_2 = "2";
	public static final String ALARM_LEVEL_3 = "3";
	public static final String ALARM_LEVEL_4 = "4";

	/**
	 * 时间格式
	 */
	public static final String DATE_FORMAT_YYYYMMDDHHMMSS = "yyyy-MM-dd HH:mm:ss";
	public static final String DATE_FORMAT_YYYYMMDD = "yyyy-MM-dd";
	public static final String DATE_FORMAT_YYYYMMDDHHMM = "yyyy-MM-dd HH:mm";
	public static final String DATE_FORMAT_YYYY = "yyyy";

	/**
	 * String True False
	 */
	public static final String STRING_TRUE = "true";
	public static final String STRING_FALSE = "false";

	/**
	 * 是否启用 0：未启用 1：启用
	 */
	public static final String CLOSE = "0";
	public static final String OPEN = "1";

	/**
	 * 首节点固定置为“-11111” 尾节点固定置为“-99999”
	 */
	public static final String START_TASK_ID = "-11111";
	public static final String END_TASK_ID = "-99999";

	/**
	 * 0：实时保存 1：保存
	 */
	public static final String ATUO_SAVE = "0";
	public static final String FINAL_SAVE = "1";

	/**
	 * 数据类型标示 mysql_data_type：mysql的数据类型
	 */
	public static final String MYSQL_DATA_TYPE = "mysql_data_type";
	/**
	 * mysql的数据类型:int、char、varchar、datetime、text
	 */
	public static final String MYSQL_INT = "int";
	public static final String MYSQL_CHAR = "char";
	public static final String MYSQL_VARCHAR = "varchar";
	public static final String MYSQL_DATETIME = "datetime";
	public static final String MYSQL_TEXT = "text";

	/**
	 * oracle_data_type：oracle的数据类型
	 */
	public static final String ORACLE_DATA_TYPE = "oracle_data_type";
	/**
	 * oracle的数据类型:NUMBER、NCHAR、NVARCHAR2、DATE、NCLOB
	 */
	public static final String ORACLE_NUMBER = "NUMBER";
	public static final String ORACLE_NCHAR = "NCHAR";
	public static final String ORACLE_NVARCHAR2 = "NVARCHAR2";
	public static final String ORACLE_DATE = "DATE";
	public static final String ORACLE_NCLOB = "NCLOB";
	public static final String ORACLE_NUMBER_KEY = "1";
	public static final String ORACLE_NCHAR_KEY = "2";
	public static final String ORACLE_NVARCHAR2_KEY = "3";
	public static final String ORACLE_DATE_KEY = "4";
	public static final String ORACLE_NCLOB_KEY = "5";
	public static final String ORACLE_DEL_FLG = "DEL_FLAG";
	public static final String ORACLE_CREATE_PERSON = "CREATE_PERSON";
	public static final String ORACLE_CREATE_DATE = "CREATE_TIME";
	public static final String ORACLE_UPDATE_PERSON = "UPDATE_PERSON";
	public static final String ORACLE_UPDATE_DATE = "UPDATE_TIME";
	public static final String ORACLE_REMARK = "REMARK";

	/**
	 * 错误信息
	 */
	public static final String ERROR_MSG = "errorMessage";

	/**
	 * 物理表开头字母
	 */
	public static final String TABLE_START = "DCA_PHY_";

	/**
	 * 主键
	 */
	public static final String PRIMARY_KEY = "P";

	/**
	 * 唯一约束
	 */
	public static final String UNIQUE = "U";

	/**
	 * 是：y,否:n
	 */
	public static final String YES = "Y";
	public static final String NO = "N";

	/**
	 * radio(是：y,否:n)
	 */
	public static final String RADIO_YES = "1";
	public static final String RADIO_NO = "0";

	/**
	 * 空（null字符串）
	 */
	public static final String STRING_NULL = "NULL";
	/**
	 * 空（""）
	 */
	public static final String BLANK = "";

	/**
	 * 工作流控件type属性
	 */
	public static final String START_ROUND = "start round";
	public static final String END_ROUND = "end round";
	public static final String MUTISELECT = "mutiselect";

	/**
	 * 首页配置表-总体数据
	 */
	public static final String OVER_ALL_DATA = "OverallData";
	/**
	 * 首页配置表-时间维度
	 */
	public static final String TIME_DIMENSION = "TimeDimension";
	/**
	 * 首页配置表-涉及部门
	 */
	public static final String INVOLVE_DEPT = "InvolveDept";
	/**
	 * 首页配置表-业务综合效能分析
	 */
	public static final String EFFICACY_ANALYSIS = "EfficacyAnalysis";
	/**
	 * 首页配置表-颜色（绿色）
	 */
	public static final String GREEN = "#61ac24";
	/**
	 * 首页配置表-颜色（橙色）
	 */
	public static final String ORANGE = "#fd7100";
	/**
	 * 首页配置表-颜色（黄色）
	 */
	public static final String YELLOW = "#ffc13b";
	/**
	 * 首页配置表-颜色（红色）
	 */
	public static final String RED = "#d20000";
	
	/**
	 * 各企业码表类型--绩效指标类型
	 */
	public static final String DICT_CUSTOM_TYPE_KPI_IDX_TYPE = "kpi_idx_type";
	/**
	 * 各企业码表类型--指标结果类型
	 */
	public static final String DICT_CUSTOM_TYPE_IDX_RESULT = "idx_result";
}

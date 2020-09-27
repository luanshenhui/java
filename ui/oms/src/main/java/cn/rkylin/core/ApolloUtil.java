package cn.rkylin.core;

import java.util.HashMap;
import java.util.Map;

public class ApolloUtil {
	/**
	 * map<space,sql_id>
	 */
	public static Map<String,String> NAMESPACE_MAP = new HashMap<String, String>();
	/**
	 * 启动时加载mapper.xml所有conn属性
	 * SQL_ID与conn数据源的对应关系 map<sql_id,conn>
	 */
	public static Map<String,String> CONN_MAP = new HashMap<String, String>();
	/**
	 * 启动时加载mapper.xml所有url属性
	 * SQL_ID与url的对应关系 map<sql_id,url>
	 */
	public static Map<String,String> URL_MAP = new HashMap<String, String>();
/*	*//**
	 * api 请求的监控配置
	 *//*
	public static Map<String,ApiWatchVo> WATCH_MAP = new HashMap<String, ApiWatchVo>();
	*/
	public static final String INDEX_PARAM = "index";//index参数名称
}

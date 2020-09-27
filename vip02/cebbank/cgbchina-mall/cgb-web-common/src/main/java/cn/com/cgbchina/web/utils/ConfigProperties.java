/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import lombok.extern.slf4j.Slf4j;

/**
 * @author wusy
 * @version 1.0
 * @Since 16-6-16.
 *
 *        读取配置文件属性
 */
@Slf4j
public class ConfigProperties {

	private static Properties props = null;
	// 高速缓存
	private static Map cashePropsMap = new HashMap();
	private static String projectHomePath;

	private static String[] module;

	/**
	 * 取得属性
	 * 
	 * @param key
	 * @return
	 */
	public static String getProperties(String key) {
		if (props == null)
			systemInit();
		String propsValue = (String) cashePropsMap.get(key);
		if (propsValue == null) {
			propsValue = props.getProperty(key);
			cashePropsMap.put(key, propsValue);
		}
		return propsValue;
	}

	/**
	 * 取得项目相关文件基路径
	 * 
	 * @return
	 */
	public static String getProjectHomePath() {
		if (props == null)
			systemInit();
		return projectHomePath;
	}

	/**
	 * 取得配置全路径（基路径+配置定义路径）
	 * 
	 * @param key
	 * @return
	 */
	public static String getFullPathProperties(String key) {
		if (props == null)
			systemInit();
		String propsValue = (String) cashePropsMap.get(key);
		if (propsValue == null) {
			propsValue = props.getProperty(key);
			cashePropsMap.put(key, propsValue);
		}
		return projectHomePath + propsValue;
	}

	private static void loadInitSystemProperties() {
		props = new Properties();
		InputStream in = null;
		try {
			in = ConfigProperties.class.getClassLoader().getResourceAsStream("config.properties");
			if (in != null) {
				props.load(in);
			} else {
				throw new RuntimeException("无法加载配置文件");
			}

			projectHomePath = props.getProperty("project.home.path");

		} catch (Exception ioe) {
			log.error(ioe.getMessage(), ioe);
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (IOException ioe) {
				log.error("初始化配置文件异常" + ioe.getMessage(), ioe);
			}
		}
	}

	/**
	 * 清除高速缓存
	 */
	public static void cleanCashe() {
		cashePropsMap.clear();
	}

	public static void systemInit() {
		loadInitSystemProperties();
	}

	public static void main(String[] arg) {
		String modules = getProperties("modules");
		System.out.println(modules);
	}

}

package com.dhc.base.context;

import java.util.Map;

public class AppConfig {

	private String configFile = null;
	private Map paramConfigFile = null;

	/**
	 * 
	 * 系统Spring框架下相关的配置文件
	 * 
	 * @return
	 */
	public String getConfigFile() {
		return configFile;
	}

	/**
	 * @param string
	 */
	public void setConfigFile(String string) {
		configFile = string;
	}

	/**
	 * @return
	 */
	public Map getParamConfigFile() {
		return paramConfigFile;
	}

	/**
	 * @param map
	 */
	public void setParamConfigFile(Map map) {
		paramConfigFile = map;
	}

}

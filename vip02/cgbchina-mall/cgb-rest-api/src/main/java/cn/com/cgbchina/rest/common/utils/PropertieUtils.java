package cn.com.cgbchina.rest.common.utils;

import java.util.Map;

public class PropertieUtils {

	private static Map<String, String> param;

	public static Map<String, String> getParam() {
		return param;
	}

	public void setParam(Map<String, String> param) {
		PropertieUtils.param = param;
	}

}

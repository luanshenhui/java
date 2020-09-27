package com.dhc.base.common.util;

import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

/**
 * Title: HttpUtil Description: 处理http对象的工具类
 */
public class HttpObjectUtil {

	/**
	 * 将请求中的参数数据转换为HashMap.
	 */
	public static HashMap getRequestParams(HttpServletRequest request) {
		Enumeration requestParams = request.getParameterNames();
		HashMap mapData = new HashMap();
		while (requestParams.hasMoreElements()) {
			String paramName = (String) requestParams.nextElement();
			String paramValue = request.getParameter(paramName);
			mapData.put(paramName, paramValue == null ? "" : paramValue);
		}
		return mapData;
	}
}

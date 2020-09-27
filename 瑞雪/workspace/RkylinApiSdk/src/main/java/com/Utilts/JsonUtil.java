package com.Utilts;

import net.sf.json.JSONObject;

/**
 * JSON工具类
 *
 * @author Administrator
 *
 */
public class JsonUtil {

	/**
	 * JSON转对象
	 *
	 * @return
	 *
	 * @return Object对象
	 */
	public static Object JsonToObject(Object objJson, Class<?> c) {
		JSONObject jsonObject = JSONObject.fromObject(objJson);
		return JSONObject.toBean(jsonObject, c);
	}

	/**
	 * JSON转对象
	 *
	 * @return
	 *
	 * @return Object对象
	 */
	public static Object JsonToObject(Object objJson) {
		return JSONObject.fromObject(objJson);
	}

	/**
	 * Object对象转Json
	 *
	 * @param obj
	 * @return
	 */
	public static String ObjectToJson(Object obj) {
		JSONObject jsonObject = JSONObject.fromObject(obj);
		return jsonObject.toString();
	}

}

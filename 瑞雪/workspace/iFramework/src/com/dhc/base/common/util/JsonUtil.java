package com.dhc.base.common.util;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonGenerator;
import org.codehaus.jackson.map.JavaTypeMapper;

public class JsonUtil {

	private static final Log log = LogFactory.getLog(JsonUtil.class);

	private static JsonFactory jf = new JsonFactory();

	/**
	 * 将JsonArray类型的字符串转换成List
	 * 
	 * @param str
	 * @return
	 */
	public static List<Map<String, String>> getListFromJsonArray(String str) {
		try {
			if (StringUtils.isNotBlank(str)) {
				ArrayList<Map<String, String>> arrList = (ArrayList<Map<String, String>>) new JavaTypeMapper()
						.read(jf.createJsonParser(new StringReader(str)));
				return arrList;
			} else {
				log.warn("JsonUtil.getListsFromJsonArray error : 输入的参数为null ");
				return null;
			}
		} catch (Exception e) {
			log.error("JsonUtil.getListsFromJsonArray error : " + e.getMessage(), e);
			return null;
		}
	}

	/**
	 * 将Json串转换成Map
	 * 
	 * @param str
	 * @return
	 */
	public static Map<String, String> getMapFromJsonString(String str) {
		try {
			if (StringUtils.isNotBlank(str)) {
				Map<String, String> map = (Map<String, String>) new JavaTypeMapper()
						.read(jf.createJsonParser(new StringReader(str)));
				return map;
			} else {
				log.warn("JsonUtil.getMapFromJsonString error : 输入的参数为null ");
				return null;
			}
		} catch (Exception e) {
			log.error("JsonUtil.getMapFromJsonString error : " + e.getMessage(), e);
			return null;
		}
	}

	/**
	 * 将List转换成Json串
	 * 
	 * @param list
	 * @return
	 */
	public static String getJsonStringFromList(List<Map<String, String>> list) {
		try {
			StringWriter sw = new StringWriter();
			JsonGenerator gen = jf.createJsonGenerator(sw);
			new JavaTypeMapper().writeAny(gen, list);
			gen.flush();
			return sw.toString();
		} catch (Exception e) {
			log.error("JsonUtil.getJsonStringFromMap error : " + e.getMessage(), e);
			return null;
		}
	}

	/**
	 * 将Map转换成
	 * 
	 * @param aMap
	 * @return
	 */
	public static String getJsonStringFromMap(Map<String, String> aMap) {
		try {
			StringWriter sw = new StringWriter();
			JsonGenerator gen = jf.createJsonGenerator(sw);
			new JavaTypeMapper().writeAny(gen, aMap);
			gen.flush();
			return sw.toString();
		} catch (Exception e) {
			log.error("JsonUtil.getJsonStringFromMap error : " + e.getMessage(), e);
			return null;
		}
	}

	/**
	 * Test Stub
	 *
	 * @param args
	 */
	public static void main(String[] args) {
		String test = "{\"email\":\"jason@hotmail.com\",\"name\":\"jason\"}";
		String store = "{\"limit\":4,\"root\":[{\"accountDetial\":\"杀手\",\"accountId\":\"197213\",\"commingAddr\":\"北京\",\"commingTime\":\"2009-12-08 15:27:25\"}], \"start\":0,\"success\":true,\"totalProperty\":1}";
		String detail = "{\"fieldsName\":[{\"stockinCargocode\",\"stockinLotno\",\"stockinLocation\",\"stockinInamt\",\"stockinOrderno\",\"remarks\"}],\"insertedRecords\":[[\"1\",\"2\",\"3\",\"4\",\"5\",\"6\"]],\"deletedRecords\":[],\"updatedRecords\":[]}";

		Map<String, String> map = new HashMap<String, String>();
		map.put("name", "jason");
		map.put("email", "jason@hotmail.com");

		// Convert map to JSON string
		String jsonString = JsonUtil.getJsonStringFromMap(map);
		System.out.println(jsonString);

		// Convert Json string to map
		Map<String, String> newMap = JsonUtil.getMapFromJsonString(test);
		System.out.println(newMap);

		Map<String, String> anotherMap = new HashMap<String, String>();
		anotherMap.put("name", "alice");
		anotherMap.put("email", "alice@hotmail.com");

		List<Map<String, String>> mapList = new ArrayList<Map<String, String>>();
		mapList.add(map);
		mapList.add(anotherMap);
		// Convert to json string
		jsonString = JsonUtil.getJsonStringFromList(mapList);
		System.out.println(jsonString);

		// Convert Json string to list of map
		List<Map<String, String>> newMapList = JsonUtil.getListFromJsonArray(jsonString);
		System.out.println(newMapList);

	}
}

package work.bean;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import net.sf.json.util.JSONUtils;
import net.sf.json.xml.XMLSerializer;

import org.apache.commons.io.IOUtils;
import org.w3c.dom.Document;

public class BasicBusiness {
	/**
	 * 方法名称:transStringToMap 传入参数:mapString 形如 username:chenziwen,password:1234
	 * 返回值:Map
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map transStringToMap(String mapString) {
		Map map = new HashMap();
		java.util.StringTokenizer items;
		for (StringTokenizer entrys = new StringTokenizer(mapString, ","); entrys
				.hasMoreTokens(); map.put(items.nextToken(),
				items.hasMoreTokens() ? ((Object) (items.nextToken())) : null))
			items = new StringTokenizer(entrys.nextToken(), ":");
		return map;
	}
	
	/**
	 * 方法名称:transMapToString
	 * 传入参数:map
	 * 返回值:String 形如 username'chenziwen^password'1234
	*/
	public static String transMapToString(Map<?, ?> map){
	  java.util.Map.Entry<?, ?> entry;
	  StringBuffer sb = new StringBuffer();
	  for(Iterator<?> iterator = map.entrySet().iterator(); iterator.hasNext();)
	  {
	    entry = (java.util.Map.Entry<?, ?>)iterator.next();
	      sb.append(entry.getKey().toString()).append( ":" ).append(null==entry.getValue()?"":
	      entry.getValue().toString()).append (iterator.hasNext() ? "," : "");
	  }
	  return sb.toString();
	}
	
	/**
	 * 将xml字符串转换为JSON对象
	 * 
	 * @param xmlFile
	 *            xml字符串
	 * @return JSON对象
	 */
	public static JSON getJSONFromXml(String xmlString) {
		XMLSerializer xmlSerializer = new XMLSerializer();
		JSON json = xmlSerializer.read(xmlString);
		return json;
	}

	/**
	 * 将xmlDocument转换为JSON对象
	 * 
	 * @param xmlDocument
	 *            XML Document
	 * @return JSON对象
	 */
	public static JSON getJSONFromXml(Document xmlDocument) {
		String xmlString = xmlDocument.toString();
		return getJSONFromXml(xmlString);
	}

	/**
	 * 将xml字符串转换为JSON字符串
	 * 
	 * @param xmlString
	 * @return JSON字符串
	 */
	public static String getJSONStringFromXml(String xmlString) {
		return getJSONFromXml(xmlString).toString();
	}

	/**
	 * 将xmlDocument转换为JSON字符串
	 * 
	 * @param xmlDocument
	 *            XML Document
	 * @return JSON字符串
	 */
	public static String getXMLtoJSONString(Document xmlDocument) {
		return getJSONStringFromXml(xmlDocument.toString());
	}

	/**
	 * 读取XML文件准换为JSON字符串
	 * 
	 * @param xmlFile
	 *            XML文件
	 * @return JSON字符串
	 */
	public static String getXMLFiletoJSONString(String xmlFile) {
		InputStream is = JSONUtils.class.getResourceAsStream(xmlFile);
		String xml;
		JSON json = null;
		try {
			xml = IOUtils.toString(is);
			XMLSerializer xmlSerializer = new XMLSerializer();
			json = xmlSerializer.read(xml);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return json.toString();
	}

	/**
	 * 将Java对象转换为JSON格式的字符串
	 * 
	 * @param javaObj
	 *            POJO,例如日志的model
	 * @return JSON格式的String字符串
	 */
	public static String getJsonStringFromJavaPOJO(Object javaObj) {
		return JSONObject.fromObject(javaObj).toString(1);
	}

	/**
	 * 将Map准换为JSON字符串
	 * 
	 * @param map
	 * @return JSON字符串
	 */
	public static String getJsonStringFromMap(Map<?, ?> map) {
		JSONObject object = JSONObject.fromObject(map);
		return object.toString();
	}

	public static String getJson2XML(String json) {
		JSONObject jobj = JSONObject.fromObject(json);
		String xml = new XMLSerializer().write(jobj);
		return xml;

	}
	
}

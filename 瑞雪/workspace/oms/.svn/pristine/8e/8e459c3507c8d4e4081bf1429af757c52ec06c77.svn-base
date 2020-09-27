package cn.rkylin.apollo.common.util;

import java.io.IOException;
import java.io.InputStream;
import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * @author zhangXinyuan
 */
public class PropertiesUtils {
	// 缺省设置
	private static String DEFAULT_PROPERTIES_NAME = "api";
	private static String DEFAULT_PROPERTIES = DEFAULT_PROPERTIES_NAME + ".properties";
	// 属性文件map
	private static Map<String, Properties> propMap = new HashMap<String, Properties>();
	// 属性文件map
	private static Map<String, ResourceBundle> rbMap = new HashMap<String, ResourceBundle>();
	// 所有属性map
	private static Map<String, String> propsMap = new HashMap<String, String>();

	private static final Log log = LogFactory.getLog(PropertiesUtils.class);

	/**
	 * @description 【获取属性文件列表】
	 * @param fileName
	 * @return
	 * @author zhangXinyuan
	 */
	public static Set getPropsKeySet(String fileName) {
		loadProperties(fileName);
		Set set = null;
		if (fileName.indexOf(".properties") >= 0) {
			Properties propertie = propMap.get(fileName);
			set = propertie.keySet();
		} else {
			ResourceBundle bundle = rbMap.get(fileName);
			set = bundle.keySet();
		}
		return set;
	}

	/**
	 * @description 【加载属性文件】
	 * @param fileName
	 * @author zhangXinyuan
	 */
	public static void loadProperties(String fileName) {
		if (fileName.indexOf(".properties") >= 0) {
			Properties propertie = null;
			if (propMap.get(fileName) == null) {
				propertie = new Properties();
				setProperties(propertie, fileName);
				propMap.put(fileName, propertie);
			}
		} else {
			ResourceBundle bundle = null;
			if (rbMap.get(fileName) == null) {
				bundle = ResourceBundle.getBundle(fileName);
				rbMap.put(fileName, bundle);
			}
		}
	}

	/**
	 * @description 【加载文件所有属性】
	 * @param fileName
	 * @author zhangXinyuan
	 */
	public static void loadPropsMap(String fileName) {
		if (fileName.indexOf(".properties") >= 0) {
			Properties propertie = propMap.get(fileName);
			Set<Object> set = propertie.keySet();
			if (set != null && set.size() > 0) {
				String key = null;
				for (Object obj : set) {
					key = (String) obj;
					if (!propsMap.containsKey(key)) {
						propsMap.put(key, propertie.getProperty(key));
					}
				}
			}
		} else {
			ResourceBundle bundle = rbMap.get(fileName);
			Set<String> set = bundle.keySet();
			if (set != null && set.size() > 0) {
				for (String key : set) {
					if (!propsMap.containsKey(key)) {
						propsMap.put(key, bundle.getString(key));
					}
				}
			}
		}
	}

	/**
	 * @description 【缺省加载属性文件】
	 * @param key
	 * @return
	 * @author zhangXinyuan
	 */
	public static String getVal(String key) {
		return getVal(DEFAULT_PROPERTIES_NAME, key);
	}

	/**
	 * @description 【通过资源文件中的key获取对应的值】
	 * @param key
	 * @return
	 * @author zhangXinyuan
	 */
	public static String getVal(String fileName, String key) {
		// if(MapUtils.isEmpty(propsMap)||StringUtils.isEmpty(propsMap.get(key))){
		// loadProperties(fileName);
		// loadPropsMap(fileName);
		// }

		// 返回结果
		String val = null;

		// 判断文件是否加载过
		// 判断文件是否加载过
		if (!propMap.containsKey(fileName) && !rbMap.containsKey(fileName)) {
			loadProperties(fileName);
			loadPropsMap(fileName);
		}

		// 判断指定所属配置文件取值
		if (fileName.indexOf(".properties") >= 0) {
			if (propMap.get(fileName).containsKey(key)) {
				val = propMap.get(fileName).getProperty(key);
			}
		} else {
			if (rbMap.get(fileName).containsKey(key)) {
				val = rbMap.get(fileName).getString(key);
			}
		}

		// 如果没取到 则所有配置文件中查找
		if (val == null && propsMap.containsKey(key)) {
			val = propsMap.get(key);
		}

		return val;
	}

	/**
	 * @description 【通过资源文件中的key获取对应的值】
	 * @param key
	 * @param params
	 * @return
	 * @author zhangXinyuan
	 */
	public static String getVal(String fileName, String key, Object... params) {
		String value = getVal(fileName, key);
		MessageFormat form = new MessageFormat(value);
		return form.format(value, params);
	}

	/**
	 * @description 【缺省通过资源文件中的key获取对应的值】
	 * @param key
	 * @param params
	 * @return
	 * @author zhangXinyuan
	 */
	public static String getVal(String key, Object... params) {
		String value = getVal(DEFAULT_PROPERTIES, key);
		MessageFormat form = new MessageFormat(value);
		return form.format(value, params);
	}

	/**
	 * @description 【装载配置文件】要读取的配置文件的路径+名称
	 * @param propertie
	 * @param fileName
	 * @author zhangXinyuan
	 */
	public static void setProperties(Properties propertie, String fileName) {
		InputStream inputStream = PropertiesUtils.class.getResourceAsStream(fileName);
		try {
			propertie.load(inputStream);
			inputStream.close();
		} catch (IOException e) {
			log.error("", e);
		}
	}
}

package cn.rkylin.core.utils;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;

/**
 * 
 * ClassName: PropertiesUtil
 * 
 * @Description: 解析系统中所有的properties文件
 * @author shixiaofeng@tootoo.cn
 * @date 2015年12月10日 上午11:49:21
 */
public class PropertiesUtils {

	private static PropertiesUtils propertiesutil;

	private static Map<String, ResourceBundle> propertiesResourceBundleMap = new HashMap<String, ResourceBundle>();// 存放properties文件

	private static Map<String, String> propertiesMap = new HashMap<String, String>();// 存放所有properties的key-value值

	private PropertiesUtils() {
		init();
	}

	public static PropertiesUtils getInstance() {
		if (propertiesutil == null) {
			propertiesutil = new PropertiesUtils();
		}
		return propertiesutil;
	}

	/**
	 * 
	 * @Description: 加载系统中用到的properties文件 void
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2015年12月10日 下午1:31:14
	 */
	private static void init() {
		try {
			String resourcedir = "conf";
			File baseFile = new File(PropertiesUtils.class.getResource("/")
					.getPath()
					+ "/" + resourcedir);
			File[] fileList = baseFile.listFiles();
			for (File file : fileList) {
				System.out.println(file.getName());
				if (file.isFile() && file.getName().endsWith(".properties")) {
					String name = file.getName();
					String newName = name.substring(0, name.length() - 11);
					ResourceBundle rb = ResourceBundle.getBundle("conf/"
							+ newName);
					propertiesResourceBundleMap.put(newName, rb);

					Set<String> keyList = rb.keySet();
					for (String key : keyList) {
						propertiesMap.put(key, rb.getString(key));
					}
				}
			}

		} catch (Exception e) {
			// LOGGER.error("init redis error", e);
		}
	}

	/**
	 * 
	 * @Description: 通过properties的名称和key值，获取value
	 * @param filename
	 * @param key
	 * @return String
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2015年12月10日 下午1:30:28
	 */
	public String getPropertyFromConfig(String filename, String key) {
		String value = "";
		if (propertiesResourceBundleMap.get(filename) != null) {
			value = propertiesResourceBundleMap.get(filename).getString(key);
		}
		return value;
	}

	/**
	 * 
	 * @Description: 通过properties的key值，获得value
	 * @param key
	 * @return String
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2015年12月10日 下午1:30:51
	 */
	public String getPropertyByKey(String key) {
		String value = "";
		if (propertiesMap.get(key) != null) {
			value = propertiesMap.get(key);
		}
		return value;
	}

	/**
	 * 
	 * @Description: 通过properties的key值，获得int型的value
	 * @param key
	 * @return
	 * @throws NumberFormatException
	 *             int
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2016-1-12 下午12:02:47
	 */
	public int getIntByKey(String key) throws NumberFormatException {
		return (int) getDoubleByKey(key);
	}

	/**
	 * 
	 * @Description: 通过properties的key值，获得double型的value
	 * @param key
	 * @return
	 * @throws NumberFormatException
	 *             double
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2016-1-12 下午12:03:08
	 */
	public double getDoubleByKey(String key) throws NumberFormatException {
		String tmp = getPropertyByKey(key);
		if (tmp == null)
			return -0;
		if (tmp.indexOf("*") > -1) {// 支持简单乘法计算
			String[] tmps = tmp.split("\\*");
			double value = 1.0;
			for (int i = 0; i < tmps.length; i++) {
				value = value * Double.parseDouble(tmps[i].trim());
			}
			return value;
		}
		return Double.parseDouble(tmp);
	}

	/**
	 * 
	 * @Description: 通过properties的key值，获得boolean型的value
	 * @param key
	 * @return boolean
	 * @throws
	 * @author shixiaofeng@tootoo.cn
	 * @date 2016-1-12 下午12:03:11
	 */
	public boolean getBooleanByKey(String key) {
		if (getPropertyByKey(key) == null)
			return false;
		return Boolean.parseBoolean(getPropertyByKey(key));
	}

	public static void main(String[] args) {

		String aa = PropertiesUtils.getInstance().getPropertyByKey(
				"redis.maxTotal");
		System.out.println(aa);
	}
}

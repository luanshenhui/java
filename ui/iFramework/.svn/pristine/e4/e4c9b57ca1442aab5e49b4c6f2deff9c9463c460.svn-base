package com.dhc.base.common.util;

import java.io.InputStream;
import java.io.IOException;
import java.io.FileInputStream;
import java.util.Properties;
import java.util.Hashtable;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Title: FileUtil Description: 处理读取文件信息的工具类
 */
public class FileUtil {
	private static Log log = LogFactory.getLog(FileUtil.class);
	private static java.util.Properties sysParams = null;

	/**
	 * 读取初始化文件. 返回初始化变量名称和变量值. 初始化文件格式: VAR=value
	 * 
	 * @param filename
	 */
	public static Hashtable readFile(String filename) {

		Properties property = new Properties();
		try {
			property.load(new FileInputStream(filename));
		} catch (IOException e) {
			log.error("读取初始化文件异常：" + System.getProperty("user.dir") + System.getProperty("file.separator") + "--"
					+ filename + "--" + e.getMessage());
		}

		return property;

	}

	/**
	 * 通过 class loader的相对路径获得 文件流
	 * 
	 * @param source
	 *            Path 相对classloader的路径:
	 */
	public static InputStream getStream(String sourcePath) {
		ClassLoader _loader = FileUtil.class.getClassLoader();
		return _loader.getResourceAsStream(sourcePath);
	}

	/**
	 * 通过 class loader的相对路径获得一个Properties文件的 Properties的对象.
	 * 
	 * @param source
	 *            Path 相对classloader的路径.
	 */
	public static Properties getProperties(String sourcePath) throws IOException {
		InputStream in = getStream(sourcePath);

		if (in == null)
			throw new IOException(sourcePath + "文件没有找到! 获取文件流为空.");

		Properties props = new Properties();
		props.load(in);

		return props;
	}

	/**
	 * 获取配置的系统信息 数据配置在SysParam.properties文件中. 如果没有找到字符的值,返回NULL
	 */
	public static String getSysParams(String paramKey) {
		if (sysParams == null)
			try {
				sysParams = FileUtil.getProperties("SysParams.properties");
			} catch (Exception e) {
				log.error("getSysParams:" + e.getMessage());
				e.printStackTrace();
				return null;
			}

		return StringUtil.convertToChinese(sysParams.getProperty(paramKey));
	}

	/**
	 * 获取配置的系统信息 数据配置文件中. 如果没有找到字符的值,返回NULL
	 */
	public static String getConfigParams(String properName, String paramKey) {

		Properties configParams = new Properties();

		try {
			configParams = FileUtil.getProperties(properName);
		} catch (Exception e) {
			log.error("getConfigParams:" + e.getMessage());
			e.printStackTrace();
			return null;
		}

		return StringUtil.convertToChinese(configParams.getProperty(paramKey));
	}

	/**
	 * 获取J2EE版本 配置在 SysParam.properties
	 */
	public static short getJ2eeVersion() {

		String j2eeVersion = getSysParams("J2EE_VERSION");

		if (j2eeVersion == null)
			return 140;

		return Short.parseShort(j2eeVersion);
	}
}

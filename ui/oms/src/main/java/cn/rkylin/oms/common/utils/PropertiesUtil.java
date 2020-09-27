package cn.rkylin.oms.common.utils;

import java.util.Locale;
import java.util.ResourceBundle;

public class PropertiesUtil {

	// 读取language.properties
	private static ResourceBundle languageBundle = ResourceBundle.getBundle("internationalization/resources/language");

	// 取得配置文件中的language的值
	public static String getLanguage() {
		return languageBundle.getString("language");
	}

	public static final String language = getLanguage();

	// 根据读取的language值初始化Locale
	private static Locale locale = new Locale(language);
	// 根据Locale读取ApplicationResources文件
	private static ResourceBundle bundle = ResourceBundle
			.getBundle("internationalization/resources/ApplicationResources", locale);

	/**
	 * @param key
	 * @return 如果配置文件中存在指定key，返回properties文件中key所对应的值 如果配置文件中不存在指定key，返回"".
	 */
	public static String getMessage(String key) {
		String retrievedValue = bundle.getString(key);
		return retrievedValue == null ? "" : retrievedValue;
	}
}

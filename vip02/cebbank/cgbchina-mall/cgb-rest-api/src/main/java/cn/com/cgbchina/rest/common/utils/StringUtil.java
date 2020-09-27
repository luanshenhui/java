package cn.com.cgbchina.rest.common.utils;

/**
 * Comment: Created by 11150321050126 on 2016/4/25.
 */
public class StringUtil {
	/**
	 * 首字母大写
	 * 
	 * @param name
	 * @return
	 */
	public static String captureName(String name) {
		char[] cs = name.toCharArray();
		cs[0] -= 32;
		return String.valueOf(cs);
	}
}

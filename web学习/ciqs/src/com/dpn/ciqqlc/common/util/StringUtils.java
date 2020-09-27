package com.dpn.ciqqlc.common.util;

import java.math.BigDecimal;

/**
 * 日期工具类
 * @author wzy
 *
 */
public class StringUtils {

	/**
	 * 过滤字符串
	 * @author wzy
	 * @param o 对象
	 * @return String
	 */
	public static String FilterNull(Object o){
		if(o != null && !"null".equals(o)){
			return o.toString().trim();
		}
		return "";
	}
	
	/**
	 * 验证字符串是否为空
	 * @author wzy
	 * @param o 
	 * @return Boolean
	 */
	public static Boolean isEmpty(Object o){
		if(o == null){
			return true;
		}else if("".equals(FilterNull(o))){
			return true;
		}
		return false;
	}
	
	/**
	 * 验证字符串是否不为空
	 * @author wzy
	 * @param o 
	 * @return Boolean
	 */
	public static Boolean isNotEmpty(Object o){
		if(o == null){
			return false;
		}else if("".equals(FilterNull(o))){
			return false;
		}
		return true;
	}
	
	/**
	 * 验证字符串是能转化为数字
	 * @author wzy
	 * @param o 
	 * @return Boolean
	 */
	public static Boolean isNum(Object o){
		try {
			new BigDecimal(o.toString());
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	
	/**
	 * 把int型转化为字符串，如不为数字型返回null
	 * @author wzy
	 * @param num 转换的int型数字
	 * @return String
	 */
	public static String intToString(Integer num){
		try {
			return String.valueOf(num);
		} catch (Exception e) {
			return null;
		}
	}
	
	/**
	 * 把数组拼接为按一定格式的字符串,如果转换失败返回null
	 * @author wzy
	 * @param  arr 转换的Object型组数
	 * @param  flag  拼接的符号
	 * @return String
	 */
	public static String intArrToString(Integer[] arr,String flag){
		try {
			StringBuilder strBder = new StringBuilder();
			if(arr != null){
				for (int i = 0; i < arr.length; i++) {
					strBder.append(arr[i]).append(flag);
				}
				String str = strBder.toString();
				str.substring(0,str.length()-1);
				return str;
			}
			return null;
		} catch (Exception e) {
			return null;
		}
	}
	
	/**
	 * 把数组拼接为按一定格式的字符串,如果转换失败返回null
	 * @author wzy
	 * @param  arr 转换的Object型组数
	 * @param  flag  拼接的符号
	 * @return String
	 */
	public static String strArrToString(String[] arr,String flag){
		try {
			StringBuilder strBder = new StringBuilder();
			if(arr != null){
				for (int i = 0; i < arr.length; i++) {
					strBder.append(arr[i]).append(flag);
				}
				String str = strBder.toString();
				str.substring(0,str.length()-1);
				return str;
			}
			return null;
		} catch (Exception e) {
			return null;
		}
	}
}

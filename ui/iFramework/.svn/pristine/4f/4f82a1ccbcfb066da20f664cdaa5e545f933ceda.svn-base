package com.dhc.base.common.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Title: StringUtil Description: 处理字符串的工具类
 */
public class StringUtil {

	/**
	 * 将字符串中的某字符替换为其它字符
	 * 
	 * @param origin
	 *            待转换的字符串
	 * @param _char
	 *            源字符
	 * @param target
	 *            目标字符
	 */
	public static String replace(String origin, String _char, String target) {
		int position = origin.indexOf(_char);
		while (position > 0) {
			origin = replace(origin, position, position + _char.length(), target);
			position = origin.indexOf(_char);
		}
		return origin;
	}

	/**
	 * 将字符串中的某位置的字符替换为其它字符
	 * 
	 * @param origin
	 *            待转换的字符串
	 * @param begin
	 *            起始位置：0 开始
	 * @param end
	 *            结束位置：0 开始
	 * @param target
	 *            目标替换字符串
	 */
	public static String replace(String origin, int begin, int end, String target) {

		StringBuffer strTemp = new StringBuffer(origin.substring(0, begin));
		int length = origin.length();
		strTemp.append(target);
		strTemp.append(origin.substring(end + 1, length));
		return strTemp.toString();

	}

	/**
	 * 转换字符串格式：定长截取和填充
	 * 
	 * @param param
	 *            将要转换的字符串。
	 * @param keepLength
	 *            保留字串的长度。
	 * @param doMethod
	 *            0: 后补 1: 前补
	 * @param ins
	 *            填充的内容。
	 */
	public static String changeString(String param, int keepLength, int doMethod, String ins) {

		String outStr = param;

		if (param.length() < keepLength) {

			String temp = "";
			for (int i = 0; i < keepLength - param.length(); i++) {
				temp += ins;
			}

			if (doMethod == 0) {
				outStr = temp + outStr;
			} else {
				outStr = outStr + temp;
			}

		} else {
			outStr = param.substring(0, keepLength);
		}
		return outStr;
	}

	/**
	 * 返回几个tab推进的字符串
	 */
	public static String tabs(int tabs) {
		// 推进几个tab
		String str_tab = "";

		for (int i = 0; i < tabs; i++)
			str_tab = str_tab + "	";

		return str_tab;
	}

	/**
	 * 取字符串的左端
	 * 
	 * @str 被检查的字符串
	 * @target 分隔的字符串
	 * @notFound 如果没有分隔字符串, 返回该值
	 */
	public static String left(String str, String target, String notFound) {

		if (str == null)
			return null;

		int pos = str.indexOf(target);
		if (pos >= 0) {
			return str.substring(0, pos);
		} else {
			return notFound;
		}

	}

	/**
	 * 取字符串的左端
	 * 
	 * @str 被检查的字符串
	 * @target 分隔的字符串
	 * @notFound 如果没有分隔字符串, 返回该值
	 * @dir 方向. 从左边 ? 右边
	 */
	public static String left(String str, String target, String notFound, int dir) {

		if (dir == 0)
			return left(str, target, notFound);

		if (str == null)
			return null;

		int pos = str.lastIndexOf(target);
		if (pos >= 0) {
			return str.substring(0, pos);
		} else {
			return notFound;
		}

	}

	/**
	 * 取字符串的右端
	 * 
	 * @str 被检查的字符串
	 * @target 分隔的字符串
	 * @notFound 如果没有分隔字符串, 返回该值
	 */
	public static String right(String str, String target, String notFound) {

		if (str == null)
			return null;

		int pos = str.indexOf(target);
		int length = str.length();
		if (pos >= 0) {
			if (pos == length - 1)
				return "";
			else
				return str.substring(pos + target.length(), length);
		} else {
			return notFound;
		}

	}

	/**
	 * 取字符串的右端
	 * 
	 * @str 被检查的字符串
	 * @target 分隔的字符串
	 * @notFound 如果没有分隔字符串, 返回该值
	 * @dir 方向. 从左边 ? 右边
	 */
	public static String right(String str, String target, String notFound, int dir) {

		if (dir == 0)
			return right(str, target, notFound);

		if (str == null)
			return null;

		int pos = str.lastIndexOf(target);
		int length = str.length();
		if (pos >= 0) {
			if (pos == length - 1)
				return "";
			else
				return str.substring(pos + target.length(), length);
		} else {
			return notFound;
		}

	}

	/**
	 * 计算字符串的某字符的个数
	 * 
	 * @str 被检查的字符串
	 * @target 分隔的字符串
	 */
	public static int count(String str, String target) {
		if (str.indexOf(target) > 0)
			return 1 + count(right(str, target, ""), target);
		else
			return 0;
	}

	/**
	 * 修改串的字符类型,将ISO8859-1转化为gb2312 如果已经是中文的字符,不能转化.
	 */
	public static String convertToChinese(String str) {

		// 空值判断
		if (str == null)
			return null;

		try {
			return new String(str.getBytes("ISO8859-1"), "gb2312");
		} catch (java.io.UnsupportedEncodingException stre) {
			stre.printStackTrace();
		}
		return null;
	}

	/**
	 * 获得堆栈信息串。
	 * 
	 * @param exception
	 * @return String
	 */
	public static String getStackTrace(Exception exception) {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		exception.printStackTrace(pw);
		return sw.toString();
	}
}

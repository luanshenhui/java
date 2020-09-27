/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.utils;

import java.util.Random;

/**
 * @author wusy
 * @version 1.0
 * @Since 16-6-21.
 */

public class Tools {
	/**
	 * 判断字符串是否为空串（null或者内容为空）
	 * 
	 * @param str
	 * @return
	 */
	private static char[] randomPwdStr = ("0123456789abcdefghijklmnopqrstuvwxyz").toCharArray();
	private static char[] numbersAndLetters = ("0123456789abcdefghijklmnopqrstuvwxyz"
			+ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").toCharArray();
	private static char[] numbers = ("0123456789").toCharArray();
	private static Random randGen = new Random();

	public static boolean isEmpty(String str) {
		if ((null == str) || (str.length() <= 0)) {
			return true;
		}

		return false;
	}

	// 转换引号
	public static String convertYH(String sorce) {
		if (Tools.isEmpty(sorce)) {
			return " ";
		}
		// sorce = sorce.replaceAll("'", " ");
		// sorce = sorce.replaceAll("\"", " ");
		return sorce;
	}

	/**
	 * 判断整数数组是否为空（null或者内容为空）
	 * 
	 * @param i
	 * @return
	 */
	public static boolean isEmpty(int i[]) {
		if ((null == i) || (i.length <= 0)) {
			return true;
		}

		return false;
	}

	/**
	 * 判断数组是否为空（null或者内容为空）
	 * 
	 * @param objs
	 * @return
	 */
	public static boolean isEmpty(Object objs[]) {
		if ((null == objs) || (objs.length <= 0)) {
			return true;
		}

		return false;
	}

	/**
	 * 清除字符串的左右空格
	 * 
	 * @param str
	 * @return:返回清除左右空格后的字符串
	 */
	public static String trim(String str) {
		if (null == str) {
			return "";
		}

		return str.trim();
	}

	/**
	 * 将字符串转成数字
	 * 
	 * @param string
	 * @param Default：默认值
	 * @return
	 */
	public static int toInt(String string, int Default) {
		if (Tools.isEmpty(string)) {
			return Default;
		}

		try {
			return Integer.parseInt(string);
		} catch (NumberFormatException e) {
			return Default;
		}
	}

	/**
	 * 增加判断ASCII的
	 **/
	public static boolean isXMLCharacter(int c) {
		if (c <= 0xD7FF) {
			if (c >= 0x20)
				return true;
			else {
				if (c == '\n')
					return true;
				if (c == '\r')
					return true;
				if (c == '\t')
					return true;
				return false;
			}
		}

		if (c < 0xE000)
			return false;
		if (c <= 0xFFFD)
			return true;
		if (c < 0x10000)
			return false;
		if (c <= 0x10FFFF)
			return true;

		return false;
	}

	public static boolean checkCharacterData(String text) {
		if (text == null) {
			return false;
		}

		// do check
		char[] data = text.toCharArray();
		for (int i = 0; i < data.length; i++) {
			char c = data[i];
			int result = c;
			// high surrogate
			if (result >= 0xD800 && result <= 0xDBFF) {
				// Decode surrogate pair
				int high = c;
				try {
					int low = text.charAt(i + 1);
					if (low < 0xDC00 || low > 0xDFFF) {
						return false;
						// throw new IllegalDataException(
						// "Bad surrogate pair"
					}
					// Algorithm defined in Unicode spec
					result = (high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000;
					i++;
				} catch (IndexOutOfBoundsException e) {
					return false;
					// throw new IllegalDataException(
					// "Bad surrogate pair"
				}
			}
			if (!isXMLCharacter(result)) {
				// Likely this character can't be easily displayed
				// because it's a control so we use its hexadecimal
				// representation in the reason.
				return false;
			}
		}

		// If we got here, everything is OK
		return true;
	}

	public static String getValidData(String str) {
		String ret = trim(str);
		if (checkCharacterData(ret)) {
			return ret;
		}

		return "";
	}

	public static boolean IsAllChar(String str) {

		boolean tag = false;
		char ss[] = str.toCharArray();
		for (int i = 0; i < str.length(); i++) {

			if (Character.toLowerCase(ss[i]) >= 97 && Character.toLowerCase(ss[i]) <= 122) {
				tag = true;

			} else {
				tag = false;
				break;
			}
		}
		return tag;
	}

	public static boolean IsAllMum(String str) {
		boolean tag = true;
		char ss[] = str.toCharArray();

		for (int i = 0; i < str.length(); i++) {

			if (!Character.isDigit(ss[i])) {
				tag = false;
				break;

			}

		}
		return tag;
	}

	public static final String replace(String line, String oldString, String newString) {
		if (line == null) {
			return null;
		}
		int i = 0;
		if ((i = line.indexOf(oldString, i)) >= 0) {
			char[] line2 = line.toCharArray();
			char[] newString2 = newString.toCharArray();
			int oLength = oldString.length();
			StringBuffer buf = new StringBuffer(line2.length);
			buf.append(line2, 0, i).append(newString2);
			i += oLength;
			int j = i;
			while ((i = line.indexOf(oldString, i)) > 0) {
				buf.append(line2, j, i - j).append(newString2);
				i += oLength;
				j = i;
			}
			buf.append(line2, j, line2.length - j);
			return buf.toString();
		}
		return line;
	}

	public static final String randomString(int length) {
		if (length < 1) {
			return null;
		}
		// Create a char buffer to put random letters and numbers in.
		char[] randBuffer = new char[length];
		for (int i = 0; i < randBuffer.length; i++) {
			randBuffer[i] = numbersAndLetters[randGen.nextInt(71)];
		}
		return new String(randBuffer);
	}

	// 过滤掉非assic码字符
	public static String repacleCharacterData(String text) {

		String value = text;

		if (text == null) {
			return "";
		}

		char[] data = text.toCharArray();
		for (int i = 0; i < data.length; i++) {
			char c = data[i];
			int result = c;

			if (result >= 0xD800 && result <= 0xDBFF) {

				int high = c;
				try {
					int low = text.charAt(i + 1);
					if (low < 0xDC00 || low > 0xDFFF) {
						value = String.valueOf(data[i]);
						text = Tools.replace(text, value, "");
						return text;
					}
					result = (high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000;
					i++;
				} catch (IndexOutOfBoundsException e) {
					value = String.valueOf(data[i]);
					text = Tools.replace(text, value, "");
					return text;
				}
			}
			if (!isXMLCharacter(result)) {

				value = String.valueOf(data[i]);
				text = Tools.replace(text, value, "");
				return text;
			}
		}

		return text;
	}

	// 去null值
	public static String delNull(String str) {

		str = str == null ? "" : str;

		return str;
	}

	/**
	 * 检查字符串是否合符不被注入要求
	 * 
	 * @param str
	 * @return
	 */
	public static boolean checkRegexInStr(String str) {
		boolean isOK = true;
		String regEx = "&|;|%|'|\"|\'|\\\"|>|<|\r|\n|\\(|\\)|\\+|\\-";
		if (str != null && regEx != null) {
			java.util.regex.Matcher mtr = java.util.regex.Pattern.compile(regEx).matcher(str);
			isOK = !mtr.find();
		} else {
			return false;
		}
		return isOK;
	}

	/**
	 * 2015-12-22 生产6位密码随机数
	 * 
	 * @param length
	 * @return
	 */
	public static final String randomPwd(int length) {
		if (length < 1) {
			return null;
		}
		char[] randBuffer = new char[length];
		for (int i = 0; i < randBuffer.length; i++) {
			randBuffer[i] = randomPwdStr[randGen.nextInt(36)];
		}
		return new String(randBuffer);
	}

	public static void main(String[] args) {
		// boolean a = Tools.checkRegexInStr("&111<");
	}

	/**
	 * 判断是否为手机号码
	 * 
	 * @param phone
	 * @return
	 */
	public static boolean isPhone(String phone) {
		String ext = "1[0-9]{10}";
		return phone.matches(ext);
	}
}

package cn.com.cgbchina.common.utils;

import java.io.UnsupportedEncodingException;

/**
 * 字符串工具类
 * 
 * @author JieXin li
 * @since 1.0
 * 
 */
public class StringUtils {
	public static final String WHITESPACE = " ";

	// 防止实例化
	private StringUtils() {
	};

	/**
	 * 返回长度为len的空格符
	 * 
	 * @param len 空格符的长度
	 * @return 长度为len的空格符
	 * @throws IllegalArgumentException 如果长度小于1
	 */
	public static String getWhitespace(int len) {
		if (len < 1)
			throw new IllegalArgumentException("长度不能小于1");
		StringBuilder builder = new StringBuilder();
		for (int i = 0; i < len; i++) {
			builder.append(WHITESPACE);
		}
		return builder.toString();
	}

	/**
	 * 检查字符串是否有内容
	 * 
	 * @param str 需要检查的字符串
	 * @return 如果 字符串不为<code>null</code> ，并且不全是空格符则返回<code>true</code> 否则返回 <code>false</code>
	 */
	public static boolean hasText(String str) {
		if (str == null)
			return false;
		if (str.trim().length() == 0)
			return false;
		return true;
	}

	/**
	 * 去掉所有空格符
	 * 
	 * @param str
	 * @return 去掉空格后的字符串
	 */
	public static String trimAllWhitespace(String str) {
		if (!hasText(str))
			return str;
		StringBuilder sb = new StringBuilder(str);
		int index = 0;
		while (sb.length() > index) {
			if (Character.isWhitespace(sb.charAt(index))) {
				sb.deleteCharAt(index);
			} else {
				index++;
			}
		}
		return sb.toString();
	}

	/**
	 * 比较字符串是否相等
	 * <p>
	 * 
	 * <pre>
	 * StringUtil.equals(null, null) = true
	 * StringUtil.equals("any", null) = false
	 * StringUtil.equals(null, "any") = false
	 * StringUtil.equals("any1", "any") = false
	 * StringUtil.equals("any", "any") = true
	 * </pre>
	 * 
	 * @param <code>str1</code> may be null
	 * @param <code>str2</code> may be null
	 * @return
	 */
	public static boolean equals(String str1, String str2) {
		return str1 == null ? str2 == null : str1.equals(str2);
	}

	/**
	 * 修剪字符串：去除两端空格
	 * 
	 * <pre>
	 * StringUtil.trim(null) = null
	 * StringUtil.trim("any") = "any"
	 * StringUtil.trim("any   ") = "any"
	 * StringUtil.trim("   any') = "any"
	 * StringUtil.trim("   any    ') = "any"
	 * </pre>
	 * 
	 * @param content
	 * @return
	 */
	public static String trim(String content) {
		return content == null ? null : content.trim();
	}

	/**
	 * 修剪字符串：去除两端指定字符
	 * 
	 * <pre>
	 * StringUtil.trim(null, any) = null
	 * StringUtil.trim("any", null) = "any"
	 * StringUtil.trim("aaaHello", 'a') = "Hello"
	 * StringUtil.trim("aaaHelloaaa", 'a') = "Hello"
	 * </pre>
	 * 
	 * @param content
	 * @param chart
	 * @return
	 */
	public static String trim(String content, char chart) {
		if (content == null) {
			return null;
		}
		char[] value = content.toCharArray();
		int count = value.length;
		int end = count;
		int start = 0; // 起始位
		while ((start < end) && (value[start] == chart)) {
			start++;
		}
		while ((start < end) && (value[end - 1] == chart)) {
			end--;
		}
		return ((start > 0) || (end < count)) ? content.substring(start, end) : content;
	}

	/**
	 * 修剪字符串：<strong>左边</strong>空格
	 * 
	 * <pre>
	 * StringUtil.trimLeft(null) = null
	 * StringUtil.trimLeft(" ") = ""
	 * StringUtil.trimLeft("  Hello") = "Hello"
	 * StringUtil.trimLeft(" Hello ") = "Hello "
	 * </pre>
	 * 
	 * @param content
	 * @return
	 */
	public static String trimLeft(String content) {
		if (content == null) {
			return null;
		}
		char[] value = content.toCharArray();
		int count = value.length;
		int start = 0; // 起始位
		while (start < count && value[start] <= ' ') {
			start++;
		}
		return start == 0 ? content : content.substring(start);
	}

	/**
	 * 修剪字符串：<strong>左边</strong>指定字符
	 * <p>
	 * *
	 * 
	 * <pre>
	 * StringUtil.trimLeft(null) = null
	 * StringUtil.trimLeft("123ABC123", 'A') = "123ABC123"
	 * StringUtil.trimLeft("123ABC123", '1') = "23ABC123"
	 * StringUtil.trimLeft("111ABC111", '1') = "ABC123"
	 * </pre>
	 * 
	 * @param content
	 * @return
	 */
	public static String trimLeft(String content, char chart) {
		if (content == null) {
			return null;
		}
		char[] value = content.toCharArray();
		int count = value.length;
		int start = 0; // 起始位
		while (start < count && value[start] == chart) {
			start++;
		}
		return start == 0 ? content : content.substring(start);
	}

	/**
	 * 修剪字符串：<strong>右边</strong>空格
	 * <p>
	 * 修剪原则参考{@link String}的trim()方法 *
	 * 
	 * <pre>
	 * StringUtil.trimRight(null) = null
	 * StringUtil.trimRight(" ") = ""
	 * StringUtil.trimRight("Hello  ") = "Hello"
	 * StringUtil.trimRight(" Hello ") = " Hello"
	 * </pre>
	 * 
	 * @param content
	 * @return
	 */
	public static String trimRight(String content) {
		if (content == null) {
			return null;
		}
		char[] value = content.toCharArray();
		int end = value.length;
		while (end > 0 && value[end - 1] <= ' ') {
			end--;
		}
		return end < value.length ? content.substring(0, end) : content;
	}

	/**
	 * 修剪字符串：<strong>右边</strong>指定字符
	 * 
	 * <pre>
	 * StringUtil.trimRight(null, 'A') = null
	 * StringUtil.trimRight("AAA", 'A') = ""
	 * StringUtil.trimRight("HelloAAA", 'A') = "Hello"
	 * StringUtil.trimRight("AAAHello", 'A') = "AAAHello"
	 * </pre>
	 * 
	 * @param content
	 * @return
	 */
	public static String trimRight(String content, char chart) {
		if (content == null) {
			return null;
		}
		char[] value = content.toCharArray();
		int end = value.length;
		while (end > 0 && value[end - 1] == chart) {
			end--;
		}
		return end < value.length ? content.substring(0, end) : content;
	}

	/**
	 * 首字母转大写
	 * <p>
	 * 
	 * @param content
	 * @return
	 */
	public static String firstToUpperCase(String content) {
		if (content == null)
			return null;
		char[] chars = content.toCharArray();
		// A = 97，Z = 122
		if (chars[0] >= 97 && chars[0] <= 122) {
			// if (chars[0] >= 'a' && chars[0] <= 'z') {
			chars[0] = (char) (chars[0] - 32);
			return new String(chars);
		}
		return content;
	}

	/**
	 * 首字母转小写
	 * <p>
	 * 
	 * @param content
	 * @return
	 */
	public static String firstToLowerCase(String content) {
		if (content == null)
			return null;
		char[] chars = content.toCharArray();
		// A = 65，Z = 90
		if (chars[0] >= 65 && chars[0] <= 90) {
			// if (chars[0] >= 'A' && chars[0] <= 'Z') {
			chars[0] = (char) (chars[0] + 32);
			return new String(chars);
		}
		return content;
	}

	/**
	 * 判断一个字符串是否为空
	 * 
	 * <pre>
	 * StringUtils.isEmpty(null) = true
	 * StringUtils.isEmpty("") = true
	 * StringUtils.isEmpty(" ") = false
	 * StringUtils.isEmpty("Hello") = false
	 * </pre>
	 * 
	 * @param <code>str</code> the String to check (may be <code>null</code>)
	 * @return <code>true</code> if the str is not null and has length
	 * @see #hasText(String)
	 */
	public static boolean isEmpty(String str) {
		return str == null ? true : !(str.length() > 0);
	}

	/**
	 * 判断一个字符串是否不为空
	 * 
	 * <pre>
	 * StringUtils.notEmpty(null) = false
	 * StringUtils.notEmpty("") = false
	 * StringUtils.notEmpty(" ") = true
	 * StringUtils.notEmpty("Hello") = true
	 * </pre>
	 * 
	 * @param <code>str</code> the String to check (may be <code>null</code>)
	 * @return <code>true</code> if the str is not null and has length
	 * @see #hasText(String)
	 */
	public static boolean notEmpty(String str) {
		return !isEmpty(str);
	}

	/**
	 * 判断一个字符串是否有长度
	 * <p>
	 * 
	 * <pre>
	 * StringUtils.hasLength(null) = false
	 * StringUtils.hasLength("") = false
	 * StringUtils.hasLength(" ") = false
	 * StringUtils.hasLength("Hello") = true
	 * </pre>
	 * 
	 * @param <code>str</code> the String to check (may be <code>null</code>)
	 * @return <code>true</code> if the str is not null and has length
	 * @see #hasText(String)
	 */
	public static boolean isTrimEmpty(String str) {
		return (str != null && str.trim().length() > 0);
	}

	/**
	 * 左边补充字符
	 * <p>
	 * 
	 * <pre>
	 * StringUtil.leftAppend("ABC", 5, '0') = 00ABC
	 * StringUtil.leftAppend("ABCDEF", 5, '0') = ABCDEF
	 * </pre>
	 * 
	 * @param content
	 * @param len
	 * @param fh
	 * @return
	 */
	public static String leftAppend(String content, int len, char fh) {
		if (content == null)
			content = "";
		if (content.length() < len) {
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < len - content.length(); i++) {
				sb.append(fh);
			}
			sb.append(content);
			return sb.toString();
		}
		return content;
	}

	/**
	 * 右边补充字符
	 * <p>
	 * 
	 * <pre>
	 * StringUtil.rightAppend("ABC", 5, '0') = ABC00
	 * StringUtil.rightAppend("ABCDEF", 5, '0') = ABCDEF
	 * </pre>
	 * 
	 * @param content
	 * @param len
	 * @param fh
	 * @return
	 */
	public static String rightAppend(String content, int len, char fh) {
		if (content == null)
			content = "";
		if (content.length() < len) {
			StringBuilder sb = new StringBuilder();
			sb.append(content);
			for (int i = 0; i < len - content.length(); i++) {
				sb.append(fh);
			}
			return sb.toString();
		}
		return content;
	}

	/**
	 * 返回指定字节数组长度的字符串
	 * 
	 * @param content 内容
	 * @param len 字节数组长度
	 * @return 指定字节数组长度的字符串
	 * @throws UnsupportedEncodingException 如果不支持gb2312编码
	 */
	public static String getFixByteLenOfString(String content, int len) throws UnsupportedEncodingException {
		return getFixByteLenOfString(content, len, "gb2312");
	}

	/**
	 * 返回指定字节数组长度的字符串
	 * 
	 * @param content 内容
	 * @param len 字节数组长度
	 * @param charSet 字符集编码
	 * @return 指定字节数组长度的字符串
	 * @throws UnsupportedEncodingException
	 * 
	 */
	public static String getFixByteLenOfString(String content, int len, String charSet)
			throws UnsupportedEncodingException {
		if (content == null) {
			return String.format("%" + len + "s", "");
		}

		String retValue = content.trim(); // 去除空格
		int zfLen = retValue.length(); // 字符长；
		int zjLen = retValue.getBytes(charSet).length; // 字节长度

		if (zjLen < len) {
			// 需要补空格
			return String.format("%-" + (len + zfLen - zjLen) + "s", retValue);
		}
		if (zjLen == len) {
			// 不需要补空格：直接返回
			return retValue;
		}

		// 需要截取字符咯
		do {
			retValue = retValue.substring(0, retValue.length() - 1);
			zfLen = retValue.length(); // 字符长；
			zjLen = retValue.getBytes(charSet).length; // 字节长度

			if (zjLen < len) {
				// 需要补空格
				return String.format("%-" + (len + zfLen - zjLen) + "s", retValue);
			}
			if (zjLen == len) {
				// 不需要补空格：直接返回
				return retValue;
			}
		} while (true);
	}

	/**
	 * 如果输入内容的长度比指定的长度大则返回长度为len右边的内容,如果长度不足则在前面补0
	 * 
	 * <pre>
	 * StringUtils.right("abcd",3) = bcd
	 * StringUtils.right("abcd",5) =0abcd
	 * </pre>
	 * 
	 * @param content 内容
	 * @param len 长度
	 * @return
	 */
	public static String right(String content, int len) {
		if (content.length() >= len) {
			return content.substring(content.length() - len, content.length());
		}
		StringBuilder sb = new StringBuilder(content);
		for (int i = 0; i < len - content.length(); i++) {
			sb.insert(0, "0");
		}
		return sb.toString();
	}

	/**
	 * 把char数组转换为String数组
	 * 
	 * @param chars
	 * @return string数组
	 */
	public static String[] valueOf(char[] chars) {
		String[] retVal = new String[chars.length];
		for (int i = 0; i < chars.length; i++) {
			retVal[i] = String.valueOf(chars[i]);
		}
		return retVal;
	}

}

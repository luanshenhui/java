package cn.com.cgbchina.common.utils;

import com.google.common.base.Ascii;
import com.google.common.base.CharMatcher;
import com.google.common.base.Strings;

import java.io.UnsupportedEncodingException;
import static com.google.common.base.CharMatcher.is;

/**
 * 字符串工具类
 * 
 * @author JieXin li
 * @since 1.0
 * 
 */
public class StringUtils {

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
        return Strings.padStart("", len, ' ');
    }

	/**
	 * 去掉所有空格符
	 * 
	 * @param str
	 * @return 去掉空格后的字符串
	 */
	public static String trimAllWhitespace(String str) {
        return CharMatcher.WHITESPACE.removeFrom(Strings.nullToEmpty(str));
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
	 * @param str1 may be null
	 * @param str2 may be null
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
        return (content == null) ? null : is(chart).trimFrom(content);
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
        return (content == null) ? null : CharMatcher.WHITESPACE.trimLeadingFrom(content);
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
        return (content == null) ? null : is(chart).trimLeadingFrom(content);
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
        return (content == null) ? null : CharMatcher.WHITESPACE.trimTrailingFrom(content);
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
        return (content == null) ? null : is(chart).trimTrailingFrom(content);
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
	 * @param str the String to check (may be <code>null</code>)
	 * @return true if the str is not null and has length
	 */
	public static boolean isEmpty(String str) {
		return Strings.isNullOrEmpty(str);
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
	 * @param str the String to check (may be <code>null</code>)
	 * @return true if the str is not null and has length
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
	 * @param str the String to check (may be <code>null</code>)
	 * @return true if the str is not null and has length
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
		return Strings.padStart(content, len, fh);
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
        return Strings.padEnd(content, len, fh);
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

	/**
	 * 截取s字符串的前i个字节
	 * @param s
	 * @param i
	 * @return
	 */
	public static String subTopString(String s,int i){
        return (s == null || "".equals(s.trim())) ? s : Ascii.truncate(s, i, "");
	}
	/**
	 * 判断字符串是否为NULL，NULL返回""
	 * @param o
	 * @return
	 */
	public static String dealNullObject(Object o){
        return (o == null) ? "" : o.toString();
	}

	/**
	 * 报文字符加空格
	 * @param all  字符串处理后长度
	 * @param str  字符串
	 * @return String
	 */
	public static String addNullString(int all,String str){
		int length=0;

		if(str==null){
			str="";
		}
		length=str.getBytes().length;

		if(length!=all){
			StringBuffer sb=new StringBuffer();
			sb.append(str);
			String nullStr=" ";
			int difference=all-length;
			for (int i = 0; i < difference; i++) {
				sb.append(nullStr);
			}
			return sb.toString();
		}

		return str;
	}

	/**
	 * 对卡号中间数字用＊代替
	 *
	 * @param cardNo
	 * @return
	 */
	public static String maskCardNo(String cardNo) {
		if (org.apache.commons.lang3.StringUtils.isBlank(cardNo)) {
			return cardNo;
		}
		return cardNo.substring(0, 4) + " * * * * * * * * " + cardNo.substring(cardNo.length() - 4, cardNo.length());
	}

	/**
	 *
	 * <p>Description:去空处理</p>
	 * @param str
	 * @return
	 */
	public static String dealNull(String str) {
		if (str == null) {
			return "";
		}
		return str.trim();
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
}

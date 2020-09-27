package com.dhc.base.common.util;

/**
 * <p>
 * Title: PassWord
 * </p>
 * <p>
 * Description: 口令加密/解密
 * </p>
 */

public class PassWord {
	private static final String m_strKey1 = "zxcvbnmtre,./asdfg";
	private static final String m_strKeya = "sdedgcjk;";
	private static final String m_strKey2 = "hjkl;'qwertyuiop";
	private static final String m_strKeyb = "caidfwyujg62";
	private static final String m_strKey3 = "[]\\1234567890-";
	private static final String m_strKeyc = "%^@#";
	private static final String m_strKey4 = "=` ZXCVBNM<>?:LKJ";
	private static final String m_strKeyd = "*(N";
	private static final String m_strKey5 = "HGFDSAQWERTYUI";
	private static final String m_strKeye = "%^HJ";
	private static final String m_strKey6 = "OP{}|+_)(*&^%$#@!~";

	/**
	 * 加密函数
	 * 
	 * 
	 * @param strPasswd
	 */
	public static String encode(String strPasswd) {
		if (strPasswd == null)
			return null;
		/* 加密前的密码 */
		String orig_passwd;
		/* 加密后返回的密码 */
		String strEncodePasswd = "";
		/* 常量字符串 */
		String strKey;
		/* 其他变量 */
		char code, mid = 0, temp = 0;
		int n, length, flag;

		/* 取得原密码 */
		orig_passwd = strPasswd;

		if (orig_passwd.length() == 0) {
			strEncodePasswd = "";
			return strEncodePasswd;
		}
		/* 得到常量字符串 */
		strKey = m_strKey1 + m_strKey2 + m_strKey3 + m_strKey4 + m_strKey5 + m_strKey6;

		/* 加密开始 */

		for (n = 0; n < orig_passwd.length(); n++) {
			while (true) {
				code = (char) (Math.rint(Math.random() * 100));
				while ((code > 0) && (((code ^ orig_passwd.charAt(n)) < 0) || ((code ^ orig_passwd.charAt(n)) > 90))) {
					code = (char) ((int) code - 1);
				}

				flag = code ^ orig_passwd.charAt(n);

				if (flag > 93) {
					mid = 0;
				} else {
					mid = strKey.charAt(flag);
				}

				/* 确保生成的字符是可见字符并且在SQL语句中有效 */
				if ((code > 35) && (code < 122) && (code != 124) && (code != 39) && (code != 44) && (mid != 124)
						&& (mid != 39) && (mid != 44)) {
					break;
				}

			}

			temp = strKey.charAt(code ^ orig_passwd.charAt(n));

			// 生成加密字符
			strEncodePasswd = strEncodePasswd + new Character(code).toString();
			strEncodePasswd = strEncodePasswd + new Character(temp).toString();

		}
		/* 加密结束 */
		return strEncodePasswd;
	}

	/**
	 * 解密函数
	 * 
	 * 
	 * @param strPasswd
	 */
	public static String decode(String strPasswd) {
		if (strPasswd == null)
			return null;
		/* 解密前的密码 */
		String orig_passwd;
		/* 解密后返回的密码 */
		String strDecodePasswd = "";
		/* 常量字符串 */
		String strKey;
		/* 其他变量 */
		char b;
		int n, length;

		/* 取解密前的密码 */
		orig_passwd = strPasswd;
		if (orig_passwd.length() == 0) {
			strDecodePasswd = "";
			return strDecodePasswd;
		}

		/* 得到常量字符串 */
		strKey = m_strKey1 + m_strKey2 + m_strKey3 + m_strKey4 + m_strKey5 + m_strKey6;

		if ((length = orig_passwd.length()) % 2 == 1) {
			orig_passwd = orig_passwd + "?";
		}

		for (n = 0; n <= orig_passwd.length() / 2 - 1; n++) {
			b = orig_passwd.charAt(n * 2);
			char c = (char) strKey.indexOf(orig_passwd.charAt(n * 2 + 1));
			int flag = b ^ c;
			char a = (char) flag;
			strDecodePasswd = strDecodePasswd + new Character(a).toString();
		}

		n = strDecodePasswd.indexOf(1);

		if (n > 0 && n <= strDecodePasswd.length()) {
			strDecodePasswd = strDecodePasswd.substring(0, n);
		}

		return strDecodePasswd;
	}

	public static void main(String args[]) {

	}

}


package com.dpn.dpows.common.util;

import java.io.UnsupportedEncodingException;
import java.security.SignatureException;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;

public class MD5Signature {

	public static String sign(String content, String key) {

		String tosign = (content == null ? "" : content) + key;

		try {
			return DigestUtils.md5Hex(getContentBytes(tosign, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	public static boolean verify(String content, String sign, String key) {
		String tosign = (content == null ? "" : content) + key;

		try {
			String mySign = DigestUtils.md5Hex(getContentBytes(tosign, "utf-8"));

			return mySign.equals(sign);
		} catch (UnsupportedEncodingException e) {
			System.out.println("MD5验证签名[content = " + content + "; signature = " + sign + "]发生异常!");
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * @param content
	 * @param charset
	 * @return
	 * @throws SignatureException
	 * @throws UnsupportedEncodingException
	 */
	protected static byte[] getContentBytes(String content, String charset) throws UnsupportedEncodingException {
		if (StringUtils.isBlank(charset)) {
			return content.getBytes();
		}

		return content.getBytes(charset);
	}

}

package com.thinkgem.jeesite.common.utils;

import java.util.Random;
import java.util.UUID;

public class UuidUtils {
	final static char[] digits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
			'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B',
			'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
			'X', 'Y', 'Z' };
	/**
	 * 支持的最大进制数
	 */
	public static final int MAX_RADIX = digits.length;

	/**
	 * 支持的最小进制数
	 */
	public static final int MIN_RADIX = 2;

	/****************** 方法一 start ******************/
	/**
	 * 随机ID生成器，由数字、小写字母和大写字母组成
	 * 
	 * @param size
	 * @return
	 */
	public static String randomId() {
		Random random = new Random();
		char[] cs = new char[10];
		for (int i = 0; i < cs.length; i++) {
			cs[i] = digits[random.nextInt(digits.length)];
		}
		return new String(cs);
	}

	/****************** 方法一 end ******************/

	/****************** 方法二 start ******************/
	public static String ShortUuid() {
		StringBuffer shortBuffer = new StringBuffer();
		String uuid = UUID.randomUUID().toString().replace("-", "");
		for (int i = 0; i < 8; i++) {
			String str = uuid.substring(i * 4, i * 4 + 4);
			int x = Integer.parseInt(str, 16);
			shortBuffer.append(digits[x % 0x3E]);
		}
		// System.out.println("shortUuid==" + shortBuffer.toString());
		return shortBuffer.toString();
	}

	/****************** 方法二 end ******************/

	/****************** 方法三 start ******************/
	public static String compressUuid() {
		UUID uuid = UUID.randomUUID();
		StringBuilder sb = new StringBuilder();
		sb.append(digits(uuid.getMostSignificantBits() >> 32, 8));
		sb.append(digits(uuid.getMostSignificantBits() >> 16, 4));
		sb.append(digits(uuid.getMostSignificantBits(), 4));
		sb.append(digits(uuid.getLeastSignificantBits() >> 48, 4));
		sb.append(digits(uuid.getLeastSignificantBits(), 12));
		return sb.toString();
	}

	private static String digits(long val, int digits) {
		long hi = 1L << (digits * 4);
		return toString(hi | (val & (hi - 1)), MAX_RADIX).substring(1);
	}

	/**
	 * 将长整型数值转换为指定的进制数（最大支持62进制，字母数字已经用尽）
	 * 
	 * @param i
	 * @param radix
	 * @return
	 */
	public static String toString(long i, int radix) {
		if (radix < MIN_RADIX || radix > MAX_RADIX)
			radix = 10;
		if (radix == 10)
			return Long.toString(i);

		final int size = 65;
		int charPos = 64;

		char[] buf = new char[size];
		boolean negative = (i < 0);

		if (!negative) {
			i = -i;
		}

		while (i <= -radix) {
			buf[charPos--] = digits[(int) (-(i % radix))];
			i = i / radix;
		}
		buf[charPos] = digits[(int) (-i)];

		if (negative) {
			buf[--charPos] = '-';
		}

		return new String(buf, charPos, (size - charPos));
	}

	/****************** 方法三 end ******************/

	public static void main(String[] args) {
		// int result = 0;
		// HashMap map = new HashMap();
		//
		// for (int i = 0; i < 1000; i++) {
		// String str = compressUuid();
		// System.out.println("str==" + str);
		// if (map.get(str) != null) {
		// break;
		// } else {
		// map.put(str, "hello");
		// }
		// result++;
		// }
		System.out.println("result==" + ShortUuid());

	}
}

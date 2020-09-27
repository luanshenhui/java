package cn.com.cgbchina.common.utils;

import java.util.Random;

/**
 * 随机数生成 Created by 11140721050130 on 2016/5/1.
 */
public class RandomHelper {

	private static Random randGen = new Random();

	private static char[] numbersAndLetters = ("0123456789abcdefghijklmnopqrstuvwxyz"
			+ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").toCharArray();
	private static char[] numbers = ("0123456789").toCharArray();

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

	public static final String randomNumber(int length) {
		if (length < 1) {
			return null;
		}
		// Create a char buffer to put random letters and numbers in.
		char[] randBuffer = new char[length];
		for (int i = 0; i < randBuffer.length; i++) {
			randBuffer[i] = numbers[randGen.nextInt(10)];
		}
		return new String(randBuffer);
	}
}

package day04;

import java.math.BigInteger;

public class BigIntegerDemo {
	public static void main(String[] args) {
		BigInteger num1 = new BigInteger("123");
		BigInteger num2 = BigInteger.valueOf(1);
		
		/**
		 * 200µÄ½×³Ë
		 */
		BigInteger num = new BigInteger("1");
		for(int i = 2;i<=200;i++){
			num = num.multiply(BigInteger.valueOf(i));
		}
		System.out.println(num);
	}
}





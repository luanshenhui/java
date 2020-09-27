package com.yulin.pm;

public class StringDemo {

	/**
	 * �ַ���ƴ��
	 * StringBuffer ��  StringBuilder
	 */
	public static void main(String[] args) {
		String str1 = "";
		StringBuffer sb1 = new StringBuffer();
		StringBuilder sb2 = new StringBuilder();
		long time1 = System.nanoTime();
		for(int i = 0; i < 10; i++){
			str1 += i;
		}
		long time2 = System.nanoTime();
		for(int i = 0; i < 10; i++){
			sb1.append(i);
		}
		long time3 = System.nanoTime();
		for(int i = 0; i < 10; i++){
			sb2.append(i);
		}
		long time4 = System.nanoTime();
		System.out.println("String�á�+����ƴ��ʱ��:" + (time2 - time1) + " ��ƴ�ӵ��ַ�����" + str1);
		System.out.println("StringBufferʱ��:" + (time3 - time2) + " ��ƴ�ӵ��ַ�����" + sb1);
		System.out.println("StringBuilderʱ��:" + (time4 - time3) + " ��ƴ�ӵ��ַ�����" + sb2.toString());
	}

}

package com.yulin.am;

public class StringDemo {

	/**
	 * �ַ�����
	 */
	public static void main(String[] args) {
		/**
		 * trim():��ȥ�ַ������˵Ŀո�
		 * split():����ĳ�������и��ַ��� *****
		 * indexOf():�����ַ�����ĳ���ַ���λ��
		 * startsWith():�Ƿ���ĳһ���ַ�Ϊ��ͷ
		 * endsWith():�Ƿ���ĳһ���ַ�Ϊ��β
		 * subString(int staart,int end):��ȡ�ַ���
		 * toCharArray():�����ַ����е��ַ�����
		 * matches():����������ʽ����ƥ�� *****
		 */
		
		//http://www.taobao.com/user/userLogin.action
		//��ϰ��ȡ��userLogin
		
		String str = "http://www.taobao.com/user/userLogin.action";
		str.lastIndexOf("/");
		String url = str.substring(str.lastIndexOf("/")+1,str.lastIndexOf("."));
		System.out.println(url);

		//������ʽ
		/**
		 * 1.�ж�һ���ַ����Ƿ�������
		 * 2.�ж�һ���ַ����Ƿ�����ĸΪ��ͷ
		 * 3.�ж�һ���ַ����Ƿ�ֻ�������ֺ���ĸ
		 * 4.�ж�һ���ַ����Ƿ������䡰abcdefg@sina.com.cn��
		 * 	@��֮ǰֻ������ĸ�����֡��»��ߡ�$,��ͷ��������ĸ���»��ߣ�������.com������.cn����.com.cn
		 */
		String str1 = "12345";
		System.out.println("�ַ����Ƿ�������:"+str1.matches("[0-9]+"));
		System.out.println("�ַ����Ƿ�������:"+str1.matches("\\d+"));
		
		String str2 = "ABcd";
		System.out.println("�ַ����Ƿ�����ĸΪ��ͷ:"+str2.matches("[\\p{Lower}\\p{Upper}]+.*"));
		
		String str3 = "abcd12";
		System.out.println("���������6λ������ĸ��ͷ:"+str3.matches("[a-zA-Z]{1}.{5}"));	//���������6λ������ĸ��ͷ
		
		String str4 = "abcdefg@sina.com.cn";
		System.out.println("�ַ����Ƿ�������:"+str4.matches("^[a-zA-Z_][a-zA-Z0-9_$]+@.+[([.][c][o][m])||([.][c][n])]"));
		
		String str5 = "abc123";
		System.out.println("�ַ����Ƿ�ֻ�������ֺ���ĸ��"+str5.matches("[a-zA-Z0-9]+"));
		
		//������AB12��ͷ����QQ��β
		String str6 = "AB12345QQ";
		System.out.println("������AB12��ͷ����QQ��β��"+str6.matches("[A][B][1][2].*[Q][Q]"));
	}

}

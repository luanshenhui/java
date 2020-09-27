package com.yulin.am;

public class StringDemo {

	/**
	 * 字符串类
	 */
	public static void main(String[] args) {
		/**
		 * trim():除去字符串两端的空格
		 * split():按照某个规则切割字符串 *****
		 * indexOf():返回字符串中某个字符的位置
		 * startsWith():是否以某一个字符为开头
		 * endsWith():是否以某一个字符为结尾
		 * subString(int staart,int end):截取字符串
		 * toCharArray():返回字符串中的字符数组
		 * matches():按照正则表达式进行匹配 *****
		 */
		
		//http://www.taobao.com/user/userLogin.action
		//练习：取出userLogin
		
		String str = "http://www.taobao.com/user/userLogin.action";
		str.lastIndexOf("/");
		String url = str.substring(str.lastIndexOf("/")+1,str.lastIndexOf("."));
		System.out.println(url);

		//正则表达式
		/**
		 * 1.判断一个字符串是否是数字
		 * 2.判断一个字符串是否以字母为开头
		 * 3.判断一个字符串是否只包含数字和字母
		 * 4.判断一个字符串是否是邮箱“abcdefg@sina.com.cn”
		 * 	@、之前只能是字母、数字、下划线、$,开头必须是字母或下划线，必须以.com或者是.cn或是.com.cn
		 */
		String str1 = "12345";
		System.out.println("字符串是否是数字:"+str1.matches("[0-9]+"));
		System.out.println("字符串是否是数字:"+str1.matches("\\d+"));
		
		String str2 = "ABcd";
		System.out.println("字符串是否以字母为开头:"+str2.matches("[\\p{Lower}\\p{Upper}]+.*"));
		
		String str3 = "abcd12";
		System.out.println("密码必须是6位，以字母开头:"+str3.matches("[a-zA-Z]{1}.{5}"));	//密码必须是6位，以字母开头
		
		String str4 = "abcdefg@sina.com.cn";
		System.out.println("字符串是否是邮箱:"+str4.matches("^[a-zA-Z_][a-zA-Z0-9_$]+@.+[([.][c][o][m])||([.][c][n])]"));
		
		String str5 = "abc123";
		System.out.println("字符串是否只包含数字和字母："+str5.matches("[a-zA-Z0-9]+"));
		
		//必须是AB12开头，以QQ结尾
		String str6 = "AB12345QQ";
		System.out.println("必须是AB12开头，以QQ结尾："+str6.matches("[A][B][1][2].*[Q][Q]"));
	}

}

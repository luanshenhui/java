package day02;
/**
 * 字符串支持正则表达式验证
 * @author Administrator
 *
 */
public class StringRex {
	public static void main(String[] args) {
		String mail = "595165358@qq.com";
		/**
		 * 定义正则表达式
		 * [\w]+@[0-9a-zA-Z]+\.com
		 */
		String rex = "[\\w]+@[0-9a-zA-Z]+\\.com";
//		System.out.println(rex);
		/**
		 * 字符串支持用正则表达式验证格式的方法matches
		 * 该方法返回一个boolean值
		 * true:表示当前字符串格式满足正则表达式要求 
		 */
		if(mail.matches(rex)){
			System.out.println("是一个邮箱地址");
		}else{
			System.out.println("不是一个邮箱地址");
		}
		
		
		/**
		 * 手机号
		 * [\d]{11}
		 * 13810000000
		 * +8613810000000
		 * 008613810000000
		 * +86 13810000000
		 * 0086 13810000000
		 */
		String phoneRex = "(\\+86|0086)?\\s?\\d{11}";
		
		/**
		 *  练习:
		 *    写一个能够验证身份证号的正则表达式
		 *    
		 *    身份证是15位或18位数字
		 *    若是18位还要考虑最后一位是不是x  x不区分大小写
		 */
	}
}









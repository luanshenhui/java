package day02;
/**
 * �ַ���֧��������ʽ��֤
 * @author Administrator
 *
 */
public class StringRex {
	public static void main(String[] args) {
		String mail = "595165358@qq.com";
		/**
		 * ����������ʽ
		 * [\w]+@[0-9a-zA-Z]+\.com
		 */
		String rex = "[\\w]+@[0-9a-zA-Z]+\\.com";
//		System.out.println(rex);
		/**
		 * �ַ���֧����������ʽ��֤��ʽ�ķ���matches
		 * �÷�������һ��booleanֵ
		 * true:��ʾ��ǰ�ַ�����ʽ����������ʽҪ�� 
		 */
		if(mail.matches(rex)){
			System.out.println("��һ�������ַ");
		}else{
			System.out.println("����һ�������ַ");
		}
		
		
		/**
		 * �ֻ���
		 * [\d]{11}
		 * 13810000000
		 * +8613810000000
		 * 008613810000000
		 * +86 13810000000
		 * 0086 13810000000
		 */
		String phoneRex = "(\\+86|0086)?\\s?\\d{11}";
		
		/**
		 *  ��ϰ:
		 *    дһ���ܹ���֤���֤�ŵ�������ʽ
		 *    
		 *    ���֤��15λ��18λ����
		 *    ����18λ��Ҫ�������һλ�ǲ���x  x�����ִ�Сд
		 */
	}
}









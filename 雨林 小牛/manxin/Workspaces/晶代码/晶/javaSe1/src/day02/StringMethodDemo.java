package day02;
/**
 * String����
 * @author Administrator
 *
 */
public class StringMethodDemo {
	public static void main(String[] args) {
		//            0123456789012345
		String str = "Thinking in Java";
		/**
		 * ��ȡ�ַ�����
		 * ������ȡ�м�
		 */
		String sub = str.substring(9,11);
		System.out.println("sub:["+sub+"]");
		
		/**
		 * ���ط���
		 * ��һ��ȡ���
		 */
		String sub2 = str.substring(9);
		System.out.println("sub2:["+sub2+"]");
		
	}
}






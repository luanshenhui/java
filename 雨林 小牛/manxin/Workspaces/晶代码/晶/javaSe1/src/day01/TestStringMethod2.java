package day01;
/**
 * �ַ������÷���2
 * @author Administrator
 *
 */
public class TestStringMethod2 {
	public static void main(String[] args) {
		/**
		 * һ�����顶java���˼�롷
		 */
		//            0123456789012345
		String str = "Thinking in Java";
		//����Java��str�е�λ��
		int index = str.indexOf("in");
		System.out.println(index);
		
		//��str��6���ַ���ʼ������һ�γ���in��λ��
		index = str.indexOf("in",5);
		System.out.println("index=" + index);
		
		//��str�м������һ�γ���in��λ��
		int last = str.lastIndexOf("in");
		System.out.println("last=" + last);
	
		//��ȡ�ַ�����ָ��λ�õ��ַ�
		char chr = str.charAt(5);
		System.out.println("chr:" + chr);
		
	}	

	
}









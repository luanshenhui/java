package day01;
/**
 * �ַ������÷���1
 * @author Administrator
 *
 */
public class TestStringMethod {
	public static void main(String[] args) {
		String str = "  HelloWorld		    ";
		String lower = str.toLowerCase();//���ַ���ת��ΪСд
		String upper = str.toUpperCase();//���ַ���ת��Ϊ��д
		
		System.out.println("lower:" + lower);
		System.out.println("upper:" + upper);
		
		String trim = str.trim();//ȥ���ַ������ߵĿհ�
		System.out.println("trim:" + trim);
		
		//�鿴str����ַ����Ƿ���"Hel"��ͷ
		boolean starts = str.startsWith("Hel");
		System.out.println("����Hel��ͷ:"+starts);
		
		//�鿴str����ַ����Ƿ���"orld"��β
//		String trims = str.trim();		
//		boolean ends = trims.endsWith("orld");
		
		//����ͬ��������
		boolean ends = str.trim().endsWith("orld");
		
		System.out.println("����orld��β:"+ends);
		
		
		/**
		 * ���Դ�Сд�Ƚ�
		 * �鿴�ַ����Ƿ���hell��ͷ
		 * 
		 * ˼·:
		 *   �ж�ʱֻҪ��ԭ���ַ��������Сд��ĸ���ں�����ַ���
		 *   �ȽϾͿ�����
		 *   HelloWorld ===>  helloworld
		 */
		//1 ��ȥ��ԭ���ַ���������Ŀհ�
		String trimStr = str.trim();
		//2 ���ַ���ת��Ϊ��Сд
		String lowerStr = trimStr.toLowerCase();
		//3 �ж��Ƿ���hell��ͷ
		boolean start = lowerStr.startsWith("hell");
		System.out.println("�Ƿ���hell��ͷ:"+start);
		//��������ͬ��������
		start = str.trim().toLowerCase().startsWith("hell");
		
		System.out.println("�ַ�������:"+str.length());
	}
}








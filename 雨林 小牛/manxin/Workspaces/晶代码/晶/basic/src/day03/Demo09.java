package day03;
/**
 * ������ n�� Ҫ���ս��Ʋ��� 0 ��� 
 *   n = 90, ������� 8λ����: 00000090
 * 
 * 1) ��������Ժ�ĳ���
 * 2) ��������롰0���ĸ���
 * 3) forѭ������0
 * 4) �������
 */
public class Demo09 {
	public static void main(String[] args) {
		int n = 90;
		String txt = Integer.toString(n);//90 -> "90" 
		int count = 8 - txt.length();//6
		for(int i=0; i<count; i++){
			//i = 0 1 2 3 4 5 <6
			System.out.print("#");
		}
		System.out.println(txt); 
	}
}




package day04;
/**
 * ���ù��ɶ�������������
 */
public class Demo06 {
	public static void main(String[] args) {
	 	//          x, y
		int[] p1 = {3,4}; //����һ���������
	 	int[] p2 = {6,8}; 
	 	int a = p1[1] - p2[1];// y �Ĳ�
	 	int b = p1[0] - p2[0];// x �Ĳ�
	 	//Math.sqrt ��Java API �ṩ�Ŀ�ƽ����ѧ���� 
	 	double c = Math.sqrt(a*a + b*b);
	 	System.out.println(c); 
	}
}

package Zonghe;

public class Jiaohuan {

	/**
	 * ������������ֵ
	 */
	public static void main(String[] args) {
		//1.
//		int a = 1;
//		int b = 2;
//		int c;
//		c = b;
//		b = a;
//		a = c;
//		System.out.println("a:"+a);
//		System.out.println("b:"+b);
		
		//2.
//		int a = 1;
//		int b = 2;
//		a = a + b;
//		b = a - b;
//		a = a - b;
//		System.out.println("a:"+a);
//		System.out.println("b:"+b);
		
		//3.
		int a = 1;
		int b = 2;
		a = a ^ b;
		b = a ^ b;
		a = a ^ b;
		System.out.println("a:"+a);
		System.out.println("b:"+b);
		/*ԭ��(�Ƚ϶����ƣ�0��1=1,1��1=0)
		a:0011:3
		b:0101:5
		--------
		a:0110:6
		b:0101:5
		---------
		b:0011:3
		a:0110:6
		--------
		a:0101:5*/
	}

}

package Zonghe;

public class Shulie {

	/**
	 * 输出费布拉奇数列的前20位
	 * 0,1,1,2,3,5,8,13，21......
	 * 前两位已知，数列从第三位开始
	 */
	public static void main(String[] args) {
		//方法1
		int a = 0;
		int b = 1;
		int c;
		System.out.println(a);
		System.out.println(b);	
		for(int i = 0; i <= 20; i++){
			c = a + b;
			System.out.println(c);
			a = b;
			b = c;
		}
		//方法2
		
		int d = 0;
		int e = 1;
		System.out.println(d);
		System.out.println(e);
		for(int i = 0; i <= 10; i++){
			d = d + e;
			System.out.println(d);
			e = d + e;
			System.out.println(e);
		}
	}

}

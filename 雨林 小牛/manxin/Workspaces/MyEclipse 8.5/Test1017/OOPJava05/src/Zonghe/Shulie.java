package Zonghe;

public class Shulie {

	/**
	 * ����Ѳ��������е�ǰ20λ
	 * 0,1,1,2,3,5,8,13��21......
	 * ǰ��λ��֪�����дӵ���λ��ʼ
	 */
	public static void main(String[] args) {
		//����1
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
		//����2
		
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

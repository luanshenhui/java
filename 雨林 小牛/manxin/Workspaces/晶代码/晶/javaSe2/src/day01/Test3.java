package day01;
/*
 * ����3�� ���finally�����û�з�����串�ǵĻ���
 * ��ôԭ���ķ���ֵ�Ͳ����,�������ǲ��Ǹı���Ҫ���ص��Ǹ�����.
 * yes  finally 23
 */
public class Test3 {
	 public static void main(String[] args) {
	        System.out.print(tt());	
	    }
	public static int tt() {
		int b = 23;
		try {
			System.out.println("yes");
			return b;
		} catch (Exception e) {
			System.out.println("error:" + e);
		} finally {
			if (b > 25) {
				System.out.println("b>25:" + b);
			}
			System.out.println("finally");
			b = 100;
		}
		return b;
	}
}

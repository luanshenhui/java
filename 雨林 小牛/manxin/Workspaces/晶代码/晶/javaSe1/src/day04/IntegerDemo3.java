package day04;

public class IntegerDemo3 {
	public static void main(String[] args) {
		Integer i = Integer.valueOf(1);
		/**
		 * �ֶ���װ��
		 */
		int a = i.intValue();//����		
		Integer c = Integer.valueOf(a);//װ��
		/**
		 * �Զ���װ��
		 */
		int d = i;
		Integer e = 1;
		print(d);
	}
	public static void print(Object o){
	}
}

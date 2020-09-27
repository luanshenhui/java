package day04;
/**
 * 쳲����� ����(��n�� ����Ǯ����ĺ�) 
 *        1  2  3  4  5  6  7  8  
 *        1  1  2  3  5  8 13 21 ... n-1  n
 *        ^  ^  ^        n
 *       f1 f2 fn
 *          f1 f2 fn
 *             f1 f2 fn
 *                f1 f2 fn
 *  i   
 * f1=1
 * f2=1
 *         fn = f1+f2 
 *         f1 = f2
 *         f2 = fn;
 * n = 6                            
 *           
 * ���� 쳲����� ����  ��n��  
 * �ƽ�ָ� 0.618 �� 쳲�����������������ı�ֵ
 */
public class Demo08 {
	public static void main(String[] args) {
		System.out.println(f(6));
		
	}
	public static long f(long n){
		long f1 = 1;
		long f2 = 1;
		long fn = 2;
		for(int i=3; i<=n; i++){
			fn = f1 + f2;
			f1 = f2;
			f2 = fn;
		}
		return fn;
	}
}




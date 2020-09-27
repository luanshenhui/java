package day04;
/**
 * 斐波那契 数列(第n项 等于钱两项的和) 
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
 * 计算 斐波那契 数列  的n项  
 * 黄金分割 0.618 是 斐波那契数列相邻两项的比值
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




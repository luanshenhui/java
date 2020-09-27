package day03;

/**
 * 输出 1000 以内的所有质数 (素数) 
 * 素数：一个数（>=2）只能被自身和1整除的数
 * * 如何判断一个数是否是质数！
 * 如果一个数除了1 和自身以外，有“约数”就不是质数了！
 *  如 6 = 3 * 2， 6 就不是 质数
 * 如何查找：24 的约数，如果有约数范围一定是：2 ~ <=24/2
 *  
 *  数 n = 57;
 *  假设是质数 isPrime = true
 *  int i = 2 ~ <=n/2  i++
 *    如果 n%i == 0 整除，i是 n的约数
 *    	n不是是质数 isPrime = false;
 *    	break;
 *    
 *    一个数如果有约数 那么他就不是质数
 *    一个数的约数的范围是到这个数/2
 *    假如给你一个数a 那么a % a/2 不等于0 就不是质数
 *    
 *    王大拿  刘大脑袋  小沈阳
 *    1243243
 */

public class Demo10 {
	public static void main(String[] args) {
		//这个for代表的是2~1000每一个数都试一边
		for(int n=2 ; n<=1000; n++){
			//int n = 53;// n = 2 3 4 5 .... 1000
			boolean isPrime = true;
			//此for循环的作用：看n这个数是否有约数
			//重点是知道约数在哪个范围
			for(int i=2; i<=n/2; i++){
				//int i = 2 ~ <=n/2  i++
				if(n % i ==0){
					isPrime = false; //如果发现了约数，就不在查找了
					break;//跳出当前最内层的循环
				}
			}
			if(isPrime){
				System.out.println(n +"是质数"); 
			}
		}
	}
}

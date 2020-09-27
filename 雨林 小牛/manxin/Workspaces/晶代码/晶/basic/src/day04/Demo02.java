package day04;
/**
 * 找到 100 ~ 999 之间的全部水仙花数（3位自幂数） 
 *  一个三位数   把每一位的数拿出来 然后每一位数立方  相加  等于原来的数
 * 1) 先计算一个数 num 是否是水仙花数
 *    1.1 拆开每位数，累加3次方的和 与 原始数 进行比较
 * 2) 再查找 100 ~ 999 范围内的全部水仙花数
 */
public class Demo02 {
	public static void main(String[] args) {
		for(int n=100; n<=999; n++){
			//n=100 ~ 999
			//int n = 153;
			int num = n;
			int sum = 0;
			do{
				int last = num%10;
				sum += last*last*last;//3次方和
				num /= 10;
				//System.out.println(last+","+num+","+sum); 
			}while(num!=0);
			if(sum == n){
				System.out.println(n+"是水仙花数");
			}
		}
	}
}




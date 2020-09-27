package day03;
/**
 * 计算
 *  sum  =   9 +        99       + 999 + 9999 + ... n个9
 * i   =     1           2           3
 * num=0 num*10+9  num*10+9   num*10+9
 *       sum=+num  sum=+num   sum=+num
 *       9+99+999+9999+99999
 *       
 */











public class Demo08 {
	public static void main(String[] args) {
		long sum = 0;
		long num = 0;
		for(int i=1; i<=7; i++){
			//i=2
			num = num*10+9;
			sum += num;//跟踪语句用于跟踪变量的变化情况
			//System.out.println(i+","+num+", "+sum);//跟踪语句
		}
		System.out.println(sum);
	}

}

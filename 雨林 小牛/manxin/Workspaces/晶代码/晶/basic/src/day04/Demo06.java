package day04;
/**
 * 利用勾股定理计算两点距离
 */
public class Demo06 {
	public static void main(String[] args) {
	 	//          x, y
		int[] p1 = {3,4}; //代表一个点的坐标
	 	int[] p2 = {6,8}; 
	 	int a = p1[1] - p2[1];// y 的差
	 	int b = p1[0] - p2[0];// x 的差
	 	//Math.sqrt 是Java API 提供的开平方数学函数 
	 	double c = Math.sqrt(a*a + b*b);
	 	System.out.println(c); 
	}
}

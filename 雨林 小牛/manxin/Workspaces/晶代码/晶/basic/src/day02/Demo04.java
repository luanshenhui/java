package day02;
/*
 * 数组  数的组合  一堆数   在一个数组里面只能有一种类型的数据
 * int[] String[] char[] Object[]
 * 
 * 卢雪峰  大连交通大学
 */
public class Demo04 {
	public static void main(String[] args) {
		int i = 0;
		System.out.println((i++) % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		System.out.println(i++ % 3);
		//int a = 1;
		//数组的下标是从0开始的
		String[] players = { "孙俪", "邓超", "佟大为" };
		//                     0       1       2
		String one = players[0];
		System.out.println(one);//孙俪
		i = 0;
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
		System.out.println(players[i++%3]); 
	}
}





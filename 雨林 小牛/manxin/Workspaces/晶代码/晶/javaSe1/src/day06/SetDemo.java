package day06;

import java.util.HashSet;
import java.util.Random;
import java.util.Set;

/**
 * Set集合
 * 不重复集
 * @author Administrator
 *
 */
public class SetDemo {
	public static void main(String[] args) {
		Set<Integer> set = new HashSet<Integer>();
		set.add(1);
		set.add(1);//重复元素不会添加到Set集合中
		System.out.println("size:"+set.size());
		
		/**
		 * 向集合中添加20个不重复随机数字
		 * 0-100之间
		 */
		Random r = new Random();
		int sum = 0;
//		while(set.size()<20){
//			//随机生成一个数字放入set集合
//			set.add(r.nextInt(100));
//			sum++;
//		}
		for(;set.size()<20;sum++){
			set.add(r.nextInt(100));
		}
		
		System.out.println(set);
		System.out.println("随机生成了:"+sum+"个数字");
		
		/**
		 * 编写一个1+2+3+....100
		 * 每次累加后都要输出结果
		 * 程序要求不得超过20(30)行
		 * 在程序中不能出现for while语句
		 */
	}
}












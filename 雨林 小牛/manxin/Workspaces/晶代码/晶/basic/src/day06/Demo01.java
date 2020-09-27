package day06;

import java.util.Arrays;
import java.util.Random;

import day05.Demo09;
/**
 * 比较  Arrays.sort(a) 和 Demo09.sort(ary) 性能
 */
public class Demo01 {
	public static void main(String[] args) {
		int[] ary1 = new int[10000];
		Random r = new Random();
		for(int i=0; i<ary1.length; i++){
			ary1[i] = r.nextInt();
		}
		int[] ary2 = Arrays.copyOf(ary1, ary1.length);
		long t1 = System.nanoTime();
		Arrays.sort(ary1);
		long t2 = System.nanoTime();
		Demo09.sort(ary2);
		long t3 = System.nanoTime();
		System.out.println(t2-t1); 
		System.out.println(t3-t2);
		System.out.println((double)(t3-t2)/(t2-t1));
	}
}





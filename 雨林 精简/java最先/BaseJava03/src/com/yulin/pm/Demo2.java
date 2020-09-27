package com.yulin.pm;
import java.util.*;
public class Demo2 {
	public static void main(String[] args){
		int[] ins={1,2,3,4,5};
		ins= Arrays.copyOf(ins,8);
		System.out.println(Arrays.toString(ins));
		int[]ins1={1,2,3,4,5};
		int[]ins2=ins1;
		ins2[0]=99;
		System.out.println(Arrays.toString(ins1));
		//[99,2,3,4,5]
		int[]ins3=Arrays.copyOf(ins1,5);//生成一个新的数组
		ins3[1]=99;
		System.out.println(Arrays.toString(ins1));
		
	}

}

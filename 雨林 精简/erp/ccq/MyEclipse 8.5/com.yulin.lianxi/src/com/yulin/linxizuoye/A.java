package com.yulin.linxizuoye;

public class A {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int [][]arr={{2,3},{1,8},{4,58,9}};
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i].toString().intern());
		}
		
		System.out.println("-------------------");
		int [][]com=new int[6][];
		for(int i=0;i<com.length;i++){
			
			System.out.println(com[i]);
			com[i]=new int[i+1];
			for(int j=0;j<com.length;j++){
				System.out.println();
			}
		}
	}

}

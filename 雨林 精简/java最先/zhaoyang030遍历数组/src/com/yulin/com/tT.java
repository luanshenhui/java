package com.yulin.com;

public class tT {
	public void m1(int v){
	public static void main(String[] args){
		for(int i=0;i<=v;i++){
		if(m2(i)){
			System.out.println(i);
		}
		}
	}
	
	private boolean m2(int i){
		for(int k=2;k<i;k++){
			if(i%k==0){
				return false;
			}
		}
		return true;
	}
}
}
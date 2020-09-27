package com.a;

public class Company {

	public static double avg(Member[] arr) {
		double sum=0;
		for(Member m:arr){
			sum+=m.getSalary();
		}
		return sum/arr.length;
		//return (arr[0].getSalary() + arr[1].getSalary() + arr[2].getSalary()) / 3;
	}

	public Member maxSalary(Member[] arr) {
		Member m = arr[0];
//		for (int i = 0; i < arr.length; i++) {
//			if (arr[0].getSalary() < arr[i].getSalary()) {
//				m = arr[i];
//			}
//		}
		
		for(Member mem:arr){
			if(mem.getSalary()>m.getSalary()){
				 m = mem;
			}
		}
		return m;//m;
		
	}

}

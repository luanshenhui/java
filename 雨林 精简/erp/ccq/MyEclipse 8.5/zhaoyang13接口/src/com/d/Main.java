package com.d;



public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
	Car c1=new Car("奔驰",30000);
	Car c2=new Car("宝马",40000);
	Car c3=new Car("奥迪",50000);
	Car[]carArr={c1,c2,c3};
	
	
	Person p3=new Person("赵武",50);
	Person p1=new Person("张三",30);
	Person p2=new Person("李四",40);
	Person[]personArr={p1,p2,p3};
	
	m1(carArr);//		按照价格排序
	m2(carArr);// 打印信息
	m1(personArr);//按照年龄排序
	m2(personArr);

	}

	private static void m2(Object[] arr) {
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i].toString());
		}
		
	}
	private static void m1(All[] arr) {
		for(int i=0;i<arr.length;i++){
			for(int j=0;j<arr.length-1-i;j++){
				if(arr[j].ms(arr[j+1])){
					All q=arr[j];
					arr[j]=arr[j+1];
					arr[j+1]=q;
				}
			}
			
		}
		
	}

//	private static void m1(Object[] arr) {
//		for(int i=0;i<arr.length;i++){
//			for(int j=0;j<arr.length-1-i;j++){
//				if(((All) arr[j]).ms(arr[j+1])){
//				Object q=arr[j];
//				arr[j]=arr[j+1];
//				arr[j+1]=q;
//			}
//		}
//		
//	}
//
//	}
	



	

}

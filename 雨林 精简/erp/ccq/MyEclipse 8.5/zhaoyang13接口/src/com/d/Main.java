package com.d;



public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
	Car c1=new Car("����",30000);
	Car c2=new Car("����",40000);
	Car c3=new Car("�µ�",50000);
	Car[]carArr={c1,c2,c3};
	
	
	Person p3=new Person("����",50);
	Person p1=new Person("����",30);
	Person p2=new Person("����",40);
	Person[]personArr={p1,p2,p3};
	
	m1(carArr);//		���ռ۸�����
	m2(carArr);// ��ӡ��Ϣ
	m1(personArr);//������������
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

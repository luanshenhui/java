package com.im;

public class Main {
	public static void main(String[] args) {
		Car c1=new Car("����",30000);
		Car c2=new Car("����",80000);
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

	private static void m2(Object[] obj) {
	for(int i=0;i<obj.length;i++){
		System.out.println(obj[i].toString());
	}
		
	}

	private static void m1(Ob[] obj) {
		// TODO Auto-generated method stub
		for(int i=0;i<obj.length;i++){
			for(int j=0;j<obj.length-i-1;j++){
					if((obj[j]).ms(obj[j+1])){
						Ob o=obj[j];
						obj[j]=obj[j+1];
						obj[j+1]=o;
				}
			}
		}
		
	}
}

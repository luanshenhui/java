package com.e;

import java.util.List;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		StudentService service=new StudentService();
		
		service.add(new Student("Andy",90));
		service.add(new Student("Bill",80));
		service.add(new Student("Cindy",100));
		service.add(new Student("Dural",40));
		service.add(new Student("Edin",70));
		service.add(new Student("Felix",50));
		service.add(new Student("Green",60));
		
		service.sort();//	�ɼ�����
		
		service.printAll();//�����Ϣ
		
		List<Student>list=service.getMaxMinStu();//�ҳ���ߺ���͵�ѧ�����ϵ�ѧ������
		for(Student s:list){
			System.out.println(s);
		}
		

	}

}

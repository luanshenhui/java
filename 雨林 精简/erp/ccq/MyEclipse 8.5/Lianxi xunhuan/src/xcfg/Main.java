package xcfg;

import java.util.List;

public class Main {

	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Student s1=new Student("A",'��',18);
		Student s2=new Student("E",'Ů',11);
		Student s3=new Student("C",'��',30);
		Student s4=new Student("B",'Ů',10);
		Student s5=new Student("D",'��',20);
		
		School sch=new School("44��");
		
		sch.add(s1);
		sch.add(s2);
		sch.add(s3);
		sch.add(s4);
		sch.add(s5);
		
		//sch.printAll();

		//�ҳ�����=18��ѧ������
		List<Student>list=sch.getStuByAge(18);
		for(Student s:list){
			System.out.println(s);
		}
		
		sch.printAllSort(list);//���䰸��С�����ӡ
		
	}//
	

}

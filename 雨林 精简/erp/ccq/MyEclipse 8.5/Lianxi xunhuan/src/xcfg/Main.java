package xcfg;

import java.util.List;

public class Main {

	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Student s1=new Student("A",'男',18);
		Student s2=new Student("E",'女',11);
		Student s3=new Student("C",'男',30);
		Student s4=new Student("B",'女',10);
		Student s5=new Student("D",'男',20);
		
		School sch=new School("44中");
		
		sch.add(s1);
		sch.add(s2);
		sch.add(s3);
		sch.add(s4);
		sch.add(s5);
		
		//sch.printAll();

		//找出年龄=18的学生集合
		List<Student>list=sch.getStuByAge(18);
		for(Student s:list){
			System.out.println(s);
		}
		
		sch.printAllSort(list);//年龄案从小到大打印
		
	}//
	

}

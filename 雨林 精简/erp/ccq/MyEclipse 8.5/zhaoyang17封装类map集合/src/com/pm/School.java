package com.pm;


import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class School {

	private String name = "44жа";

	public School(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	Map<String, Student> map = new HashMap<String, Student>();

	// Student v=new Student();
	public void add(Student s) {

		map.put(s.getName(), s);

	}

	public void printAll() {
		// TODO Auto-generated method stub
		// for(Student s:map.values()){
		System.out.println(map);
		// }

	}

	@Override
	public String toString() {
		return "School [name=" + name + "]";
	}

	public List<Student> getStuByAge(int age) {
		List<Student> list = new ArrayList<Student>();
		for (Student st : map.values()) {
			if (st.getAge() >= age) {
				// if(map.values().iterator().next().getAge()==age){
				// list.add(map.values().iterator().next());
				list.add(st);
			}
		}
		return list;
	}

	public void printAllSort(List<Student> list) {
		//Student stu = map.values().iterator().next();
		List<Student>list1=new ArrayList<Student>();
		System.out.println("3");
		for (int i = 0; i < list1.size(); i++) {
			System.out.println("4");
			for (int j = 0; j < list1.size() - i - 1; j++) {	
				if(list1.get(j).getAge()>list1.get(j+1).getAge()){
					System.out.println("1");
					Student s=list.get(j);
					list.remove(j);
					list.add(list.size(),s);
					
					System.out.println("2"+list);
					
				}
			}
		}
		Collections.sort(list);
		for(Student s:list){
			System.out.println("?"+s);
		}
	}

}

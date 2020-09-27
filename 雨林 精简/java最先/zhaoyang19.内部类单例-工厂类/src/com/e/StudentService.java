package com.e;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StudentService {

	List<Student> list = new ArrayList<Student>();

	public void add(Student student) {
		list.add(student);

	}

	public void sort() {
		// Map<String,Integer> map = new HashMap<String,Integer>();
		Collections.sort(list);
		for (Student s : list) {
			System.out.println("≥…º®À≥–Ú"+s);
		}

	}

	public void printAll() {
		// TODO Auto-generated method stub
		System.out.println("¥Ú”°"+list);

	}

	public List<Student> getMaxMinStu() {
		// TODO Auto-generated method stub
		List<Student> list1 = new ArrayList<Student>();
		Student stu = list.iterator().next();
		Student sto = list.iterator().next();
		for (Student s : list) {
			if (s.getGrade() < stu.getGrade()) {
				stu = s;
			}
			if (s.getGrade() > sto.getGrade()) {
				sto = s;
			}

		}
		list1.add(sto);
		list1.add(stu);

		return list1;
		
	}
}

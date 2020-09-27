package xcfg;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class School {

	private String name;

	public School(String name) {
		// TODO Auto-generated constructor stub
		this.name = name;
	}

	public School() {
		super();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	List<Student> list = new ArrayList<Student>();

	public void add(Student s1) {
		list.add(s1);

	}

	public void printAll() {
		// TODO Auto-generated method stub
		Iterator<Student> itor = list.iterator();
		while (itor.hasNext()) {
			Student s = itor.next();
			System.out.println(s);
		}
	}

	public List<Student> getStuByAge(int i) {
		Iterator<Student> itor = list.iterator();
		List<Student> list2 = new ArrayList<Student>();
		while (itor.hasNext()) {
			Student s = itor.next();
			System.out.println("        "+s);
			if(s.getAge()>i){
				list2.add(s);
			}
		}

		return list2;
	}

	public void printAllSort(List<Student> list) {
		// TODO Auto-generated method stub

	}

	@Override
	public String toString() {
		return "School [name=" + name + "]";
	}

}

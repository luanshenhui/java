package D;

import java.util.HashSet;
import java.util.Set;
import com.c.*;


public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Company com = new Company("IBM");

		Set<Employee> set = new HashSet<Employee>();
		set.add(new Employee("����", 3000.5));
		set.add(new Employee("����", 4500.5));
		set.add(new Employee("����", 5900.5));
		set.add(new Employee("����", 3300.5));
		set.add(new Employee("����", 6700.5));

		com.add(set);

//		int count = com.salaryCount();
//		System.out.println(count);
		com.addSalary(1000);//ÿ�˳�1000
		com.printAll();
		
		
		com.delSalary(5000);
		com.printAll();
	}

}

package q;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;





public class B {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Person p1=new Person("abc",30);
		Person p2=new Person("aac",80);
		Person p3=new Person("aca",70);
			
		List<Person>list=new ArrayList<Person>();
		
		list.add(p1);
		list.add(p2);
		list.add(p3);
		
		Collections.sort(list, new A());
		
		for(Person p:list){
			System.out.println(p);
		}

	}

}

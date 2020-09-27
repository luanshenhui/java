package q;

import java.util.Comparator;

public class A implements Comparator {

	@Override
	public int compare(Object o1, Object o2) {
		// TODO Auto-generated method stub
		Person p1=(Person)o1;
		Person p2=(Person)o2;
		return p1.getAge()-p2.getAge();
	}

}

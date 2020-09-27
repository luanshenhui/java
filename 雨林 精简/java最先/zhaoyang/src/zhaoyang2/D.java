package zhaoyang2;

public class D {
	public static void main(String[] args) {
		Employee e1=new Employee("李四",4000);
		Employee e2=new Employee("李四",4000);
		
		boolean boo=e1.m(e2);
		System.out.print(boo);
	}

}

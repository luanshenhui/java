



public class B {
	public static void main(String[] args) {
		Employee e1=new Employee("张三",3000);
		Employee e2=new Employee("李四",4000);
		Employee e3=new Employee("王五",5000);
		
		Employee[]arr={e1,e2,e3};
		
		C c=new C();
		
		Employee emp=c.m(arr);
		System.out.println(emp);
	}
}

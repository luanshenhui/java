



public class B {
	public static void main(String[] args) {
		Employee e1=new Employee("����",3000);
		Employee e2=new Employee("����",4000);
		Employee e3=new Employee("����",5000);
		
		Employee[]arr={e1,e2,e3};
		
		C c=new C();
		
		Employee emp=c.m(arr);
		System.out.println(emp);
	}
}

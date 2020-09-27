package day06;

public class TestPerson {
	public static void main(String[] args) {
		Person student = new Student();
		Person teacher = new Teacher();
		
		student.sayHello();
		
		System.out.println();
		
		teacher.sayHello();
	}
}

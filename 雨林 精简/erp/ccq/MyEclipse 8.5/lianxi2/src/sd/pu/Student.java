package sd.pu;

public class Student extends Person implements A{

	public Student(String name, int age) {
		super(name, age);
	}
	
	public void print() {
		System.out.println(this.getName()+this.getAge());
		
	}

	@Override
	public void write(A a) {
		System.out.println(this.getName()+this.getAge());
		
	}

	
	

}

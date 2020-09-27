package sd.pu;

public class Member extends Person implements A{

	private double salary;

	public Member(String name, int age, double salary) {
		super(name, age);
		this.salary = salary;
	}

	public double getSalary() {
		return salary;
	}

	public void setSalary(double salary) {
		this.salary = salary;
	}

	public void print() {
		System.out.println(this.getName()+this.getAge()+this.getSalary());
		
	}

	@Override
	public void write(A a) {
		System.out.println(this.getName()+this.getAge()+this.getSalary());
		
	}

	

}

package Main;

public class Employee extends Farther implements A{

	private int salary;

	public Employee(String name, int salary) {
		super(name);
		this.salary = salary;

	}

	public int getSalary() {
		return salary;
	}

	public void setSalary(int salary) {
		this.salary = salary;
	}

	@Override
	public boolean ms(A a) {
		Employee p1 = (Employee) a;
	
		
		return this.getSalary()>p1.getSalary();
	}

	@Override
	public String toString() {
		return this.getName()+this.salary;
	}

}

package zhaoyang2;

public class Employee {

	private String name;
	private double salary;
	

	public Employee(String name, int salary) {
		this.name = name;
		this.salary = salary;
	}

	public Employee() {
		// TODO Auto-generated constructor stub
	}

	public String getName() {
		return name;
	}

	public double getSalary() {
		return salary;
	}

	@Override
	public String toString() {
		return name + salary;
	}

	public boolean m(Employee e2) {
		if (this.getName().equals(e2.getName()) && this.getSalary() == e2.getSalary())

		{
			return true;
		} else {
			return false;
		}
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setSalary(double salary) {
		// TODO Auto-generated method stub
		this.salary=salary;
	}

	


	
}

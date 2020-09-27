
public class Employee {


	private double salary;
	private String name;

	


	public double getSalary() {
		return salary;
	}

	public String getName() {
		return name;
	}

	/**
	 * @param salary
	 * @param name
	 */
	public Employee(String name,double salary) {
		super();
		this.salary = salary;
		this.name = name;
	}

	public Employee() {
		// TODO Auto-generated constructor stub
	}

	public void setName(String name) {
		// TODO Auto-generated method stub
		this.name=name;
	}

	public void setSalary(double salary) {
		// TODO Auto-generated method stub
		this.salary=salary;
	}

	@Override
	public String toString() {
		return name+salary;
	}

}

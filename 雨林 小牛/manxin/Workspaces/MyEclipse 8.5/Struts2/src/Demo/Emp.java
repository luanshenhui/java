package Demo;

public class Emp {
	private String name;
	private double salary;
	private Dept dept;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public double getSalary() {
		return salary;
	}
	public void setSalary(double salary) {
		this.salary = salary;
	}
	public Dept getDept() {
		return dept;
	}
	public void setDept(Dept dept) {
		this.dept = dept;
	}
	public Emp(String name, double salary, Dept dept) {
//		super();
		this.name = name;
		this.salary = salary;
		this.dept = dept;
	}
}

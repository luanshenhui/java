package Demo2.entity;

public class Bean {
	private int d_id;
	private String d_name;
	private int d_age;
	private double d_salary;
	public int getD_id() {
		return d_id;
	}
	public void setD_id(int dId) {
		d_id = dId;
	}
	public String getD_name() {
		return d_name;
	}
	public void setD_name(String dName) {
		d_name = dName;
	}
	public int getD_age() {
		return d_age;
	}
	public void setD_age(int dAge) {
		d_age = dAge;
	}
	public double getD_salary() {
		return d_salary;
	}
	public void setD_salary(double dSalary) {
		d_salary = dSalary;
	}
	public Bean() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Bean(int dId, String dName, int dAge, double dSalary) {
		super();
		d_id = dId;
		d_name = dName;
		d_age = dAge;
		d_salary = dSalary;
	}
	@Override
	public String toString() {
		return "Bean [d_age=" + d_age + ", d_id=" + d_id + ", d_name=" + d_name
				+ ", d_salary=" + d_salary + "]";
	}
	
}

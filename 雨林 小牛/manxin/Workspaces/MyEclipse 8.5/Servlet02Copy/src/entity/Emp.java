package entity;

public class Emp {
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
	@Override
	public String toString() {
		return "Emp [d_age=" + d_age + ", d_id=" + d_id + ", d_name=" + d_name
				+ ", d_salary=" + d_salary + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + d_age;
		result = prime * result + d_id;
		result = prime * result + ((d_name == null) ? 0 : d_name.hashCode());
		long temp;
		temp = Double.doubleToLongBits(d_salary);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Emp other = (Emp) obj;
		if (d_age != other.d_age)
			return false;
		if (d_id != other.d_id)
			return false;
		if (d_name == null) {
			if (other.d_name != null)
				return false;
		} else if (!d_name.equals(other.d_name))
			return false;
		if (Double.doubleToLongBits(d_salary) != Double
				.doubleToLongBits(other.d_salary))
			return false;
		return true;
	}
	public Emp() {
		super();
	}
	public Emp(int did,String dName, int dAge, double dSalary) {
		super();
		d_id = did;
		d_name = dName;
		d_age = dAge;
		d_salary = dSalary;
	}
	
}

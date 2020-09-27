package Main;

public class Employee extends Person {

	private int age;

	public Employee(String name, int age) {
		// TODO Auto-generated constructor stub
		super(name);
		this.age=age;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	@Override
	public String toString() {
		return "Employee [age=" + age + ", getAge()=" + getAge()
				+ ", getName()=" + getName() + "]";
	}

	@Override
	public boolean ms(Person person) {
Employee e=(Employee)person;
return (this.getAge()>e.getAge());
	}

}

package Main;

public class PartyMember extends Person{

	private int age;

	public PartyMember(String name, int age) {
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
		return "PartyMember [age=" + age + ", getAge()=" + getAge()
				+ ", getName()=" + getName() + "]";
	}

	@Override
	public boolean ms(Person person) {
		PartyMember p=(PartyMember)person;
		
		return (this.getAge()>p.getAge());
	}

}

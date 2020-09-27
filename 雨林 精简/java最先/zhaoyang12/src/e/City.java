package e;

public class City {

	private String city;
	private Person person; 

	public City() {
		this("");
	}

	public City(String name) {
		super();
		this.city = name;
	}

	public Person getPerson() {
		return person;
	}

	public void setPerson(Person person) {
		this.person = person;
	}

	public String getName() {
		return city;
	}

	public void setName(String name) {
		this.city = name;
	}

	@Override
	public String toString() {
		return person.getName()+city;
	}



}

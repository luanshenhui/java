package e;

public class Person {

	private String name;
	private City city;

	public Person() {
		this("");
	}

	public Person(String name) {
		this.name = name;

	}

	public City getCity() {
		return city;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setCity(City city) {
		this.city = city;
	}

	@Override
	public String toString() {
		return city.getName() + name;
	}

}

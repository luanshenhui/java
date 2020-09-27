package cc.mm.ll;

public class Member {
	private int id;
	private String name;
	private int age;
	private Company company;

	public Member() {
		super();
	}

	public Member(int id, String name, int age, Company company) {
		super();
		this.id = id;
		this.name = name;
		this.age = age;
		this.company = company;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public Company getCompany() {
		return company;
	}

	public void setCompany(Company company) {
		this.company = company;
	}

	@Override
	public String toString() {
		return "Member [age=" + age + ", company=" + company + ", id=" + id
				+ ", name=" + name + "]";
	}

}

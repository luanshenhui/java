package xcfg;

public class Student {
	private String number;
	private char sex;
	private int age;


	public Student() {
		super();
	}

	public Student(String number, char sex, int age) {
		// TODO Auto-generated constructor stub
		this.number = number;
		this.sex = sex;
		this.age = age;
	}

	public String getNunber() {
		return number;
	}

	public void setNunber(String number) {
		this.number = number;
	}

	public char getSex() {
		return sex;
	}

	public void setSex(char sex) {
		this.sex = sex;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	@Override
	public String toString() {
		return "Student [age=" + age + ", number=" + number + ", sex=" + sex
				+ "]";
	}

}

package User;
import java.util.*;
import java.io.*;
public class User implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String userName;
	private String password;
	private String name;
	private int age;
	private char sex;

	public User() {
		super();
		// TODO Auto-generated constructor stub
	}

	public User(String userName, String password, String name, int age, char sex) {
		super();
		this.userName = userName;
		this.password = password;
		this.name = name;
		this.age = age;
		this.sex = sex;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
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

	public char getSex() {
		return sex;
	}

	public void setSex(char sex) {
		this.sex = sex;
	}

}

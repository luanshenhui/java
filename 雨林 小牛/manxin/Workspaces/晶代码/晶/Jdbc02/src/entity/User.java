package entity;
/**
 * 	实体类
 * 		a, 与表对应
 * 		b, 表有哪些字段，实体类也会有相应的属性
 * 与之对应，并且类型要匹配。
 *		c,属性要有对应的get/set方法。
 */
public class User {
	@Override
	public String toString() {
		return username + "," + pwd + "," + age;
	}
	private int id;
	private String username;
	private String pwd;
	private int age;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	
}

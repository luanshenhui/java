package entity;
/**
 * 	ʵ����
 * 		a, ����Ӧ
 * 		b, ������Щ�ֶΣ�ʵ����Ҳ������Ӧ������
 * ��֮��Ӧ����������Ҫƥ�䡣
 *		c,����Ҫ�ж�Ӧ��get/set������
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

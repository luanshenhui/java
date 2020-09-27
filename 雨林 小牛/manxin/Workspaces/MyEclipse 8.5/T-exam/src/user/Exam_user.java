package user;

public class Exam_user {
	private int id;
	private String user_id;
	private String user_pwd;
	private String user_name;
	private String user_sex;
	private int user_age;
	
	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String userName) {
		user_name = userName;
	}

	public String getUser_sex() {
		return user_sex;
	}

	public void setUser_sex(String userSex) {
		user_sex = userSex;
	}

	public int getUser_age() {
		return user_age;
	}

	public void setUser_age(int userAge) {
		user_age = userAge;
	}

	public Exam_user(String userId, String userPwd) {
		super();
		user_id = userId;
		user_pwd = userPwd;
	}
	
	public Exam_user() {
		super();
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String userId) {
		user_id = userId;
	}
	public String getUser_pwd() {
		return user_pwd;
	}
	public void setUser_pwd(String userPwd) {
		user_pwd = userPwd;
	}

	@Override
	public String toString() {
		return "exam_user [user_id=" + user_id + ", user_pwd=" + user_pwd + "]";
	}
	
}

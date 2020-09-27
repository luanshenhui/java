package user;

public class ControlShow {
	/*������ʾ����*/
	private LoginFrame login;
	private UserMenu menu;
	private Exam_user user;
	private RegistFrame regist;
	private UserService userService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public RegistFrame getRegist() {
		return regist;
	}

	public void setRegist(RegistFrame regist) {
		this.regist = regist;
	}

	public Exam_user getUser() {
		return user;
	}

	public void setUser(Exam_user user) {
		this.user = user;
	}

	public LoginFrame getLogin() {
		return login;
	}

	public void setLogin(LoginFrame login) {
		this.login = login;
	}

	public UserMenu getMenu() {
		return menu;
	}

	public void setMenu(UserMenu menu) {
		this.menu = menu;
	}

	public void showLogin(){
		//��½��ʾ
		login.setVisible(true);
		menu.setVisible(false);
		regist.setVisible(false);
	}
	
	public void showMenu(){
		//�˵���ʾ
		login.setVisible(false);
		menu.setVisible(true);
		menu.updateNameText();
	}
	
	public void showRegist(){
		//ע����ʾ
		regist.setVisible(true);
		login.setVisible(false);
	}
	
	public boolean insert(String user_id,String user_pwd,String user_name,String user_email){//
		return userService.insert(user_id, user_pwd, user_name, user_email);//
	}
}

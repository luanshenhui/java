package user;

public class ControlShow {
	/*窗口显示方法*/
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
		//登陆显示
		login.setVisible(true);
		menu.setVisible(false);
		regist.setVisible(false);
	}
	
	public void showMenu(){
		//菜单显示
		login.setVisible(false);
		menu.setVisible(true);
		menu.updateNameText();
	}
	
	public void showRegist(){
		//注册显示
		regist.setVisible(true);
		login.setVisible(false);
	}
	
	public boolean insert(String user_id,String user_pwd,String user_name,String user_email){//
		return userService.insert(user_id, user_pwd, user_name, user_email);//
	}
}

package main;

import user.*;

public class Exam_main {

	/**
	 * 组合方法
	 */
	public static void start(){
		ControlShow cs = new ControlShow();
		LoginFrame login = new LoginFrame(cs);
		UserMenu menu = new UserMenu(cs);
		RegistFrame regist = new RegistFrame(cs);
		login.setVisible(true);
		cs.setUserService(new UserService());
	}
	
	public static void main(String[] args) {
		start();
	}

}

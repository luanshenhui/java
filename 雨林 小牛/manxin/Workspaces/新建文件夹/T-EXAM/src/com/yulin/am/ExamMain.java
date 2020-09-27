package com.yulin.am;

public class ExamMain {
	public static void start() {
		Control control = new Control();
		
		LoginFrame loginFrame = new LoginFrame(control);
		RegistFrame registFrame = new RegistFrame(control);
		MenuFrame menuFrame = new MenuFrame(control);
		ExamFrame examFrame = new ExamFrame(control);
		
		control.setUs(new UserService());
		control.setQs(new QuestionService());
		control.setEs(new ExamService());
		
		loginFrame.setVisible(true);
		registFrame.setVisible(false);
		menuFrame.setVisible(false);
		examFrame.setVisible(false);
	}
	
	public static void main(String[] args) {
		start();
	}
}

package com.yulin.login;

public class ExamMain {

	public static void start() {
		Control control = new Control();
		LoginUIDemo loginFrame = new LoginUIDemo(control);
		RegistUIDemo registFrame = new RegistUIDemo(control);
		UserFrameDemo userFrame = new UserFrameDemo(control);
		loginFrame.setVisible(true);
		ExamFrame examFrame = new ExamFrame(control);

		control.setUs(new UserService());
		control.setQs(new QuestionService());
		new ExamService(control);
	}

	public static void main(String[] args) {
		start();
	}
}

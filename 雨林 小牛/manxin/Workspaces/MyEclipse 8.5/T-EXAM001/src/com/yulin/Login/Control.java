package com.yulin.Login;

public class Control {
	/**
	 * 控制层
	 */
	private LoginUIDemo loginFrame;
	private RegistUIDemo registFrame;
	private UserFrameDemo userFrame;
	private ExamFrame examFrame;
	private ExamService es;
	private QuestionService qs;
	private UserService us;
	private User u;
	public UserService getUs() {
		return us;
	}
	private Question question;	//问题类
	
	public ExamService getEs() {
		return es;
	}
	
	public void setEs(ExamService es) {
		this.es = es;
	}
	public void setExamFrame(ExamFrame examFrame) {
		this.examFrame = examFrame;
	}
	
	public User getU() {
		return u;
	}
	public QuestionService getQs() {
		return qs;
	}
	
	public void setQs(QuestionService qs) {
		this.qs = qs;
	}

	public void setU(User u) {
		this.u = u;
	}

	public Question getQuestion() {
		return question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	public void setUs(UserService us) {
		this.us = us;
	}

	public void setLoginFrame(LoginUIDemo loginFrame) {
		this.loginFrame = loginFrame;
	}
	
	public void setUserFrame(UserFrameDemo userFrame) {
		this.userFrame = userFrame;
	}

	public void setRegistFrame(RegistUIDemo registFrame) {
		this.registFrame = registFrame;
	}
	
	public void UserFrameDemo(UserFrameDemo userFrame) {
		this.userFrame = userFrame;
	}
	
	public boolean regist(String id,String pwd1,String pwd2,String name,String email){
		return us.regist(id,pwd1,pwd2,name,email);
	}
	
	/**
	 * 页面显示与隐藏
	 */
	public void showLogin(){
		loginFrame.setVisible(true);
		registFrame.setVisible(false);
	}
	public void showRegist(){
		loginFrame.setVisible(false);
		registFrame.setVisible(true);
	}
	
	public User login(String id, String pwd) {
		User u = us.login(id,pwd);
		return u;
	}
	
	public void showUserFrame(){
		userFrame.setVisible(true);
		loginFrame.setVisible(false);
		userFrame.updateNameText();
		registFrame.setVisible(false);
	}
	
	public void showExamFrame(){
		examFrame.updateName();
		examFrame.updateQuestion(0);
		examFrame.showExamFrame();
		userFrame.setVisible(false);
	}

	public void submit() {
		//交卷
		if(u.getScore() == -1){		//
			es.panjuan(qs.getQuestions());
		}
		examFrame.setVisible(false);
		userFrame.setVisible(true);
	}

	
}
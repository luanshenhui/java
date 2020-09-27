package com.yulin.am;

public class Control {
	private LoginFrame loginFrame;
	private RegistFrame registFrame;
	private MenuFrame menuFrame;
	private ExamFrame examFrame;
	
	public void setExamFrame(ExamFrame examFrame) {
		this.examFrame = examFrame;
	}

	private UserService us;
	private QuestionService qs;
	private ExamService es;
	
	/**
	 * @return the qs
	 */
	public QuestionService getQs() {
		return qs;
	}

	/**
	 * @param qs the qs to set
	 */
	public void setQs(QuestionService qs) {
		this.qs = qs;
	}

	/**
	 * @return the es
	 */
	public ExamService getEs() {
		return es;
	}

	/**
	 * @param es the es to set
	 */
	public void setEs(ExamService es) {
		this.es = es;
	}

	/**
	 * @return the us
	 */
	public UserService getUs() {
		return us;
	}

	private User u;
	
	public User getU() {
		return u;
	}

	public void setU(User u) {
		this.u = u;
	}

	public void setMenuFrame(MenuFrame menuFrame) {
		this.menuFrame = menuFrame;
	}
	
	public void setUs(UserService us) {
		this.us = us;
	}

	public void setLoginFrame(LoginFrame loginFrame) {
		this.loginFrame = loginFrame;
	}
	
	public void setRegistFrame(RegistFrame registFrame) {
		this.registFrame = registFrame;
	}
	
	public void showLogin(){
		loginFrame.setVisible(true);
		registFrame.setVisible(false);
	}
	
	public void showRegist(){
		registFrame.setVisible(true);
		loginFrame.setVisible(false);
	}

	public void showMenu(){
		loginFrame.setVisible(false);//登录页面关闭
		menuFrame.updateNameText();
		menuFrame.setVisible(true);//打开菜单页面
	}
	
	public User login(String id, String pwd) {
		User u = us.login(id, pwd);
		return u;
	}
	
	public boolean regist(String id, String pwd1, String pwd2
			,String name, String email){
		return us.regist(id, pwd1, pwd2, name, email);
	}

	public void showExamFrame() {
		// TODO Auto-generated method stub
		menuFrame.setVisible(false);
		
		
		examFrame.updateExamInfo();//gai d wenti
		//examFrame.setVisible(true);
		examFrame.showExamFrame();//页面跳转前度题
		
	}

	public void submit() {
		
		if(u.getScore()==-1){
		
		// TODO Auto-generated method stub
		es.判卷(qs.getQuestion());
		}
		examFrame.setVisible(false);
		menuFrame.setVisible(true);
	}
}

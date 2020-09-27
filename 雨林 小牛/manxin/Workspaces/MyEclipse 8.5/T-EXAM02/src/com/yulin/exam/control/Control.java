package com.yulin.exam.control;

import java.util.ArrayList;

import com.yulin.exam.bean.Question;
import com.yulin.exam.bean.User;
import com.yulin.exam.dao.QuestionDao;
import com.yulin.exam.service.AnswerService;
import com.yulin.exam.service.ExamService;
import com.yulin.exam.service.QuestionService;
import com.yulin.exam.service.UserService;
import com.yulin.exam.ui.ExamFrame;
import com.yulin.exam.ui.LoginFrame;
import com.yulin.exam.ui.MenuFrame;
import com.yulin.exam.ui.RegistFrame;

public class Control {

	private LoginFrame loginFrame;
	private User u;
	private UserService us = new UserService();
	private MenuFrame menuFrame;
	private RegistFrame registFrame;
	private ExamFrame examFrame;
	private ExamService es = new ExamService();
	private QuestionService qs = new QuestionService();
	private AnswerService as = new AnswerService();
	
	
	public AnswerService getAs() {
		return as;
	}

	public void setAs(AnswerService as) {
		this.as = as;
	}

	public ExamService getEs() {
		return es;
	}

	public void setEs(ExamService es) {
		this.es = es;
	}

	private QuestionDao question;
	private Question q;

	public QuestionService getQs() {
		return qs;
	}

	public void setQs(QuestionService qs) {
		this.qs = qs;
	}

	public void setLoginFrame(LoginFrame loginFrame) {
		this.loginFrame = loginFrame;
	}

	public User getU() {
		return u;
	}
	
	public void setU(User u) {
		this.u = u;
	}

	public boolean login(String loginId, String pwd) {
		// 登录方法
		User u = us.login(loginId,pwd);
		if(u != null){
			this.u = u;//如果登录成功，给控制层的u赋值
			return true;
		}
		return false;
	}
	
	/*注册*/
	public boolean regist(String loginId,String pwd,String pwd2,String name,String email){
		if("".equals(loginId) || "".equals(pwd) || "".equals(pwd2) || "".equals(name) || "".equals(email)){
			return false;
		}else{
			return us.regist(loginId, pwd, pwd2, name, email);
		}
	}

	public void setMenuFrame(MenuFrame menuFrame) {
		// 跳转菜单
		this.menuFrame = menuFrame;
	}
	
	// 跳转菜单
	public void loginToMenuFrame(){
		loginFrame.setVisible(false);
		menuFrame.setVisible(true);
		menuFrame.updateNameText();
	}

	public void setRegistFrame(RegistFrame registFrame) {
		// 注册页面
		this.registFrame = registFrame;
	}
	
	public void setExamFrame(ExamFrame examFrame) {
		// 试题页面
		this.examFrame = examFrame;
	}
	
	//显示注册页面
	public void loginToRegist(){
		registFrame.setVisible(true);
		loginFrame.setVisible(false);
	}
	
	//跳转回登录页面
	public void registToLogin(){
		registFrame.setVisible(false);
		loginFrame.setVisible(true);
	}
	
	//菜单退出
	public void checkExit(int i){
		if(i == 0){
			System.exit(0);
		}else if(i == 1){
			loginToMenuFrame();
		}else if(i == 2){
			loginToMenuFrame();
		}
	}
	
	//开始按钮显示试题页面
	public void menuToExam(){
		menuFrame.setVisible(false);
		examFrame.updateExamInfo();
		examFrame.showFrame();
		examFrame.setVisible(true);
	}
	
	//显示登录用户的名字
	public String UserInfo(){
		String info = getU().getName();
		return info;
	}
	
	/* 显示当前的试题  */
	public Question findQuestion(int index){
		return qs.getQuestion(index);	
	}
//	
//	public static void main(String[] args) {
//		Control c = new Control();
//		System.out.println(c.findQuestion(1));
//	}
	
	/*插入用户答案*/
	public boolean insertAnswers(String loginid){
		return as.insertAnswers(loginid);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

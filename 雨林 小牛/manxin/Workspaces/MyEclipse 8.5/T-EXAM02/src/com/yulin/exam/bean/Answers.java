package com.yulin.exam.bean;

import java.util.Arrays;

public class Answers {
	private String answer;
	private String loginid;
	
	public String getLoginid() {
		return loginid;
	}
	public void setLoginid(String loginid) {
		this.loginid = loginid;
	}
	public String getAnswer() {
		return answer;
	}
	public void setAnswer(String answer) {
		this.answer = answer;
	}
	public Answers() {
		super();
	}
	public Answers(String answer, String loginid) {
		super();
		this.loginid = loginid;
		this.answer = answer;
	}
	@Override
	public String toString() {
		return "Answers [answer=" + answer + ", loginid="
				+ loginid + "]";
	}
}

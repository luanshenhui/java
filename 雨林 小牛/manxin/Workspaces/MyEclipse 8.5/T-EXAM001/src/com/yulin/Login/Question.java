package com.yulin.Login;

import java.io.Serializable;

/**
 * ������
 */
public class Question implements Serializable{
	private static final long serialVersionUID = 1L;
	private String question;
	private String[] option;//ѡ��
	private String answer;//��ȷ��
	
	public String[] getOption() {
		return option;
	}

	public void setOption(String[] option) {
		this.option = option;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public Question() {
		super();
		// ���캯��
	}

	public String getQuestion() {
		return question;
	}
	public void setQuestion(String question) {
		this.question = question;
	}

	public Question(String question, String[] option,
			String answer) {
		super();
		this.question = question;
		this.option = option;
		this.answer = answer;
	}

	
}

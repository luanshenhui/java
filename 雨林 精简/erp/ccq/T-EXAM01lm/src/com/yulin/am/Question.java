package com.yulin.am;

public class Question {
	private String tg;
	private String[] option;
	private String answer;
	public Question() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Question(String tg, String[] option, String answer) {
		super();
		this.tg = tg;
		this.option = option;
		this.answer = answer;
	}
	/**
	 * @return the tg
	 */
	public String getTg() {
		return tg;
	}
	/**
	 * @param tg the tg to set
	 */
	public void setTg(String tg) {
		this.tg = tg;
	}
	/**
	 * @return the option
	 */
	public String[] getOption() {
		return option;
	}
	/**
	 * @param option the option to set
	 */
	public void setOption(String[] option) {
		this.option = option;
	}
	/**
	 * @return the answer
	 */
	public String getAnswer() {
		return answer;
	}
	/**
	 * @param answer the answer to set
	 */
	public void setAnswer(String answer) {
		this.answer = answer;
	}
}

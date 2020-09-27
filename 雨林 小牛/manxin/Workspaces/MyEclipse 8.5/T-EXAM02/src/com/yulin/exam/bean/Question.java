package com.yulin.exam.bean;

import java.util.Arrays;

public class Question {
	private String exam_id;
	private String exam_ti;
	private String[] exam_option;//选项
	private int score;
	private String exam_opt;//正确答案
	
	public String getExam_opt() {
		return exam_opt;
	}
	
	public String getExam_id() {
		return exam_id;
	}
	public void setExam_id(String examId) {
		exam_id = examId;
	}
	public String getExam_ti() {
		return exam_ti;
	}
	public void setExam_ti(String examTi) {
		exam_ti = examTi;
	}
	public String[] getExam_option() {
		return exam_option;
	}
	public void setExam_option(String[] examOption) {
		exam_option = examOption;
	}
	public int getScore() {
		return score;
	}
	public void setScore(int score) {
		this.score = score;
	}
	
	@Override
	public String toString() {
		return "Question [exam_id=" + exam_id + ", exam_opt=" + exam_opt
				+ ", exam_option=" + Arrays.toString(exam_option)
				+ ", exam_ti=" + exam_ti + ", score=" + score + "]";
	}
	public Question() {
		super();
	}
	public Question(String examId, String examTi, String[] examOption, int score) {
		super();
		exam_id = examId;
		exam_ti = examTi;
		exam_option = examOption;
		this.score = score;
	}
}

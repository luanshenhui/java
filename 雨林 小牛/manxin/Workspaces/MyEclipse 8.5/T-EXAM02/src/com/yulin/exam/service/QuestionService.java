package com.yulin.exam.service;

import java.util.*;

import com.yulin.exam.bean.Question;
import com.yulin.exam.dao.QuestionDao;

public class QuestionService {
	
	QuestionDao qd= new QuestionDao();
	Question question = new Question();
	int index = 0;
	
	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	/*��ʾ����*/
	ArrayList<Question> arr = new ArrayList<Question>();
	
	public QuestionService(){
		arr = qd.findQuestion();
	}
	
	/*ͨ����Ż����*/
	public Question getQuestion(int index){
		return arr.get(index);
	}
	
	/*�������*/
	public int queryCount(){
		return qd.queryCount();
	}
	
	public static void main(String[] args) {
		QuestionService qs = new QuestionService();
	}
}

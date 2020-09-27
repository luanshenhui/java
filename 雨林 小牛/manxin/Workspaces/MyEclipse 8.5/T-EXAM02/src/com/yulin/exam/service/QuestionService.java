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

	/*显示试题*/
	ArrayList<Question> arr = new ArrayList<Question>();
	
	public QuestionService(){
		arr = qd.findQuestion();
	}
	
	/*通过题号获得题*/
	public Question getQuestion(int index){
		return arr.get(index);
	}
	
	/*题的总数*/
	public int queryCount(){
		return qd.queryCount();
	}
	
	public static void main(String[] args) {
		QuestionService qs = new QuestionService();
	}
}

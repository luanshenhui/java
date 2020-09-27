package com.yulin.Login;

import java.io.*;
import java.util.*;

public class QuestionService {
	/**
	 * ����ҵ���
	 */
	
	private String pathData = "src/Question.data";
	ArrayList<Question> question = new ArrayList<Question>();
	
	
	public QuestionService() {
		createQuestions();
	}

	public void createQuestions(){
		ArrayList<String> ss = null;
		try {
			ss = FileUtil.read(pathData);
		} catch (IOException e) {
			e.printStackTrace();
		}
		for(String s : ss){
			String[] qs = s.split("#");
			question.add(new Question(qs[0],qs[1].split(","),qs[2]));
		}
	}
	
	//ͨ����Ż����
	public Question getQuestion(int index){
		return question.get(index);
	}

	public ArrayList<Question> getQuestions() {
		// ��������
		return question;
	}
}

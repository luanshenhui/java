package com.yulin.am;
import java.io.IOException;
import java.util.*;
public class QuestionService {
	ArrayList<Question> questions = 
		new ArrayList<Question>(); //�������е���
	public QuestionService(){
		createQuestions();
	}
	public void createQuestions(){//�������еĿ�����
		ArrayList<String> ss = null;
		try {
			ss = FileUtil.read("src/exam.txt");
		} catch (IOException e) {
			e.printStackTrace();
		}
		for(String s : ss){
			String[] qso = s.split("#");
			questions.add(new Question(
					qso[0], qso[1].split(","), qso[2]));
		}
	}
	//ͨ����Ż����
	public Question getQuestion(int index){
		return questions.get(index);
	}
	public ArrayList<Question> getQuestion() {
		// TODO Auto-generated method stub
		return questions;
	}
}








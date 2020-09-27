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
			String[] qs = s.split("#");
			questions.add(new Question(
					qs[0], qs[1].split(","), qs[2]));
		}
	}
	//ͨ����Ż����
	public Question getQuestion(int index){
		return questions.get(index);
	}
	
}








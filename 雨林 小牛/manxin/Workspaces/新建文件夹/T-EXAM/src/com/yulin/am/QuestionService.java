package com.yulin.am;
import java.io.IOException;
import java.util.*;
public class QuestionService {
	ArrayList<Question> questions = 
		new ArrayList<Question>(); //保存所有的题
	
	public QuestionService(){
		createQuestions();
	}
	public void createQuestions(){//读出所有的考试题
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
	//通过题号获得题
	public Question getQuestion(int index){
		return questions.get(index);
	}
	
}








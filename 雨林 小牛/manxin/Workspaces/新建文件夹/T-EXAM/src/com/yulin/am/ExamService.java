package com.yulin.am;

import java.io.IOException;
import java.util.*;

public class ExamService {
	
	private int index = 0; //���
	private ArrayList<String> useAnswers = 
		new ArrayList<String>(); //�û���

	public int getIndex() {
		return index;
	}
	
	public void setIndex(int index) {
		this.index = index;
	}
	/* �о����� */
	public int �о�(ArrayList<Question> qs){
		int score = 0;
		for(int i = 0; i < qs.size(); i++){
			if(qs.get(i).getAnswer().equals(useAnswers.get(i)))
				score += 5;
		}
		try {
			FileUtil.write("src/exam.txt", ""+score);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return score;
	}
}

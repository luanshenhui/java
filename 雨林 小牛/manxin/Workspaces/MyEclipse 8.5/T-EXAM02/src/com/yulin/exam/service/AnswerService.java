package com.yulin.exam.service;

import java.util.ArrayList;
import java.util.Arrays;

import com.yulin.exam.bean.Answers;
import com.yulin.exam.dao.AnswersDao;

public class AnswerService {
	
	private AnswersDao adao = new AnswersDao();
	private String[] ans = new String[24];
	
	public AnswersDao getAdao() {
		return adao;
	}

	public void setAdao(AnswersDao adao) {
		this.adao = adao;
	}
	
	public String[] getAns() {
		return ans;
	}

	public void setAns(int index, String an) {
		this.ans[index] = an;
	}

	/*保存用户答案*/
	public boolean insertAnswers(String loginid){
		Answers an = new Answers(Arrays.toString(ans),loginid); //[A,B,AB,D]
		return adao.insertAnswers(an);
	}

	/*查询用户答案*/
	public ArrayList<String> getAnswer(){
		ArrayList<String> arrString = null;
		ArrayList<Answers> list = adao.getAnswer();
		System.out.println(list.toArray());
		return null;
	}
	public static void main(String[] args) {
		AnswerService as = new AnswerService();
		as.getAnswer();
	}
}

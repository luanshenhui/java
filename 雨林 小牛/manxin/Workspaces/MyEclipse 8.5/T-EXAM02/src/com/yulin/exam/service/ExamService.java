package com.yulin.exam.service;

import java.util.ArrayList;
import java.util.Arrays;

import com.yulin.exam.bean.Answers;
import com.yulin.exam.bean.Question;
import com.yulin.exam.dao.AnswersDao;
import com.yulin.exam.dao.QuestionDao;

public class ExamService {
	
	private AnswersDao adao = new AnswersDao();
	
	public AnswersDao getAdao() {
		return adao;
	}

	public void setAdao(AnswersDao adao) {
		this.adao = adao;
	}

	
	
	public static void main(String[] args) {
		ExamService e = new ExamService();
//		System.out.println(e.question());
	}
}

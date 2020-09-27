package com.yulin.am;

import java.io.IOException;
import java.util.*;

public class ExamService {
	
	private int index = 0; //题号
	private ArrayList<String> useAnswers = 
		new ArrayList<String>(); //用户答案
	private Control control;
	public void setControl(Control control) {
		this.control = control;
	}

	public ExamService(Control control){//构造方法
		for(int i=0;i<20;i++){
			useAnswers.add("");
		}
		this.control=control;
		control.setEs(this);
	}

	public ArrayList<String> getUseAnswers() {
		return useAnswers;
	}

	public void setUseAnswers(ArrayList<String> useAnswers) {
		this.useAnswers = useAnswers;
	}

	public int getIndex() {
		return index;
	}
	
	public void setIndex(int index) {
		this.index = index;
	}
	/* 判卷并保存 */
	public int 判卷(ArrayList<Question> qs){
		int score = 0;
		for(int i = 0; i < qs.size(); i++){
			if(qs.get(i).getAnswer().equals(useAnswers.get(i)))
				score += 5;
		}
		try {
			String loginID=control.getU().getLoginId();
			String name=control.getU().getName();
			String uAstr="";
			for(int i=0;i<useAnswers.size();i++){
				uAstr +=useAnswers.get(i)+"**";
			}
			
			String str=loginID+"#"+name+"#"+score+"#"+uAstr;
			FileUtil.write("src/score.txt", ""+str);
			
			control.getU().setScore(score);//交完卷改变user属性
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return score;
	}
}

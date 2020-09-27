package com.yulin.Login;

import java.io.IOException;
import java.util.ArrayList;

public class ExamService {
	/**
	 * ����ҵ���
	 */
	
	private int index = 0;//���
	private ArrayList<String> useAnswers = new ArrayList<String>();//�û���
	private Control control;
	
	public ExamService(Control control){
		for(int i = 0; i < 20;i++){
			useAnswers.add("");
		}
		this.control = control;
		control.setEs(this);
	}
	
	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}
	//�о�����
	public int panjuan(ArrayList<Question> qs){
		int score = 0;
		for(int i = 0;i < qs.size(); i++){
			if(qs.get(i).getAnswer().equals(useAnswers.get(i))){
				score += 5;
			}
		}
		try {
			String loginID = control.getU().getLoginId();
			String name = control.getU().getName();
			String uAstr = "";		
			for(int i =0; i < useAnswers.size();i++){
				uAstr += useAnswers.get(i) +  " ";
			}
			control.getU().setScore(score);// �����ı�User����
			String str = loginID + "#" + name + "#" + score + "#" + uAstr; 
			FileUtil.write("src/score.data", ""+str);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return score;
	}

	public ArrayList<String> getUseAnswers() {
		return useAnswers;
	}

	public void setUseAnswers(ArrayList<String> useAnswers) {
		this.useAnswers = useAnswers;
	}
}

package com.yulin.Login;

import javax.swing.*;
import javax.swing.border.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.util.Timer;

public class ExamFrame extends JFrame{

	/**
	 * 考试页面
	 */
	private static final long serialVersionUID = 1L;
	private JTextArea area;		//文本框
	private JButton pre;	//上一题按钮
	private JButton next;	//下一题按钮
	private JButton result;		//交卷按钮
	private Control control;		//控制层
	private JLabel examInfo;		//考试信息标签
	private JLabel timer;		//记录考试时间标签
	private JLabel questionNum;		//题目标签
	
	public ExamFrame(Control control){
		this();
		this.control = control;
		control.setExamFrame(this);
//		control.showExamFrame();
	}
	
	public ExamFrame(){
		init();
	}
	
	private void init() {
		this.setTitle("雨琳科技考试系统");
		this.setSize(600,400);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.add(createContentPane());
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		addWindowListener(new WindowAdapter() {
			//窗口关闭时交卷
			@Override
			public void windowClosing(WindowEvent e){
				saveUserAnswer();//保存当前题
				control.submit();
				System.exit(0);
			}
		});
	}
	
	private JPanel createContentPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(new JLabel(new ImageIcon("src/com/yulin/am/exam_title.png"),JLabel.CENTER),BorderLayout.NORTH);
		p.add(createCenterPane(),BorderLayout.CENTER);
		p.add(createSouthPane(),BorderLayout.SOUTH);
		return p;
	}
	
	//获得考生姓名
	public void updateName(){
		examInfo.setText("考生姓名：" + control.getU().getName());
		examInfo.repaint();
	}
	
	private JPanel createCenterPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(examInfo = new JLabel("考生姓名：XXX",JLabel.CENTER),BorderLayout.NORTH);
		p.add(createQuestionPane(),BorderLayout.CENTER);
		JPanel pp = new JPanel(new BorderLayout());
		p.add(pp,BorderLayout.SOUTH);
		return p;
	}
	
	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("选择题"));
		area = new JTextArea(5,5);
		area.setText("选啥？\nA\nB");
		area.setLineWrap(true);//自动换行
		area.setEditable(false);//置顶添加
		p.getViewport().add(area);//不可编辑
		
		return p;
	}
	
	private JPanel createSouthPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.setBorder(new EmptyBorder(10,10,10,10));
		p.add(questionNum = new JLabel("第一题/共20题", JLabel.LEFT), BorderLayout.WEST);
		p.add(createButtonPane(),BorderLayout.CENTER);
		p.add(timer = new JLabel("考试时间剩余：0秒", JLabel.RIGHT), BorderLayout.EAST);
		p.add(createOptionsPane(), BorderLayout.NORTH);
		return p;
	}
	
	private JCheckBox optionA;
	private JCheckBox optionB;
	private JCheckBox optionC;
	private JCheckBox optionD;
	
	private JPanel createOptionsPane() {
		JPanel p = new JPanel();
		optionA = new JCheckBox("A");
		optionB = new JCheckBox("B");
		optionC = new JCheckBox("C");
		optionD = new JCheckBox("D");
		p.add(optionA);
		p.add(optionB);
		p.add(optionC);
		p.add(optionD);
		return p;
	}
	
	private JPanel createButtonPane() {
		JPanel p = new JPanel();
		pre = new JButton("上一题");
		//切换上一题
		pre.setEnabled(false);
		pre.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				saveUserAnswer();
				int index = control.getEs().getIndex();
//				System.out.println(index);
				index--;
				next.setEnabled(true);
				updateQuestion(index);
				control.getEs().setIndex(index);
				if(index == 0){
					pre.setEnabled(false);
				}
				getUserAnswer();
			}
		});
		next = new JButton("下一题");
		//切换下一题
		next.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				saveUserAnswer();
				int index = control.getEs().getIndex();
				index++;
//				System.out.println(index);
				control.getEs().setIndex(index);
				updateQuestion(index);
				pre.setEnabled(true);
				if(index == 19){
					next.setEnabled(false);//按钮可点
					result.setEnabled(true);
				}			
				getUserAnswer();
			}
		});
		result = new JButton("交卷");
		result.setEnabled(false);
		result.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 交卷功能
				saveUserAnswer();	//提交最后一道题
				control.submit();
			}
		});
		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}
	
	//显示页面并且读取第一道题
	public void showExamFrame(){
		updateQuestion(0);
		setVisible(true);
		//如果分数大于-1，则四个选项无法操作
		if(control.getU().getScore() > -1){
			optionA.setEnabled(false);
			optionB.setEnabled(false);
			optionC.setEnabled(false);
			optionD.setEnabled(false);
			//将用户之前的答案保存至UserAnswer集合中
			control.getEs().setUseAnswers(control.getUs().getUserAnswer(control.getU().getLoginId()));
		}
	}
	
	/**
	 * 改变当前试题
	 */
	public void updateQuestion(int index){
		Question q = control.getQs().getQuestion(index);
		String qText = q.getQuestion() 
		+ "\n A." + q.getOption()[0]
		+ "\n B." + q.getOption()[1]
	    + "\n C." + q.getOption()[2]
	    + "\n D." + q.getOption()[3];
//		System.out.println(qText);
		area.setText(qText);
	}
	
	/**
	 * 获得用户在当前题的答案
	 * 将答案显示在页面中
	 */	
	private void getUserAnswer() {
		int index = control.getEs().getIndex();
		String userAnswer = control.getEs().getUseAnswers().get(index);
		
		if(userAnswer.contains("A"))
			optionA.setSelected(true);
		else 
			optionA.setSelected(false);
		
		if(userAnswer.contains("B"))
			optionB.setSelected(true);
		else 
			optionB.setSelected(false);
		
		if(userAnswer.contains("C"))
			optionC.setSelected(true);
		else 
			optionC.setSelected(false);
		
		if(userAnswer.contains("D"))
			optionD.setSelected(true);
		else 
			optionD.setSelected(false);
	}
	
	/**
	 * 获得用户答案
	 * 保存用户答案
	 */
	private void saveUserAnswer() {
		int index = control.getEs().getIndex();
		String userAnswer = "";
		if(optionA.isSelected()){	//isSelected复选框是否被选中
			userAnswer += optionA.getText();
		}
		if(optionB.isSelected()){
			userAnswer += optionB.getText();
		}
		if(optionC.isSelected()){
			userAnswer += optionC.getText();
		}
		if(optionD.isSelected()){
			userAnswer += optionD.getText();
		}
		if(userAnswer.equals("")){//什么都没选给个默认值
			userAnswer = "X";
		}
		ArrayList<String> ua = control.getEs().getUseAnswers();
		ua.set(index, userAnswer);
		//保存用户的答案
	}

}

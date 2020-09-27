package com.yulin.am;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.*;
import java.util.ArrayList;

import javax.swing.*;
import javax.swing.border.*;

public class ExamFrame extends JFrame {
	private static final long serialVersionUID = -1L;
	private JTextArea area; // 文本框
	private JButton pre; // 上一题按钮
	private JButton next; // 下一题按钮
	private JButton result; // 交卷按钮
	private Control control; // 控制层
	private JLabel examInfo; // 考试信息标签
	private JLabel timer; // 记录考试时间标签
	private JLabel questionNum; // 题木标签

	public ExamFrame(Control control) {
		this();
		this.control = control;
		control.setExamFrame(this);
	}

	public ExamFrame() {
		init();
	}

	private void init() {
		this.setTitle("雨琳科技考试系统");
		this.setSize(600, 400);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.add(createContentPane());
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);// 设置关闭什么也不干
		addWindowListener(new WindowAdapter() {
			/* 关闭交卷 */
			@Override
			public void windowClosing(WindowEvent e) {
				
			}
			

		});
	}

	private JPanel createContentPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(new JLabel(new ImageIcon("src/com/yulin/am/exam_title.png"),
				JLabel.CENTER), BorderLayout.NORTH);
		p.add(createCenterPane(), BorderLayout.CENTER);
		p.add(createSouthPane(), BorderLayout.SOUTH);
		return p;
	}

	private JPanel createCenterPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(examInfo = new JLabel("考生姓名：XXX", JLabel.CENTER),
				BorderLayout.NORTH);
		p.add(createQuestionPane(), BorderLayout.CENTER);
		return p;
	}

	public void updateExamInfo() {// 进界面后更新考生姓名。显示页面前面调用该方法
		examInfo.setText("考生；" + control.getU().getName());
		examInfo.repaint();
	}

	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("选择题"));// 添加一个带标题的边框
		area = new JTextArea(5, 5); // 初始大小为5行，5列
		area.setText("选啥？\nA\nB");
		area.setLineWrap(true); // 自动换行
		area.setEditable(false); // 不可编辑
		p.getViewport().add(area); // 置顶添加
		return p;
	}

	private JPanel createSouthPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.setBorder(new EmptyBorder(10, 10, 10, 10));
		p.add(questionNum = new JLabel("第1题/共20题", JLabel.LEFT),
				BorderLayout.WEST);
		p.add(createButtonPanel(), BorderLayout.CENTER);
		p.add(timer = new JLabel("考试剩余时间:0秒", JLabel.RIGHT), BorderLayout.EAST);
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

	private JPanel createButtonPanel() {
		JPanel p = new JPanel();

		//		
		// int index=control.getEs().getIndex();
		// if(index==0){
		// pre.setEnabled(false);
		//			
		// }else if(index==19){
		// next.setEnabled(false);
		// }

		pre = new JButton("上一题");
		pre.setEnabled(false);
		// TODO 02 切换上一题
		pre.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {

				saveUserAnswer();

				int index = control.getEs().getIndex();

				// sys index, ti hao
				// if(index == 0){//如果是题号为1，则不能再点上一题
				// pre.setEnabled(false);//按钮不可点
				// }else{//切换到上一题
				// next.setEnabled(true);
				// control.getEs().setIndex(--index);
				// updateQuestion(index);
				index--;
				next.setEnabled(true);
				updateQuestion(index);
				control.getEs().setIndex(index);
				if (index == 0)
					pre.setEnabled(false);

				getUserAnswer();

			}

		});
		next = new JButton("下一题");

		// TODO 03 切换下一题
		next.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {

				saveUserAnswer(); // 保存显示做的题

				int index = control.getEs().getIndex();
				// if(index == 19){//如果是题号为20，则不能再点下一题
				// next.setEnabled(false);
				//					
				// getUserAnswer();
				//					
				//					
				// }else{//切换到下一题
				// pre.setEnabled(true); //按钮可点
				// control.getEs().setIndex(++index);
				// updateQuestion(index);
				// }
				index++;
				control.getEs().setIndex(index);
				updateQuestion(index);
				pre.setEnabled(true);
				if (index == 19){
					next.setEnabled(false);

				result.setEnabled(true);//---
			}
				getUserAnswer();
			}
		});

		result = new JButton("交卷");
		
		result.setEnabled(false);//默认为false//---
		
		result.addActionListener(new ActionListener() {
			
			

			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				saveUserAnswer();// bug交不了最后一题，因次再写一遍交第20题
				control.submit();
			}
		});
		
		
		
		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}

	protected void getUserAnswer() {
		// TODO Auto-generated method stub
		/**
		 * 获得用户在当前题的答案 将答案显示在页面中
		 */
		int index = control.getEs().getIndex();
		String userAnswer = control.getEs().getUseAnswers().get(index);
		if (userAnswer.contains("A"))
			optionA.setSelected(true);
		else
			optionA.setSelected(false);
		if (userAnswer.contains("B"))
			optionB.setSelected(true);
		else
			optionB.setSelected(false);
		if (userAnswer.contains("C"))
			optionC.setSelected(true);
		else
			optionC.setSelected(false);
		if (userAnswer.contains("D"))
			optionD.setSelected(true);
		else
			optionD.setSelected(false);
	}

	protected void saveUserAnswer() {
		// TODO Auto-generated method stub
		/**
		 * 获得用户答案 保存用户答案
		 */
		int index = control.getEs().getIndex();
		String userAnswer = "";
		if (optionA.isSelected()) { // 判断复选框A是否被选中
			userAnswer += optionA.getText();
		}
		if (optionB.isSelected()) {
			userAnswer += optionB.getText();
		}
		if (optionC.isSelected()) {
			userAnswer += optionC.getText();
		}
		if (optionD.isSelected()) {
			userAnswer += optionD.getText();
		}
if(userAnswer.equals("")){
	userAnswer="x";//啥都不选取个默认值
}
		ArrayList<String> ua = control.getEs().getUseAnswers();

		// 保存用户的答案
		ua.set(index, userAnswer);
	}

	// TODO 01
	/* 改变当前显示的试题 */
	private void updateQuestion(int index) {
		Question q = control.getQs().getQuestion(index);
		String qText = q.getTg() + "\n A." + q.getOption()[0] + "\n B."
				+ q.getOption()[1] + "\n C." + q.getOption()[2] + "\n D."
				+ q.getOption()[3];
		area.setText(qText);
	}

	public void showExamFrame() { // 显示页面并且读取第一道题。
		updateQuestion(0);
		setVisible(true);
		if(control.getU().getScore()>-1){//如果分数大于-1，则无法操作
			optionA.setEnabled(false);
			optionB.setEnabled(false);
			optionC.setEnabled(false);
			optionD.setEnabled(false);
			control.getEs().setUseAnswers(control.getUs().getUserAnswers(
					control.getU().getLoginId()));//如果答完题，将答案保存useranwser集合中
		}
	}

	// public static void main(String[] args){
	// Control c = new Control();
	// QuestionService qs = new QuestionService();
	// ExamService es = new ExamService();
	// c.setEs(es);
	// c.setQs(qs);
	// ExamFrame ef = new ExamFrame(c);
	// ef.showExamFrame();
	// }
}

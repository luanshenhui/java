package com.yulin.am;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;
import javax.swing.border.*;

public class ExamFrame extends JFrame {
	private static final long serialVersionUID = -1L;
	private JTextArea area; //文本框
	private JButton pre; //上一题按钮
	private JButton next; //下一题按钮
	private JButton result; //交卷按钮
	private Control control; //控制层
	private JLabel examInfo; //考试信息标签
	private JLabel timer; //记录考试时间标签
	private JLabel questionNum; //题木标签
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
	}

	private JPanel createContentPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(new JLabel(new ImageIcon(
			"src/com/yulin/am/exam_title.png")
				, JLabel.CENTER), BorderLayout.NORTH);
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
	public void updateExamInfo(){//更新考生姓名时，显示页面之前调用该方法
		examInfo.setText("考生姓名:"+control.getU().getName());
		examInfo.repaint();
	}
	

	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("选择题"));//添加一个带标题的边框
		area = new JTextArea(5, 5); //初始大小为5行，5列
		area.setText("选啥？\nA\nB");
		area.setLineWrap(true); //自动换行
		area.setEditable(false); //不可编辑
		p.getViewport().add(area); //置顶添加 
		return p;
	}

	private JPanel createSouthPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.setBorder(new EmptyBorder(10, 10, 10, 10));
		p.add(questionNum = new JLabel("第1题/共20题", JLabel.LEFT),
				BorderLayout.WEST);
		p.add(createButtonPanel(), BorderLayout.CENTER);
		p.add(timer = new JLabel("考试剩余时间:0秒", JLabel.RIGHT)
			, BorderLayout.EAST);
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
		pre = new JButton("上一题");
		//TODO 02 切换上一题
		/*
		 * 按钮不可点的判断
		 */
		
			pre.setEnabled(false);
		
		pre.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				int index = control.getEs().getIndex();
				System.out.println(index);
				index--;
				next.setEnabled(true);
				updateQuestion(index);
				control.getEs().setIndex(index);
				if(index==0)
					pre.setEnabled(false);
			}
		});
		next = new JButton("下一题");
		
		//TODO 03 切换下一题
		next.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				saveUserAnswer();
				int index = control.getEs().getIndex();
				index++;
				System.out.println(index);
				control.getEs().setIndex(index);
				updateQuestion(index);
				if(index == 19)//如果是题号为20，则不能再点下一题
					next.setEnabled(false);
					getUserAnswer();
				
			}
		});
		
		result = new JButton("交卷");
		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}

	//TODO 01
	/* 改变当前显示的试题  */
	private void updateQuestion(int index){
		Question q = control.getQs().getQuestion(index);
		String qText = q.getTg()
			+"\n A."+q.getOption()[0]
			+"\n B."+q.getOption()[1]
			+"\n C."+q.getOption()[2]
			+"\n D."+q.getOption()[3];
		area.setText(qText);
	}
	
	public void showExamFrame(){ //显示页面并且读取第一道题。
		updateQuestion(1);
		setVisible(true);
	}
	
	public static void main(String[] args){
		Control c = new Control();
		QuestionService qs = new QuestionService();
		ExamService es = new ExamService();
		c.setEs(es);
		c.setQs(qs);
		ExamFrame ef = new ExamFrame(c);
		ef.showExamFrame();
	}
	private void getUserAnswer() {//获得用户在当前题的答案
		// TODO Auto-generated method stub
		
	}
	private void saveUserAnswer() {
		/*
		 * 获得用户答案
		 * 保存用户答案
		 */
		
	}
}

package com.yulin.exam.ui;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;
import javax.swing.border.*;

import com.yulin.exam.bean.Question;
import com.yulin.exam.control.Control;

public class ExamFrame extends JFrame {
	private static final long serialVersionUID = -1L;
	private JTextArea area; //文本框
	private JButton pre; //上一题按钮
	private JButton next; //下一题按钮
	private JButton result; //交卷按钮
	private Control control = new Control(); //控制层
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
//		showFrame();
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
		examInfo.setText("考生姓名:"+control.UserInfo());
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

	public void updateQuestion(int index){//试题
		Question question = control.findQuestion(index);
//		String id = question.getExam_id()
//		System.out.println(question.getExam_option().length);
		String que = question.getExam_id() + question.getExam_ti()
		+ "\n A." + question.getExam_option()[0]
		+ "\n B." + question.getExam_option()[1]
		+ "\n C." + question.getExam_option()[2]
		+ "\n D." + question.getExam_option()[3];
		area.setText(que);
//		area.repaint();
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
		pre.setEnabled(false);
		pre.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 上一题
				int index = control.getQs().getIndex();
//				System.out.println(index);
				index--;
				next.setEnabled(true);
				updateQuestion(index);
				control.getQs().setIndex(index);
				if(index == 0){
					pre.setEnabled(false);
				}
				pre.setEnabled(true);
//				getAnswer();
			}
		});
		
		next = new JButton("下一题");
		next.addActionListener(new ActionListener() {
			int maxIndex = control.getQs().queryCount();
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 下一题
				pre.setEnabled(true);
				int index = control.getQs().getIndex();
				index++;
//				System.out.println("index"+index);
//				System.out.println("mmm"+maxIndex);
				control.getQs().setIndex(index);
				updateQuestion(index);
				if(index == maxIndex-1){//index从0开始
					next.setEnabled(false);
				}
//				getAnswer();
			}
		});
		result = new JButton("交卷");
		result.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 交卷
				int index = control.getQs().getIndex();
				saveAnswers();
			}
		});
		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}
	
	public void showFrame(){
		updateQuestion(0);
		setVisible(true);
	}
	
	/*获得用户选项*/
	private void saveAnswers(){
		int index = control.getQs().getIndex();
		String answer = "";
		if(optionA.isSelected()){
			answer += optionA.getText();
		}
		if(optionB.isSelected()){
			answer += optionB.getText();
		}
		if(optionC.isSelected()){
			answer += optionC.getText();
		}
		if(optionD.isSelected()){
			answer += optionD.getText();
		}
		if(answer.equals("")){
			answer += "X";
		}	
		control.getAs().setAns(index, answer);
		control.getAs().insertAnswers(control.getU().getLoginId());
	}
	
	/*获得用户当前答案*/
//	public void getAnswer(){
//		int index = control.getQs().getIndex();
//		String answer = control.getAnswer();
//		if(answer.contains("A")){
//			optionA.setSelected(true);
//		}else{
//			optionA.setSelected(false);
//		}
//		if(answer.contains("B")){
//			optionB.setSelected(true);
//		}else{
//			optionB.setSelected(false);
//		}
//		if(answer.contains("C")){
//			optionC.setSelected(true);
//		}else{
//			optionC.setSelected(false);
//		}
//		if(answer.contains("D")){
//			optionD.setSelected(true);
//		}else{
//			optionD.setSelected(false);
//		}
//	}
	
	public static void main(String[] args) {
		ExamFrame ef = new ExamFrame();
		ef.updateQuestion(0);
		ef.show();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

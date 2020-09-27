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
	private JTextArea area; //�ı���
	private JButton pre; //��һ�ⰴť
	private JButton next; //��һ�ⰴť
	private JButton result; //����ť
	private Control control = new Control(); //���Ʋ�
	private JLabel examInfo; //������Ϣ��ǩ
	private JLabel timer; //��¼����ʱ���ǩ
	private JLabel questionNum; //��ľ��ǩ
	public ExamFrame(Control control) {
		this();
		this.control = control;
		control.setExamFrame(this);
	}
	public ExamFrame() {
		init();
	}
	private void init() {
		this.setTitle("���տƼ�����ϵͳ");
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
		p.add(examInfo = new JLabel("����������XXX", JLabel.CENTER),
				BorderLayout.NORTH);
		p.add(createQuestionPane(), BorderLayout.CENTER);
		return p;
	}
	public void updateExamInfo(){//���¿�������ʱ����ʾҳ��֮ǰ���ø÷���
		examInfo.setText("��������:"+control.UserInfo());
		examInfo.repaint();
	}
	

	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("ѡ����"));//���һ��������ı߿�
		area = new JTextArea(5, 5); //��ʼ��СΪ5�У�5��
		area.setText("ѡɶ��\nA\nB");
		area.setLineWrap(true); //�Զ�����
		area.setEditable(false); //���ɱ༭
		p.getViewport().add(area); //�ö���� 
		return p;
	}

	public void updateQuestion(int index){//����
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
		p.add(questionNum = new JLabel("��1��/��20��", JLabel.LEFT),
				BorderLayout.WEST);
		p.add(createButtonPanel(), BorderLayout.CENTER);
		p.add(timer = new JLabel("����ʣ��ʱ��:0��", JLabel.RIGHT)
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
		pre = new JButton("��һ��");		
		pre.setEnabled(false);
		pre.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ��һ��
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
		
		next = new JButton("��һ��");
		next.addActionListener(new ActionListener() {
			int maxIndex = control.getQs().queryCount();
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ��һ��
				pre.setEnabled(true);
				int index = control.getQs().getIndex();
				index++;
//				System.out.println("index"+index);
//				System.out.println("mmm"+maxIndex);
				control.getQs().setIndex(index);
				updateQuestion(index);
				if(index == maxIndex-1){//index��0��ʼ
					next.setEnabled(false);
				}
//				getAnswer();
			}
		});
		result = new JButton("����");
		result.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ����
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
	
	/*����û�ѡ��*/
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
	
	/*����û���ǰ��*/
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

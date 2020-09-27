package com.yulin.Login;

import javax.swing.*;
import javax.swing.border.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.util.Timer;

public class ExamFrame extends JFrame{

	/**
	 * ����ҳ��
	 */
	private static final long serialVersionUID = 1L;
	private JTextArea area;		//�ı���
	private JButton pre;	//��һ�ⰴť
	private JButton next;	//��һ�ⰴť
	private JButton result;		//����ť
	private Control control;		//���Ʋ�
	private JLabel examInfo;		//������Ϣ��ǩ
	private JLabel timer;		//��¼����ʱ���ǩ
	private JLabel questionNum;		//��Ŀ��ǩ
	
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
		this.setTitle("���տƼ�����ϵͳ");
		this.setSize(600,400);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.add(createContentPane());
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		addWindowListener(new WindowAdapter() {
			//���ڹر�ʱ����
			@Override
			public void windowClosing(WindowEvent e){
				saveUserAnswer();//���浱ǰ��
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
	
	//��ÿ�������
	public void updateName(){
		examInfo.setText("����������" + control.getU().getName());
		examInfo.repaint();
	}
	
	private JPanel createCenterPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(examInfo = new JLabel("����������XXX",JLabel.CENTER),BorderLayout.NORTH);
		p.add(createQuestionPane(),BorderLayout.CENTER);
		JPanel pp = new JPanel(new BorderLayout());
		p.add(pp,BorderLayout.SOUTH);
		return p;
	}
	
	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("ѡ����"));
		area = new JTextArea(5,5);
		area.setText("ѡɶ��\nA\nB");
		area.setLineWrap(true);//�Զ�����
		area.setEditable(false);//�ö����
		p.getViewport().add(area);//���ɱ༭
		
		return p;
	}
	
	private JPanel createSouthPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.setBorder(new EmptyBorder(10,10,10,10));
		p.add(questionNum = new JLabel("��һ��/��20��", JLabel.LEFT), BorderLayout.WEST);
		p.add(createButtonPane(),BorderLayout.CENTER);
		p.add(timer = new JLabel("����ʱ��ʣ�ࣺ0��", JLabel.RIGHT), BorderLayout.EAST);
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
		pre = new JButton("��һ��");
		//�л���һ��
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
		next = new JButton("��һ��");
		//�л���һ��
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
					next.setEnabled(false);//��ť�ɵ�
					result.setEnabled(true);
				}			
				getUserAnswer();
			}
		});
		result = new JButton("����");
		result.setEnabled(false);
		result.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ������
				saveUserAnswer();	//�ύ���һ����
				control.submit();
			}
		});
		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}
	
	//��ʾҳ�沢�Ҷ�ȡ��һ����
	public void showExamFrame(){
		updateQuestion(0);
		setVisible(true);
		//�����������-1�����ĸ�ѡ���޷�����
		if(control.getU().getScore() > -1){
			optionA.setEnabled(false);
			optionB.setEnabled(false);
			optionC.setEnabled(false);
			optionD.setEnabled(false);
			//���û�֮ǰ�Ĵ𰸱�����UserAnswer������
			control.getEs().setUseAnswers(control.getUs().getUserAnswer(control.getU().getLoginId()));
		}
	}
	
	/**
	 * �ı䵱ǰ����
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
	 * ����û��ڵ�ǰ��Ĵ�
	 * ������ʾ��ҳ����
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
	 * ����û���
	 * �����û���
	 */
	private void saveUserAnswer() {
		int index = control.getEs().getIndex();
		String userAnswer = "";
		if(optionA.isSelected()){	//isSelected��ѡ���Ƿ�ѡ��
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
		if(userAnswer.equals("")){//ʲô��ûѡ����Ĭ��ֵ
			userAnswer = "X";
		}
		ArrayList<String> ua = control.getEs().getUseAnswers();
		ua.set(index, userAnswer);
		//�����û��Ĵ�
	}

}

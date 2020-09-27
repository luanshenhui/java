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
	private JTextArea area; // �ı���
	private JButton pre; // ��һ�ⰴť
	private JButton next; // ��һ�ⰴť
	private JButton result; // ����ť
	private Control control; // ���Ʋ�
	private JLabel examInfo; // ������Ϣ��ǩ
	private JLabel timer; // ��¼����ʱ���ǩ
	private JLabel questionNum; // ��ľ��ǩ

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
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);// ���ùر�ʲôҲ����
		addWindowListener(new WindowAdapter() {
			/* �رս��� */
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
		p.add(examInfo = new JLabel("����������XXX", JLabel.CENTER),
				BorderLayout.NORTH);
		p.add(createQuestionPane(), BorderLayout.CENTER);
		return p;
	}

	public void updateExamInfo() {// ���������¿�����������ʾҳ��ǰ����ø÷���
		examInfo.setText("������" + control.getU().getName());
		examInfo.repaint();
	}

	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("ѡ����"));// ���һ��������ı߿�
		area = new JTextArea(5, 5); // ��ʼ��СΪ5�У�5��
		area.setText("ѡɶ��\nA\nB");
		area.setLineWrap(true); // �Զ�����
		area.setEditable(false); // ���ɱ༭
		p.getViewport().add(area); // �ö����
		return p;
	}

	private JPanel createSouthPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.setBorder(new EmptyBorder(10, 10, 10, 10));
		p.add(questionNum = new JLabel("��1��/��20��", JLabel.LEFT),
				BorderLayout.WEST);
		p.add(createButtonPanel(), BorderLayout.CENTER);
		p.add(timer = new JLabel("����ʣ��ʱ��:0��", JLabel.RIGHT), BorderLayout.EAST);
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

		pre = new JButton("��һ��");
		pre.setEnabled(false);
		// TODO 02 �л���һ��
		pre.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {

				saveUserAnswer();

				int index = control.getEs().getIndex();

				// sys index, ti hao
				// if(index == 0){//��������Ϊ1�������ٵ���һ��
				// pre.setEnabled(false);//��ť���ɵ�
				// }else{//�л�����һ��
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
		next = new JButton("��һ��");

		// TODO 03 �л���һ��
		next.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {

				saveUserAnswer(); // ������ʾ������

				int index = control.getEs().getIndex();
				// if(index == 19){//��������Ϊ20�������ٵ���һ��
				// next.setEnabled(false);
				//					
				// getUserAnswer();
				//					
				//					
				// }else{//�л�����һ��
				// pre.setEnabled(true); //��ť�ɵ�
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

		result = new JButton("����");
		
		result.setEnabled(false);//Ĭ��Ϊfalse//---
		
		result.addActionListener(new ActionListener() {
			
			

			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				saveUserAnswer();// bug���������һ�⣬�����дһ�齻��20��
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
		 * ����û��ڵ�ǰ��Ĵ� ������ʾ��ҳ����
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
		 * ����û��� �����û���
		 */
		int index = control.getEs().getIndex();
		String userAnswer = "";
		if (optionA.isSelected()) { // �жϸ�ѡ��A�Ƿ�ѡ��
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
	userAnswer="x";//ɶ����ѡȡ��Ĭ��ֵ
}
		ArrayList<String> ua = control.getEs().getUseAnswers();

		// �����û��Ĵ�
		ua.set(index, userAnswer);
	}

	// TODO 01
	/* �ı䵱ǰ��ʾ������ */
	private void updateQuestion(int index) {
		Question q = control.getQs().getQuestion(index);
		String qText = q.getTg() + "\n A." + q.getOption()[0] + "\n B."
				+ q.getOption()[1] + "\n C." + q.getOption()[2] + "\n D."
				+ q.getOption()[3];
		area.setText(qText);
	}

	public void showExamFrame() { // ��ʾҳ�沢�Ҷ�ȡ��һ���⡣
		updateQuestion(0);
		setVisible(true);
		if(control.getU().getScore()>-1){//�����������-1�����޷�����
			optionA.setEnabled(false);
			optionB.setEnabled(false);
			optionC.setEnabled(false);
			optionD.setEnabled(false);
			control.getEs().setUseAnswers(control.getUs().getUserAnswers(
					control.getU().getLoginId()));//��������⣬���𰸱���useranwser������
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

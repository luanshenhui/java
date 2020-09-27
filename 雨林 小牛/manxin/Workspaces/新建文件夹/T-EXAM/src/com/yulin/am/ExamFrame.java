package com.yulin.am;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;
import javax.swing.border.*;

public class ExamFrame extends JFrame {
	private static final long serialVersionUID = -1L;
	private JTextArea area; //�ı���
	private JButton pre; //��һ�ⰴť
	private JButton next; //��һ�ⰴť
	private JButton result; //����ť
	private Control control; //���Ʋ�
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
		examInfo.setText("��������:"+control.getU().getName());
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
		//TODO 02 �л���һ��
		/*
		 * ��ť���ɵ���ж�
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
		next = new JButton("��һ��");
		
		//TODO 03 �л���һ��
		next.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				saveUserAnswer();
				int index = control.getEs().getIndex();
				index++;
				System.out.println(index);
				control.getEs().setIndex(index);
				updateQuestion(index);
				if(index == 19)//��������Ϊ20�������ٵ���һ��
					next.setEnabled(false);
					getUserAnswer();
				
			}
		});
		
		result = new JButton("����");
		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}

	//TODO 01
	/* �ı䵱ǰ��ʾ������  */
	private void updateQuestion(int index){
		Question q = control.getQs().getQuestion(index);
		String qText = q.getTg()
			+"\n A."+q.getOption()[0]
			+"\n B."+q.getOption()[1]
			+"\n C."+q.getOption()[2]
			+"\n D."+q.getOption()[3];
		area.setText(qText);
	}
	
	public void showExamFrame(){ //��ʾҳ�沢�Ҷ�ȡ��һ���⡣
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
	private void getUserAnswer() {//����û��ڵ�ǰ��Ĵ�
		// TODO Auto-generated method stub
		
	}
	private void saveUserAnswer() {
		/*
		 * ����û���
		 * �����û���
		 */
		
	}
}

package com.yulin.Login;

import javax.swing.*;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class UserFrameDemo extends JFrame{
	/**
	 * ��¼���ҳ��
	 */
	
	private Control control;
	
	public UserFrameDemo(Control control){
		init();
		this.control = control;
		control.setUserFrame(this);
	}

	private void init() {
		//ҳ������
		setSize(500, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocation(400, 300);
		setResizable(false);	//��С�޷����ı�
		showFrame();
	}

	private void showFrame() {
		// ��ʾҳ��
		JPanel context = new JPanel(new BorderLayout(350,80));
		JPanel northPanel = createNorthPanel();
		JPanel conterPanel = createConterPanel();
		JPanel southPanel = createSouthPanel();
		context.add(northPanel, BorderLayout.NORTH);
		context.add(conterPanel, BorderLayout.CENTER);
		context.add(southPanel, BorderLayout.SOUTH);
		add(context);
	}
	private JLabel nameText;
	private JPanel createNorthPanel() {
		//����棬JLabelͼƬ
		JPanel panel = new JPanel(new BorderLayout());
		JLabel label1 = new JLabel(new ImageIcon("src/img/3.png"),JLabel.LEFT);
		JLabel label2 = new JLabel(new ImageIcon("src/img/3.png"),JLabel.RIGHT);
		JLabel textLabel = new JLabel("��ӭ���ٿ���ϵͳ",JLabel.CENTER);
		textLabel.setFont(new Font("����",Font.BOLD,25));
		nameText = new JLabel("",JLabel.CENTER);
		panel.add(label1,BorderLayout.WEST);
		panel.add(label2,BorderLayout.EAST);
		panel.add(textLabel,BorderLayout.CENTER);
		panel.add(nameText,BorderLayout.SOUTH);
		return panel;
	}
	
	public void updateNameText(){
		nameText.setText(control.getU().getName());
		nameText.repaint();
	}

	private JButton btn1;
	private JButton btn2;
	private JButton btn3;
	private JButton btn4;
	private JPanel createConterPanel() {
		//�м���壬ͼƬ��ť
		JPanel panel = new JPanel();
		
		btn1 = createImageButton("��ʼ","1.png");
		btn1.addActionListener(new ActionListener() {			
			@Override
			public void actionPerformed(ActionEvent e) {
				//��ʼ��ť
				control.showExamFrame();
			}
		});
		btn2 = createImageButton("����","4.png");
		btn2.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// �鿴����
				int score = control.getU().getScore();
				JOptionPane.showMessageDialog(null, "���ĵ÷��ǣ�" + score);
			}
		});
		btn3 = createImageButton("����","5.png");
		
		btn4 = createImageButton("�뿪","6.png");
		btn4.addActionListener(new ActionListener() {		
			@Override
			public void actionPerformed(ActionEvent e) {
				// �뿪��ť
				int i = JOptionPane.showConfirmDialog(null, "ȷ���˳���");
	//			System.out.println(i);//�ǣ�0����1��ȡ����2
				chenckExit(i);
			}
		});
		
		panel.add(btn1);
		panel.add(btn2);
		panel.add(btn3);
		panel.add(btn4);
		
		return panel;
	}

	private JButton createImageButton(String text, String image) {
		// ����ͼƬ��ť�ķ���
		JButton btn = new JButton(text,new ImageIcon("src/img/" + image));
		btn.setHorizontalTextPosition(JButton.CENTER);
		btn.setVerticalTextPosition(JButton.BOTTOM);
		return btn;
	}

	private JPanel createSouthPanel() {
		//����� LaboyͼƬ
		JPanel panel = new JPanel(new BorderLayout());
		JLabel label = new JLabel("��Ȩ����  ��ð�ؾ�",JLabel.RIGHT);
		panel.add(label);
		return panel;
	}
	

	private void chenckExit(int i) {
		// �뿪��ť
		if(i == 0){
			System.exit(0);
		}else if(i == 1){
			control.showUserFrame();
		}else if(i == 2){
			control.showUserFrame();
		}
	}
	
}

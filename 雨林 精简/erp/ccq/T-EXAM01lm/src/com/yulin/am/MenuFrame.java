package com.yulin.am;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.border.EmptyBorder;

public class MenuFrame extends JFrame {

	private JButton start;
	private JButton result;
	private JButton rule;
	private JButton exit;
	
	private Control control;
	
	public MenuFrame(Control control) {
		init();
		this.control = control;
		control.setMenuFrame(this);//将自身对象注入到control中
	}

	private void init() {
		this.setTitle("雨林科技学员考试系统");
		this.setSize(600, 400);
		this.add(createContentPane());
		
		this.setLocationRelativeTo(null);//窗口居中
		
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setResizable(false);
	}

	private JPanel createContentPane() {
		JPanel p = new JPanel(new BorderLayout(0, 8));
		p.setBorder(new EmptyBorder(12, 12, 12, 12));
		p.add(new JLabel(
				new ImageIcon(this.getClass().getResource("title.png")),
				JLabel.CENTER), BorderLayout.NORTH);
		p.add(createCenterPane(), BorderLayout.CENTER);
		p.add(new JLabel("版权所有，假冒必究", JLabel.RIGHT), BorderLayout.SOUTH);
		return p;
	}
	private JLabel nameText;
	private JPanel createCenterPane() {
		nameText = new JLabel("欢迎XXX登录考试系统", JLabel.CENTER);
		JPanel p = new JPanel(new BorderLayout());
		p.add(nameText,	BorderLayout.NORTH);
		p.add(createButtonPane(), BorderLayout.CENTER);
		return p;
	}
	public void updateNameText(){
		nameText.setText(
				"欢迎"+control.getU().getName()+"登录考试系统");
		nameText.repaint();
	}

	private JPanel createButtonPane() {
		JPanel p = new JPanel();
		start = createImageButton("开始", "exam.png");
		start.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				
					//开始按钮
					control.showExamFrame();
				
			}
		});
		
		
		
		result = createImageButton("分数", "result.png");
		
		result.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// TODO Auto-generated method stub
				int score=control.getU().getScore();
				
				JOptionPane.showMessageDialog(null,score);
			}
		});
		
		
		rule = createImageButton("规则", "message.png");
		exit = createImageButton("退出", "exit.png");
		p.add(start);
		p.add(result);
		p.add(rule);
		p.add(exit);
		return p;
	}

	private JButton createImageButton(String text, String image) {
		JButton b = new JButton(text
				, new ImageIcon("src/com/yulin/am/"+image));
		b.setHorizontalTextPosition(JButton.CENTER);
		b.setVerticalTextPosition(JButton.BOTTOM);
		return b;
	}
	
}

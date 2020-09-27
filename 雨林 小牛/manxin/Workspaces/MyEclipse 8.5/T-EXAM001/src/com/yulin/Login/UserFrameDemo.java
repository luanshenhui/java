package com.yulin.Login;

import javax.swing.*;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class UserFrameDemo extends JFrame{
	/**
	 * 登录后的页面
	 */
	
	private Control control;
	
	public UserFrameDemo(Control control){
		init();
		this.control = control;
		control.setUserFrame(this);
	}

	private void init() {
		//页面设置
		setSize(500, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocation(400, 300);
		setResizable(false);	//大小无法被改变
		showFrame();
	}

	private void showFrame() {
		// 显示页面
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
		//北面版，JLabel图片
		JPanel panel = new JPanel(new BorderLayout());
		JLabel label1 = new JLabel(new ImageIcon("src/img/3.png"),JLabel.LEFT);
		JLabel label2 = new JLabel(new ImageIcon("src/img/3.png"),JLabel.RIGHT);
		JLabel textLabel = new JLabel("欢迎光临考试系统",JLabel.CENTER);
		textLabel.setFont(new Font("宋体",Font.BOLD,25));
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
		//中间面板，图片按钮
		JPanel panel = new JPanel();
		
		btn1 = createImageButton("开始","1.png");
		btn1.addActionListener(new ActionListener() {			
			@Override
			public void actionPerformed(ActionEvent e) {
				//开始按钮
				control.showExamFrame();
			}
		});
		btn2 = createImageButton("分数","4.png");
		btn2.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 查看分数
				int score = control.getU().getScore();
				JOptionPane.showMessageDialog(null, "您的得分是：" + score);
			}
		});
		btn3 = createImageButton("规则","5.png");
		
		btn4 = createImageButton("离开","6.png");
		btn4.addActionListener(new ActionListener() {		
			@Override
			public void actionPerformed(ActionEvent e) {
				// 离开按钮
				int i = JOptionPane.showConfirmDialog(null, "确定退出？");
	//			System.out.println(i);//是：0，否：1，取消：2
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
		// 创建图片按钮的方法
		JButton btn = new JButton(text,new ImageIcon("src/img/" + image));
		btn.setHorizontalTextPosition(JButton.CENTER);
		btn.setVerticalTextPosition(JButton.BOTTOM);
		return btn;
	}

	private JPanel createSouthPanel() {
		//南面版 Laboy图片
		JPanel panel = new JPanel(new BorderLayout());
		JLabel label = new JLabel("版权所有  假冒必究",JLabel.RIGHT);
		panel.add(label);
		return panel;
	}
	

	private void chenckExit(int i) {
		// 离开按钮
		if(i == 0){
			System.exit(0);
		}else if(i == 1){
			control.showUserFrame();
		}else if(i == 2){
			control.showUserFrame();
		}
	}
	
}

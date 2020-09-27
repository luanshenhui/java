package com.yulin.Login;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

import javax.swing.*;

public class LoginUIDemo extends JFrame{

	/**
	 * 登录页面
	 */
	Control control;
	
	public LoginUIDemo(Control control){
		init();
		this.control = control;
		control.setLoginFrame(this);//将自身的对象注入至Control
	}
	
	public void init(){
		setSize(400, 300);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);	//大小无法被改变
		setLocation(400, 300);//改变页面显示的初始位置
		showFrame();
	}
	
	public void showFrame(){
		JPanel context = new JPanel(new BorderLayout(20,30));
		JPanel northPanel = createNorthPanel();
		JPanel centerPanel = createCenterPanel();
		JPanel southPanel = createSouthPanel();
		context.add(northPanel,BorderLayout.NORTH);	 //北面板
		context.add(centerPanel,BorderLayout.CENTER);	//中间面板
		context.add(southPanel,BorderLayout.SOUTH);	 //南面板
		add(context);	//将panel放入Frame中
	}
	
	private JPanel createNorthPanel() {
		// 北面板
		JPanel panel = new JPanel(new BorderLayout(0,20));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("登  录");
		text.setFont(new Font("宋体",Font.BOLD,20));	//更改字体
		textPanel.add(text);
		panel.add(new JLabel(" "),BorderLayout.NORTH);
		panel.add(textPanel,BorderLayout.CENTER);
		return panel;
	}

	private JPanel createCenterPanel() {
		// 中间面板
		JPanel panel = new JPanel(new BorderLayout());
		panel.add(caeateIDPanel(),BorderLayout.NORTH);	//用户名面板
		panel.add(createPWDPanel(),BorderLayout.SOUTH);	//密码面板
		return panel;
	}

	private JTextField idText;
	private JPanel caeateIDPanel() {
		// 用户名面板
		JPanel panel = new JPanel();
		JLabel text = new JLabel("账号：");
		idText = new JTextField();
		idText.setColumns(20);	//宽度为20个字符
		panel.add(text);
		panel.add(idText);
		return panel;
	}

	private JPasswordField pwdText;
	private JPanel createPWDPanel() {
		// 密码面板
		JPanel panel = new JPanel();
		JLabel text = new JLabel("密码：");
		pwdText = new JPasswordField();
		pwdText.setColumns(20);	//宽度为20个字符
		panel.add(text);
		panel.add(pwdText);
		return panel;
	}

	private JPanel createSouthPanel() {
		// 南面板
		JPanel jp = new JPanel(new BorderLayout(0,10));
		JPanel panel = new JPanel();
		JButton btnLogin = new JButton("登录");
		btnLogin.addActionListener(new ActionListener() {	
			@Override
			public void actionPerformed(ActionEvent e) {
				//按钮监听器，单击按钮后会执行
				String id = idText.getText();
				String pwd = pwdText.getText();
				User u = control.login(id,pwd);
				if(u == null){
					//窗口抖动
					for(int i = 0;i < 20; i++){
						Random rd = new Random();
						int x = rd.nextInt(1024);
						int y = rd.nextInt(768);
						setLocation(x,y);
						try {
							Thread.sleep(50);
						} catch (InterruptedException e1) {
							e1.printStackTrace();
						}
					}
					JOptionPane.showMessageDialog(null, "用户名或密码错误");
				}else{
					control.setU(u);	//将User对象放入控制层
					control.showUserFrame();
				}
			}
		});
		JButton btnRegist = new JButton("注册");
		btnRegist.addActionListener(new ActionListener() {
			//注册，跳转页面
			@Override
			public void actionPerformed(ActionEvent e) {
				control.showRegist();
			}
		});
		panel.add(btnLogin);
		panel.add(new JLabel(" "));//调整两个按钮间的距离
		panel.add(new JLabel(" "));
		panel.add(new JLabel(" "));
		panel.add(btnRegist);
		jp.add(panel,BorderLayout.CENTER);
		jp.add(new JLabel(" "),BorderLayout.SOUTH);
		return jp;
	}
	
}

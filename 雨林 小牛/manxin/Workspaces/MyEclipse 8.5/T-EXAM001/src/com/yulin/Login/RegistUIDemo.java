package com.yulin.Login;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.ArrayList;

import javax.swing.*;

public class RegistUIDemo extends JFrame{

	/**
	 * 注册页面
	 */
	Control control;
	
	public RegistUIDemo(Control control) {
		init();
		this.control = control;
		control.setRegistFrame(this);//注入
	}
	
	private void init() {
		setSize(500, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);	//大小无法被改变
		setLocation(400, 300);
		showFrame();
	}
	
	public void showFrame(){
		JPanel context = new JPanel(new BorderLayout(80, 50));
		JPanel northPanel = createNorthPanel();	//北面板
		JPanel southPanel = createSouthPanel();//南面板
		context.add(northPanel,BorderLayout.NORTH);
		context.add(southPanel,BorderLayout.SOUTH);
		context.add(new JLabel(" "), BorderLayout.EAST);
		context.add(new JLabel(" "), BorderLayout.WEST);
		context.add(createCenterPanel());//中间面板
		add(context);
	}

	private JPanel createNorthPanel() {
		// 北面板
		JPanel panel = new JPanel(new BorderLayout(0,30));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("注   册");
		text.setFont(new Font("宋体", Font.BOLD,20));
		textPanel.add(text);
		panel.add(new JLabel(" "),BorderLayout.NORTH);
		panel.add(textPanel,BorderLayout.CENTER);
		return panel;
	}
	
	private JTextField idText;
	private JPasswordField pwdText;
	private JPasswordField pwdsText;
	private JTextField nameText;
	private JTextField emailText;
	private JPanel createCenterPanel() {
		// 中间面板
		GridLayout gl = new GridLayout(5,2);
		JPanel panel = new JPanel(gl);		
		panel.add(new JLabel("输入账号："));
		idText = new JTextField();
		idText.setColumns(20);
		panel.add(idText);
		panel.add(new JLabel("输入密码："));
		pwdText = new JPasswordField();
		pwdText.setColumns(20);
		panel.add(pwdText);
		panel.add(new JLabel("确认密码："));
		pwdsText = new JPasswordField();
		pwdsText.setColumns(20);
		panel.add(pwdsText);
		panel.add(new JLabel("真实姓名："));
		nameText = new JTextField();
		nameText.setColumns(20);
		panel.add(nameText);
		panel.add(new JLabel("电子邮箱："));
		emailText = new JTextField();
		emailText.setColumns(20);
		panel.add(emailText);
		return panel;
	}

	private String userDataPath = "src/User.data";
	private JPanel createSouthPanel() {
		// 南面板
		JPanel jPanel = new JPanel(new BorderLayout(0,20));
		JPanel panel = new JPanel();
		JButton btnRegist = new JButton("注册");
		btnRegist.addActionListener(new ActionListener() {
			//注册
			@Override
			public void actionPerformed(ActionEvent e) {
				String id = idText.getText();
				String pwd1 = pwdText.getText();
				String pwd2 = pwdsText.getText();
				String name = nameText.getText();
				String email = emailText.getText();
				if(control.regist(id, pwd1, pwd2, name, email)){
					JOptionPane.showMessageDialog(null, "注册成功！");
					control.showLogin();
				}else{
					JOptionPane.showMessageDialog(null, "注册信息不合法！");
				}
			}
		});
		JButton btnTurn = new JButton("返回");
		btnTurn.addActionListener(new ActionListener() {
			//返回页面跳转
			@Override
			public void actionPerformed(ActionEvent e) {
				control.showLogin();
			}
		});
		panel.add(btnRegist);
		panel.add(new JLabel("  "));
		panel.add(new JLabel("  "));
		panel.add(new JLabel("  "));
		panel.add(btnTurn);
		jPanel.add(panel,BorderLayout.CENTER);
		jPanel.add(new JLabel("  "),BorderLayout.SOUTH);
		return jPanel;
	}
}

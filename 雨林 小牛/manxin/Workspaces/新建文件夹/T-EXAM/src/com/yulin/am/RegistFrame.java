package com.yulin.am;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.*;

public class RegistFrame extends JFrame {
	Control control;
	
	public RegistFrame(Control control){
		init();
		this.control = control;
		control.setRegistFrame(this); //注入
	}

	private void init() {
		setSize(300, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);
		setLocation(500, 200);
		add(createContextPanel());
	}

	private JPanel createContextPanel() {
		JPanel contextPanel = new JPanel(new BorderLayout(0, 30));
		contextPanel.add(createNorthPanel(), BorderLayout.NORTH);
		contextPanel.add(createCenterPanel(), BorderLayout.CENTER);
		contextPanel.add(createSouthPanel(), BorderLayout.SOUTH);
		return contextPanel;
	}

	private Component createNorthPanel() {
		JPanel panel = new JPanel(new BorderLayout());
		panel.add(new JLabel(" "), BorderLayout.NORTH);
		JPanel jp = new JPanel();
		JLabel jl = new JLabel("注  册");
		jl.setFont(new Font("宋体", Font.BOLD, 21));
		jp.add(jl);
		panel.add(jp, BorderLayout.CENTER);
		return panel;
	}

	private JTextField idText = new JTextField();
	private JPasswordField pwdText = new JPasswordField();
	private JPasswordField pwd2Text = new JPasswordField();
	private JTextField nameText = new JTextField();
	private JTextField emailText = new JTextField();
	
	private Component createCenterPanel() {
		JPanel panel = new JPanel(new BorderLayout());
		JPanel center = new JPanel(new GridLayout(5, 1));
		JPanel idPanel = new JPanel();
		idPanel.add(new JLabel("请输入账号:"));
		idText.setColumns(15);
		idPanel.add(idText);
		center.add(idPanel);
		
		JPanel pwdPanel = new JPanel();
		pwdPanel.add(new JLabel("请输入密码:"));
		pwdText.setColumns(15);
		pwdPanel.add(pwdText);
		center.add(pwdPanel);
		
		JPanel pwd2Panel = new JPanel();
		pwd2Panel.add(new JLabel("请确认密码:"));
		pwd2Text.setColumns(15);
		pwd2Panel.add(pwd2Text);
		center.add(pwd2Panel);
		
		JPanel namePanel = new JPanel();
		namePanel.add(new JLabel("请输入姓名:"));
		nameText.setColumns(15);
		namePanel.add(nameText);
		center.add(namePanel);
		
		JPanel emailPanel = new JPanel();
		emailPanel.add(new JLabel("请输入邮箱:"));
		emailText.setColumns(15);
		emailPanel.add(emailText);
		center.add(emailPanel);
		panel.add(center, BorderLayout.CENTER);
		return panel;
	}

	private Component createSouthPanel() {
		JPanel panel = new JPanel(new BorderLayout(0, 20));
		JPanel center = new JPanel();
		JButton btnReg = new JButton("注册");
		JButton btnBack = new JButton("返回");
		
		btnReg.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				String id = idText.getText();
				String pwd1 = pwdText.getText();
				String pwd2 = pwd2Text.getText();
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
		
		btnBack.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				control.showLogin();
			}
		});
		center.add(btnReg);
		center.add(btnBack);
		panel.add(center, BorderLayout.CENTER);
		panel.add(new JLabel(" "), BorderLayout.SOUTH);
		return panel;
	}
}

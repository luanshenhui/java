package com.yulin.am;

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

import javax.swing.*;

public class LoginFrame extends JFrame{
	Control control;
	
	public LoginFrame(Control control){
		init();
		this.control = control;
		control.setLoginFrame(this); //将自身的对象注入值Control
	}
	
	private void init(){
		setSize(400, 300);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false); //大小无法被改变
		setLocation(450, 200);//改变页面显示的初始位置。
		showFrame();
	}
	
	public void showFrame(){
		JPanel context = new JPanel(new BorderLayout(20, 40));
		JPanel northPanel = createNorthPanel(); //北面板
		JPanel centerPanel = createCenterPanel(); //中间面板
		JPanel southPanel = createSouthPanel(); //南面板
		context.add(northPanel, BorderLayout.NORTH); 
		context.add(centerPanel, BorderLayout.CENTER);
		context.add(southPanel, BorderLayout.SOUTH);
		add(context); //将panel放入Frame中
	}

	private JPanel createNorthPanel() {
		JPanel panel = new JPanel(new BorderLayout(0, 10));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("登  录");
		text.setFont(new Font("宋体", Font.BOLD, 21)); //更改字体
		textPanel.add(text);
		panel.add(new JLabel(" "), BorderLayout.NORTH);
		panel.add(textPanel, BorderLayout.CENTER);
		return panel;
	}

	private JPanel createCenterPanel() {
		JPanel panel = new JPanel(new BorderLayout());
		panel.add(createIDPanel(), BorderLayout.NORTH);//ID面板
		panel.add(createPWDPanle(), BorderLayout.SOUTH);//密码面板
		return panel;
	}
	
	private JTextField idText; //全局变量
	private JPanel createIDPanel() {
		JPanel panel = new JPanel();
		JLabel text = new JLabel("账号:");
		idText = new JTextField();
		idText.setColumns(20); //宽度为20个字符
		panel.add(text);
		panel.add(idText);
		return panel;
	}
	private JPasswordField pwdText; //全局变量，密码框
	private JPanel createPWDPanle() {
		JPanel panel = new JPanel();
		JLabel text = new JLabel("密码:");
		pwdText = new JPasswordField();
		pwdText.setColumns(20); //宽度为20个字符
		panel.add(text);
		panel.add(pwdText);
		return panel;
	}

	private JPanel createSouthPanel() {
		JPanel jp = new JPanel(new BorderLayout(0, 10));
		JPanel panel = new JPanel();
		JButton btnLogin = new JButton("登录");
		btnLogin.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
			//该方法在单击按钮后会执行。	
				String id = idText.getText();
				String pwd = pwdText.getText();
				User u = control.login(id, pwd);
				if(u == null){
					for(int i = 0; i < 100; i++){
						Random rd = new Random();
						int x = rd.nextInt(1024);
						int y = rd.nextInt(768);
						setLocation(x, y);
						try {
							Thread.sleep(10);
						} catch (InterruptedException e1) {
							e1.printStackTrace();
						}
					}
					JOptionPane.showMessageDialog(null, "用户名或密码错误！");
					
				}else{
					System.out.println("登录成功！");
					control.setU(u); //将User对象放入控制层
					control.showMenu(); //显示菜单页面
				}
			}
		});
		
		JButton btnRegist = new JButton("注册");
		
		btnRegist.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				control.showRegist();
			}
		});
		
		panel.add(btnLogin);
		panel.add(new JLabel("     "));
		panel.add(new JLabel("     ")); //调整两个按钮间的距离
		panel.add(new JLabel("     "));
		panel.add(btnRegist);
		jp.add(panel, BorderLayout.CENTER);
		jp.add(new JLabel(" "), BorderLayout.SOUTH);
		return jp;
	}
	/**
	 * @param id 用户名
	 * @param pwd 密码
	 * @return 当用户通过id和密码登录成功之后，会返回一个User对象
	 * 			此对象包含登录用户的所有信息
	 */
	
	
}










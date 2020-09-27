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
	 * ��¼ҳ��
	 */
	Control control;
	
	public LoginUIDemo(Control control){
		init();
		this.control = control;
		control.setLoginFrame(this);//������Ķ���ע����Control
	}
	
	public void init(){
		setSize(400, 300);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);	//��С�޷����ı�
		setLocation(400, 300);//�ı�ҳ����ʾ�ĳ�ʼλ��
		showFrame();
	}
	
	public void showFrame(){
		JPanel context = new JPanel(new BorderLayout(20,30));
		JPanel northPanel = createNorthPanel();
		JPanel centerPanel = createCenterPanel();
		JPanel southPanel = createSouthPanel();
		context.add(northPanel,BorderLayout.NORTH);	 //�����
		context.add(centerPanel,BorderLayout.CENTER);	//�м����
		context.add(southPanel,BorderLayout.SOUTH);	 //�����
		add(context);	//��panel����Frame��
	}
	
	private JPanel createNorthPanel() {
		// �����
		JPanel panel = new JPanel(new BorderLayout(0,20));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("��  ¼");
		text.setFont(new Font("����",Font.BOLD,20));	//��������
		textPanel.add(text);
		panel.add(new JLabel(" "),BorderLayout.NORTH);
		panel.add(textPanel,BorderLayout.CENTER);
		return panel;
	}

	private JPanel createCenterPanel() {
		// �м����
		JPanel panel = new JPanel(new BorderLayout());
		panel.add(caeateIDPanel(),BorderLayout.NORTH);	//�û������
		panel.add(createPWDPanel(),BorderLayout.SOUTH);	//�������
		return panel;
	}

	private JTextField idText;
	private JPanel caeateIDPanel() {
		// �û������
		JPanel panel = new JPanel();
		JLabel text = new JLabel("�˺ţ�");
		idText = new JTextField();
		idText.setColumns(20);	//���Ϊ20���ַ�
		panel.add(text);
		panel.add(idText);
		return panel;
	}

	private JPasswordField pwdText;
	private JPanel createPWDPanel() {
		// �������
		JPanel panel = new JPanel();
		JLabel text = new JLabel("���룺");
		pwdText = new JPasswordField();
		pwdText.setColumns(20);	//���Ϊ20���ַ�
		panel.add(text);
		panel.add(pwdText);
		return panel;
	}

	private JPanel createSouthPanel() {
		// �����
		JPanel jp = new JPanel(new BorderLayout(0,10));
		JPanel panel = new JPanel();
		JButton btnLogin = new JButton("��¼");
		btnLogin.addActionListener(new ActionListener() {	
			@Override
			public void actionPerformed(ActionEvent e) {
				//��ť��������������ť���ִ��
				String id = idText.getText();
				String pwd = pwdText.getText();
				User u = control.login(id,pwd);
				if(u == null){
					//���ڶ���
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
					JOptionPane.showMessageDialog(null, "�û������������");
				}else{
					control.setU(u);	//��User���������Ʋ�
					control.showUserFrame();
				}
			}
		});
		JButton btnRegist = new JButton("ע��");
		btnRegist.addActionListener(new ActionListener() {
			//ע�ᣬ��תҳ��
			@Override
			public void actionPerformed(ActionEvent e) {
				control.showRegist();
			}
		});
		panel.add(btnLogin);
		panel.add(new JLabel(" "));//����������ť��ľ���
		panel.add(new JLabel(" "));
		panel.add(new JLabel(" "));
		panel.add(btnRegist);
		jp.add(panel,BorderLayout.CENTER);
		jp.add(new JLabel(" "),BorderLayout.SOUTH);
		return jp;
	}
	
}

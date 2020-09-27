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
		control.setLoginFrame(this); //������Ķ���ע��ֵControl
	}
	
	private void init(){
		setSize(400, 300);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false); //��С�޷����ı�
		setLocation(450, 200);//�ı�ҳ����ʾ�ĳ�ʼλ�á�
		showFrame();
	}
	
	public void showFrame(){
		JPanel context = new JPanel(new BorderLayout(20, 40));
		JPanel northPanel = createNorthPanel(); //�����
		JPanel centerPanel = createCenterPanel(); //�м����
		JPanel southPanel = createSouthPanel(); //�����
		context.add(northPanel, BorderLayout.NORTH); 
		context.add(centerPanel, BorderLayout.CENTER);
		context.add(southPanel, BorderLayout.SOUTH);
		add(context); //��panel����Frame��
	}

	private JPanel createNorthPanel() {
		JPanel panel = new JPanel(new BorderLayout(0, 10));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("��  ¼");
		text.setFont(new Font("����", Font.BOLD, 21)); //��������
		textPanel.add(text);
		panel.add(new JLabel(" "), BorderLayout.NORTH);
		panel.add(textPanel, BorderLayout.CENTER);
		return panel;
	}

	private JPanel createCenterPanel() {
		JPanel panel = new JPanel(new BorderLayout());
		panel.add(createIDPanel(), BorderLayout.NORTH);//ID���
		panel.add(createPWDPanle(), BorderLayout.SOUTH);//�������
		return panel;
	}
	
	private JTextField idText; //ȫ�ֱ���
	private JPanel createIDPanel() {
		JPanel panel = new JPanel();
		JLabel text = new JLabel("�˺�:");
		idText = new JTextField();
		idText.setColumns(20); //���Ϊ20���ַ�
		panel.add(text);
		panel.add(idText);
		return panel;
	}
	private JPasswordField pwdText; //ȫ�ֱ����������
	private JPanel createPWDPanle() {
		JPanel panel = new JPanel();
		JLabel text = new JLabel("����:");
		pwdText = new JPasswordField();
		pwdText.setColumns(20); //���Ϊ20���ַ�
		panel.add(text);
		panel.add(pwdText);
		return panel;
	}

	private JPanel createSouthPanel() {
		JPanel jp = new JPanel(new BorderLayout(0, 10));
		JPanel panel = new JPanel();
		JButton btnLogin = new JButton("��¼");
		btnLogin.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
			//�÷����ڵ�����ť���ִ�С�	
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
					JOptionPane.showMessageDialog(null, "�û������������");
					
				}else{
					System.out.println("��¼�ɹ���");
					control.setU(u); //��User���������Ʋ�
					control.showMenu(); //��ʾ�˵�ҳ��
				}
			}
		});
		
		JButton btnRegist = new JButton("ע��");
		
		btnRegist.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				control.showRegist();
			}
		});
		
		panel.add(btnLogin);
		panel.add(new JLabel("     "));
		panel.add(new JLabel("     ")); //����������ť��ľ���
		panel.add(new JLabel("     "));
		panel.add(btnRegist);
		jp.add(panel, BorderLayout.CENTER);
		jp.add(new JLabel(" "), BorderLayout.SOUTH);
		return jp;
	}
	/**
	 * @param id �û���
	 * @param pwd ����
	 * @return ���û�ͨ��id�������¼�ɹ�֮�󣬻᷵��һ��User����
	 * 			�˶��������¼�û���������Ϣ
	 */
	
	
}










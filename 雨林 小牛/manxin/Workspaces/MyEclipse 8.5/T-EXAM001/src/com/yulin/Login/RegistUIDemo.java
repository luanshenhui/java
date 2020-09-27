package com.yulin.Login;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.ArrayList;

import javax.swing.*;

public class RegistUIDemo extends JFrame{

	/**
	 * ע��ҳ��
	 */
	Control control;
	
	public RegistUIDemo(Control control) {
		init();
		this.control = control;
		control.setRegistFrame(this);//ע��
	}
	
	private void init() {
		setSize(500, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);	//��С�޷����ı�
		setLocation(400, 300);
		showFrame();
	}
	
	public void showFrame(){
		JPanel context = new JPanel(new BorderLayout(80, 50));
		JPanel northPanel = createNorthPanel();	//�����
		JPanel southPanel = createSouthPanel();//�����
		context.add(northPanel,BorderLayout.NORTH);
		context.add(southPanel,BorderLayout.SOUTH);
		context.add(new JLabel(" "), BorderLayout.EAST);
		context.add(new JLabel(" "), BorderLayout.WEST);
		context.add(createCenterPanel());//�м����
		add(context);
	}

	private JPanel createNorthPanel() {
		// �����
		JPanel panel = new JPanel(new BorderLayout(0,30));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("ע   ��");
		text.setFont(new Font("����", Font.BOLD,20));
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
		// �м����
		GridLayout gl = new GridLayout(5,2);
		JPanel panel = new JPanel(gl);		
		panel.add(new JLabel("�����˺ţ�"));
		idText = new JTextField();
		idText.setColumns(20);
		panel.add(idText);
		panel.add(new JLabel("�������룺"));
		pwdText = new JPasswordField();
		pwdText.setColumns(20);
		panel.add(pwdText);
		panel.add(new JLabel("ȷ�����룺"));
		pwdsText = new JPasswordField();
		pwdsText.setColumns(20);
		panel.add(pwdsText);
		panel.add(new JLabel("��ʵ������"));
		nameText = new JTextField();
		nameText.setColumns(20);
		panel.add(nameText);
		panel.add(new JLabel("�������䣺"));
		emailText = new JTextField();
		emailText.setColumns(20);
		panel.add(emailText);
		return panel;
	}

	private String userDataPath = "src/User.data";
	private JPanel createSouthPanel() {
		// �����
		JPanel jPanel = new JPanel(new BorderLayout(0,20));
		JPanel panel = new JPanel();
		JButton btnRegist = new JButton("ע��");
		btnRegist.addActionListener(new ActionListener() {
			//ע��
			@Override
			public void actionPerformed(ActionEvent e) {
				String id = idText.getText();
				String pwd1 = pwdText.getText();
				String pwd2 = pwdsText.getText();
				String name = nameText.getText();
				String email = emailText.getText();
				if(control.regist(id, pwd1, pwd2, name, email)){
					JOptionPane.showMessageDialog(null, "ע��ɹ���");
					control.showLogin();
				}else{
					JOptionPane.showMessageDialog(null, "ע����Ϣ���Ϸ���");
				}
			}
		});
		JButton btnTurn = new JButton("����");
		btnTurn.addActionListener(new ActionListener() {
			//����ҳ����ת
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

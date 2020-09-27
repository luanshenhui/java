package com.yulin.manager.ui;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;

import com.yulin.manager.control.Control;

public class AddFrame extends JFrame{

Control control;
	
	public AddFrame(Control control){
		init();
		this.control = control;
		control.setAf(this); //ע��
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
		JLabel jl = new JLabel("�� ��");
		jl.setFont(new Font("����", Font.BOLD, 21));
		jp.add(jl);
		panel.add(jp, BorderLayout.CENTER);
		return panel;
	}

	private JTextField idText = new JTextField();
	private JTextField clsText = new JTextField();
	private JTextField nameText = new JTextField();
	private JTextField timeText = new JTextField();
	
	private Component createCenterPanel() {
		JPanel panel = new JPanel(new BorderLayout());
		JPanel center = new JPanel(new GridLayout(4, 1));
		JPanel idPanel = new JPanel();
		idPanel.add(new JLabel("��������Ʒ���:"));
		idText.setColumns(15);
		idPanel.add(idText);
		center.add(idPanel);
		
		JPanel clsPanel = new JPanel();
		clsPanel.add(new JLabel("��������Ʒ����:"));
		clsText.setColumns(15);
		clsPanel.add(clsText);
		center.add(clsPanel);
		
		JPanel namePanel = new JPanel();
		namePanel.add(new JLabel("��������Ʒ����:"));
		nameText.setColumns(15);
		namePanel.add(nameText);
		center.add(namePanel);
		
		JPanel timePanel = new JPanel();
		timePanel.add(new JLabel("���������ʱ��:"));
		timeText.setColumns(15);
		timePanel.add(timeText);
		center.add(timePanel);
		
		panel.add(center, BorderLayout.CENTER);
		return panel;
	}

	private Component createSouthPanel() {
		JPanel panel = new JPanel(new BorderLayout(0, 20));
		JPanel center = new JPanel();
		JButton btnReg = new JButton("���");
		btnReg.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ���
				int id = Integer.parseInt(idText.getText());
				String cls = clsText.getText();
				String name = nameText.getText();
				String time = timeText.getText();
				if(control.insert(id, cls, name, time)){
					JOptionPane.showMessageDialog(null, "��ӳɹ���");
					control.addFrameToMyFrame();
				}else{
					JOptionPane.showMessageDialog(null, "���ʧ�ܣ�");
				}
			}
		});
		JButton btnBack = new JButton("����");
		btnBack.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ����
				control.addFrameToMyFrame();
			}
		});

		center.add(btnReg);
		center.add(btnBack);
		panel.add(center, BorderLayout.CENTER);
		panel.add(new JLabel(" "), BorderLayout.SOUTH);
		return panel;
	}

}

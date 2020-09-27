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
		control.setAf(this); //注入
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
		JLabel jl = new JLabel("添 加");
		jl.setFont(new Font("宋体", Font.BOLD, 21));
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
		idPanel.add(new JLabel("请输入商品编号:"));
		idText.setColumns(15);
		idPanel.add(idText);
		center.add(idPanel);
		
		JPanel clsPanel = new JPanel();
		clsPanel.add(new JLabel("请输入商品种类:"));
		clsText.setColumns(15);
		clsPanel.add(clsText);
		center.add(clsPanel);
		
		JPanel namePanel = new JPanel();
		namePanel.add(new JLabel("请输入商品名称:"));
		nameText.setColumns(15);
		namePanel.add(nameText);
		center.add(namePanel);
		
		JPanel timePanel = new JPanel();
		timePanel.add(new JLabel("请输入入库时间:"));
		timeText.setColumns(15);
		timePanel.add(timeText);
		center.add(timePanel);
		
		panel.add(center, BorderLayout.CENTER);
		return panel;
	}

	private Component createSouthPanel() {
		JPanel panel = new JPanel(new BorderLayout(0, 20));
		JPanel center = new JPanel();
		JButton btnReg = new JButton("添加");
		btnReg.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 添加
				int id = Integer.parseInt(idText.getText());
				String cls = clsText.getText();
				String name = nameText.getText();
				String time = timeText.getText();
				if(control.insert(id, cls, name, time)){
					JOptionPane.showMessageDialog(null, "添加成功！");
					control.addFrameToMyFrame();
				}else{
					JOptionPane.showMessageDialog(null, "添加失败！");
				}
			}
		});
		JButton btnBack = new JButton("返回");
		btnBack.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 返回
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

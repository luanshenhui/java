package com.yulin.am;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class MyFrame extends JFrame{
	/**
	 * 分页查询：
	 * 两种分页策略：
	 * 一、基于查询的分页
	 * 	每一页需要显示的信息都需要查询一次数据库，利用SQL语句帮我们完成分页
	 * 	对数据库和服务器的压力比较大，但是对缓存/内存的压力比较小
	 * 	
	 * 二、基于缓存的分页
	 * 	一次性查询出所有的数据，放入缓存/内存中
	 *	 第一次运行比较慢，对数据库和服务器的压力比较小
	 * 	对缓存/内存的压力比较大
	 */
	public MyFrame(){
		init();
	}

	private void init() {
		setSize(400, 600);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocationRelativeTo(null);
		add(createContent());
	}
	
	private JPanel createContent() {
		JPanel panel = new JPanel(new BorderLayout(10, 10));
		JLabel label = new JLabel("物资管理系统", JLabel.CENTER);
		label.setFont(new Font("黑体", Font.BOLD, 40));
		panel.add(label, BorderLayout.NORTH);
		panel.add(createCenterPanel(), BorderLayout.CENTER);
		panel.add(createSouthPanel(), BorderLayout.SOUTH);
		return panel;
	}

	private Component createSouthPanel() {
		JPanel panel = new JPanel();
		JButton pre = new JButton("上一页");
		JButton next = new JButton("下一页");
		JButton add = new JButton("添加");
		JLabel pages = new JLabel("第1页/共X页");
		panel.add(pages);
		panel.add(pre);
		panel.add(next);
		panel.add(add);
		return panel;
	}

	private Component createCenterPanel() {
		GridLayout layout = new GridLayout(11, 5);
		JPanel panel = new JPanel(layout);
		panel.add(new JLabel("编号", JLabel.CENTER));
		panel.add(new JLabel("分类辑", JLabel.CENTER));
		panel.add(new JLabel("名称辑", JLabel.CENTER));
		panel.add(new JLabel("入库时间", JLabel.CENTER));
		panel.add(new JLabel("操作", JLabel.CENTER));
		for(int i = 1; i <= 10; i++){
			createContextPanel(panel,""+i);
		}
		return panel;
	}
	
	private Component createContextPanel(JPanel panel, String str) {
		final JTextField num = createText(str); //编号
		final JTextField cls = createText(str); //分类
		final JTextField name = createText(str); //名称
		final JTextField date = createText(str); //时间
		
		final JButton btn = new JButton("编辑");
		btn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				if(btn.getText().equals("编辑")){
					btn.setText("保存");
					num.setEditable(true);
					cls.setEditable(true);
					name.setEditable(true);
					date.setEditable(true);
				}else{
					btn.setText("编辑");
					num.setEditable(false);
					cls.setEditable(false);
					name.setEditable(false);
					date.setEditable(false);
				}
			}
		});
		
		panel.add(num);
		panel.add(cls);
		panel.add(name);
		panel.add(date);
		panel.add(btn);
		return panel;
	}

	private JTextField createText(String str) {
		JTextField text = new JTextField(str);
		text.setEditable(false);
		text.setText(str);
		text.setHorizontalAlignment(JTextField.CENTER);
		return text;
	}

	public static void main(String[] args) {
		MyFrame mf = new MyFrame();
		mf.setVisible(true);
	}
}

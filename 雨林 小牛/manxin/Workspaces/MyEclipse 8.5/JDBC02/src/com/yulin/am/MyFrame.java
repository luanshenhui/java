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
	 * ��ҳ��ѯ��
	 * ���ַ�ҳ���ԣ�
	 * һ�����ڲ�ѯ�ķ�ҳ
	 * 	ÿһҳ��Ҫ��ʾ����Ϣ����Ҫ��ѯһ�����ݿ⣬����SQL����������ɷ�ҳ
	 * 	�����ݿ�ͷ�������ѹ���Ƚϴ󣬵��ǶԻ���/�ڴ��ѹ���Ƚ�С
	 * 	
	 * �������ڻ���ķ�ҳ
	 * 	һ���Բ�ѯ�����е����ݣ����뻺��/�ڴ���
	 *	 ��һ�����бȽ����������ݿ�ͷ�������ѹ���Ƚ�С
	 * 	�Ի���/�ڴ��ѹ���Ƚϴ�
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
		JLabel label = new JLabel("���ʹ���ϵͳ", JLabel.CENTER);
		label.setFont(new Font("����", Font.BOLD, 40));
		panel.add(label, BorderLayout.NORTH);
		panel.add(createCenterPanel(), BorderLayout.CENTER);
		panel.add(createSouthPanel(), BorderLayout.SOUTH);
		return panel;
	}

	private Component createSouthPanel() {
		JPanel panel = new JPanel();
		JButton pre = new JButton("��һҳ");
		JButton next = new JButton("��һҳ");
		JButton add = new JButton("���");
		JLabel pages = new JLabel("��1ҳ/��Xҳ");
		panel.add(pages);
		panel.add(pre);
		panel.add(next);
		panel.add(add);
		return panel;
	}

	private Component createCenterPanel() {
		GridLayout layout = new GridLayout(11, 5);
		JPanel panel = new JPanel(layout);
		panel.add(new JLabel("���", JLabel.CENTER));
		panel.add(new JLabel("���༭", JLabel.CENTER));
		panel.add(new JLabel("���Ƽ�", JLabel.CENTER));
		panel.add(new JLabel("���ʱ��", JLabel.CENTER));
		panel.add(new JLabel("����", JLabel.CENTER));
		for(int i = 1; i <= 10; i++){
			createContextPanel(panel,""+i);
		}
		return panel;
	}
	
	private Component createContextPanel(JPanel panel, String str) {
		final JTextField num = createText(str); //���
		final JTextField cls = createText(str); //����
		final JTextField name = createText(str); //����
		final JTextField date = createText(str); //ʱ��
		
		final JButton btn = new JButton("�༭");
		btn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				if(btn.getText().equals("�༭")){
					btn.setText("����");
					num.setEditable(true);
					cls.setEditable(true);
					name.setEditable(true);
					date.setEditable(true);
				}else{
					btn.setText("�༭");
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

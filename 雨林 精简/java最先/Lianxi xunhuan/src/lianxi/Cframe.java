package lianxi;



import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.border.EmptyBorder;

public class Cframe extends JFrame {

	private JButton start;
	private JButton result;
	private JButton rule;
	private JButton exit;
	

	
	public Cframe() {
		init();
		//���������ע�뵽control��
	}

	private void init() {
		this.setTitle("���ֿƼ�ѧԱ����ϵͳ");
		this.setSize(600, 400);
		this.add(createContentPane());
		
		this.setLocationRelativeTo(null);//���ھ���
		
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setResizable(false);
	}

	private JPanel createContentPane() {
		JPanel p = new JPanel(new BorderLayout(0, 8));
		p.setBorder(new EmptyBorder(12, 12, 12, 12));
		p.add(new JLabel(
				new ImageIcon(this.getClass().getResource("title.png")),
				JLabel.CENTER), BorderLayout.NORTH);
		p.add(createCenterPane(), BorderLayout.CENTER);
		p.add(new JLabel("��Ȩ���У���ð�ؾ�", JLabel.RIGHT), BorderLayout.SOUTH);
		return p;
	}
	private JLabel nameText;
	private JPanel createCenterPane() {
		nameText = new JLabel("��ӭXXX��¼����ϵͳ", JLabel.CENTER);
		JPanel p = new JPanel(new BorderLayout());
		p.add(nameText,	BorderLayout.NORTH);
		p.add(createButtonPane(), BorderLayout.CENTER);
		return p;
	}
	public void updateNameText(){
		nameText.setText(
				"��ӭ"+getName()+"��¼����ϵͳ");
		nameText.repaint();
	}

	private JPanel createButtonPane() {
		JPanel p = new JPanel();
		start = createImageButton("��ʼ", "exam.png");

		
		
		
		result = createImageButton("����", "result.png");
		
	
		
		
		rule = createImageButton("����", "message.png");
		exit = createImageButton("�˳�", "exit.png");
		p.add(start);
		p.add(result);
		p.add(rule);
		p.add(exit);
		return p;
	}

	private JButton createImageButton(String text, String image) {
		JButton b = new JButton(text
				, new ImageIcon("src/com/yulin/am/"+image));
		b.setHorizontalTextPosition(JButton.CENTER);
		b.setVerticalTextPosition(JButton.BOTTOM);
		return b;
	}
	public static void main(String[] args){
		Cframe c=new Cframe();
			
			c.setVisible(true);
		
}
}
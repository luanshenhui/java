package com.yulin.am;

import java.awt.*;

import javax.swing.*;

public class UIDemo1 {
	public static void main(String[] args) {
		JFrame jf = new JFrame();
		jf.setSize(800, 600);
		jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//�رմ���ʱ�˳�ϵͳ
		
		JPanel jp = new JPanel(new BorderLayout());	//BorderLayout(int h,int v )��λ���� h:ˮƽ��� v:��ֱ���
		
//		JButton btn = new JButton("����ѽ��");
		JButton btn1 = new JButton("��");
		jp.add(btn1, new BorderLayout().NORTH);
		
		JButton btn2 = new JButton("��");
		jp.add(btn2, new BorderLayout().SOUTH);
		
		JButton btn3 = new JButton("��");
		jp.add(btn3, new BorderLayout().EAST);
		
		JButton btn4 = new JButton("��");
		jp.add(btn4, new BorderLayout().WEST);
		
		JButton btn5 = new JButton("��");
		jp.add(btn5, new BorderLayout().CENTER);
		
		JTextField jtf = new JTextField();//�ı�������
//		jp.add(jtf, BorderLayout.CENTER);
		jtf.setColumns(20);
		
		JPanel centerPanel = new JPanel();
		centerPanel.add(btn5);
		centerPanel.add(jtf);
		
		JLabel jl = new JLabel("Hello");	//��ǩ
		centerPanel.add(jl);
		
		jp.add(centerPanel,BorderLayout.CENTER);
		jf.add(jp);
		jf.setVisible(true);	//��ʾFrame 
	}
}
package com.yulin.am;

import java.awt.BorderLayout;
import java.awt.Window;
import java.awt.event.WindowEvent;
import java.rmi.server.Operation;

import javax.swing.*;

public class UIDemo1 {
	public static void main(String[] args) {
		JFrame jf = new JFrame();
		jf.setSize(800, 600);
		jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		//�رմ���ʱ�˳�����
		
		JPanel jp = new JPanel(new BorderLayout(0,50));
		//BorderLayout(int h, int v) ��λ���� h:ˮƽ���, v:��ֱ��� 
		JButton btn3 = new JButton("��");
		jp.add(btn3, BorderLayout.WEST);
		
		JButton btn4 = new JButton("��");
		jp.add(btn4, BorderLayout.EAST);
		
		JButton btn1 = new JButton("��");
		jp.add(btn1, BorderLayout.NORTH);
		
		JButton btn2 = new JButton("��");
		jp.add(btn2, BorderLayout.SOUTH);
		
		JButton btn5 = new JButton("��");
		JTextField jtf = new JTextField(); //�ı�������
		jtf.setColumns(20);
		
		JPanel centerPanel = new JPanel();
		centerPanel.add(btn5);
		centerPanel.add(jtf);
		
		JLabel jl = new JLabel("���!"); //��ǩ
		centerPanel.add(jl);
		
		jp.add(centerPanel, BorderLayout.CENTER);
			
//		for(int i = 0; i < 5; i++){
//			JButton btn = new JButton("����ѽ��");
//			jp.add(btn);
//		}
		
		jf.add(jp);
		jf.setVisible(true); //��ʾFrame
	}
}

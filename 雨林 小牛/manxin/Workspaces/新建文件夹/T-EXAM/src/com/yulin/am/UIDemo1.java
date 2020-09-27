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
		//关闭窗口时退出程序。
		
		JPanel jp = new JPanel(new BorderLayout(0,50));
		//BorderLayout(int h, int v) 方位布局 h:水平间距, v:垂直间距 
		JButton btn3 = new JButton("西");
		jp.add(btn3, BorderLayout.WEST);
		
		JButton btn4 = new JButton("东");
		jp.add(btn4, BorderLayout.EAST);
		
		JButton btn1 = new JButton("北");
		jp.add(btn1, BorderLayout.NORTH);
		
		JButton btn2 = new JButton("南");
		jp.add(btn2, BorderLayout.SOUTH);
		
		JButton btn5 = new JButton("中");
		JTextField jtf = new JTextField(); //文本输入条
		jtf.setColumns(20);
		
		JPanel centerPanel = new JPanel();
		centerPanel.add(btn5);
		centerPanel.add(jtf);
		
		JLabel jl = new JLabel("你好!"); //标签
		centerPanel.add(jl);
		
		jp.add(centerPanel, BorderLayout.CENTER);
			
//		for(int i = 0; i < 5; i++){
//			JButton btn = new JButton("点我呀！");
//			jp.add(btn);
//		}
		
		jf.add(jp);
		jf.setVisible(true); //显示Frame
	}
}

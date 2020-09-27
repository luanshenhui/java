package com.yulin.am;

import java.awt.*;

import javax.swing.*;

public class UIDemo1 {
	public static void main(String[] args) {
		JFrame jf = new JFrame();
		jf.setSize(800, 600);
		jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//关闭窗口时退出系统
		
		JPanel jp = new JPanel(new BorderLayout());	//BorderLayout(int h,int v )方位布局 h:水平间距 v:垂直间距
		
//		JButton btn = new JButton("点我呀！");
		JButton btn1 = new JButton("北");
		jp.add(btn1, new BorderLayout().NORTH);
		
		JButton btn2 = new JButton("南");
		jp.add(btn2, new BorderLayout().SOUTH);
		
		JButton btn3 = new JButton("东");
		jp.add(btn3, new BorderLayout().EAST);
		
		JButton btn4 = new JButton("西");
		jp.add(btn4, new BorderLayout().WEST);
		
		JButton btn5 = new JButton("中");
		jp.add(btn5, new BorderLayout().CENTER);
		
		JTextField jtf = new JTextField();//文本输入条
//		jp.add(jtf, BorderLayout.CENTER);
		jtf.setColumns(20);
		
		JPanel centerPanel = new JPanel();
		centerPanel.add(btn5);
		centerPanel.add(jtf);
		
		JLabel jl = new JLabel("Hello");	//标签
		centerPanel.add(jl);
		
		jp.add(centerPanel,BorderLayout.CENTER);
		jf.add(jp);
		jf.setVisible(true);	//显示Frame 
	}
}
package com.yulin.am;
import javax.swing.*;
public class ImgBtnDemo {
	public static void main(String[] args) {
//		JButton btn = new JButton(
//		"开始", new ImageIcon(
//		new ImgBtnDemo().getClass().getResource("start.png")));
		
		JButton btn = new JButton(
				"开始", new ImageIcon("src/com/yulin/am/start.png"));
		
		btn.setHorizontalTextPosition(JButton.CENTER);//水平居中
		btn.setVerticalTextPosition(JButton.BOTTOM);//垂直向下
		
		JLabel jl = new JLabel(
				new ImageIcon("src/com/yulin/am/start.png"));
		
		JFrame frame = new JFrame();
		frame.setSize(400, 300);
		JPanel panel = new JPanel();
		panel.add(btn);
		panel.add(jl);
		frame.add(panel);
		frame.setVisible(true);
	}
}

package com.yulin.am;

import javax.swing.*;

public class ImgBtnDemo {

	/**
	 * 图标按钮
	 */
	public static void main(String[] args) {
//		JButton btn = new JButton("开始", new ImageIcon(new ImgBtnDemo().getClass().getResource("start.png")));//映射方法
		JButton btn = new JButton("开始",new ImageIcon("src/com/yulin/am/start.png"));//静态路径方法
		btn.setVerticalTextPosition(JButton.BOTTOM);//垂直向下(文字相对于图片的位置)
		btn.setHorizontalTextPosition(JButton.CENTER);//水平居中
		JFrame frame = new JFrame();
		frame.setSize(400,300);
		JPanel panel = new JPanel();
		panel.add(btn);
		frame.add(panel);
		frame.setVisible(true);
	}

}

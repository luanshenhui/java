package com.yulin.am;

import javax.swing.*;

public class ImgBtnDemo {

	/**
	 * ͼ�갴ť
	 */
	public static void main(String[] args) {
//		JButton btn = new JButton("��ʼ", new ImageIcon(new ImgBtnDemo().getClass().getResource("start.png")));//ӳ�䷽��
		JButton btn = new JButton("��ʼ",new ImageIcon("src/com/yulin/am/start.png"));//��̬·������
		btn.setVerticalTextPosition(JButton.BOTTOM);//��ֱ����(���������ͼƬ��λ��)
		btn.setHorizontalTextPosition(JButton.CENTER);//ˮƽ����
		JFrame frame = new JFrame();
		frame.setSize(400,300);
		JPanel panel = new JPanel();
		panel.add(btn);
		frame.add(panel);
		frame.setVisible(true);
	}

}

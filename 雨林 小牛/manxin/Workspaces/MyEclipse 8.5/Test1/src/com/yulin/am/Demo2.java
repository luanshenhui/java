package com.yulin.am;

import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;


public class Demo2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Frame f = new Frame();//�����߿�
		//f.setTitle("Hello");
		f.setSize(600, 400);
		f.setBackground(Color.cyan);
		f.setAlwaysOnTop(true);//ǰ��
		
		f.addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});//�������ر�
		
		Panel p = new Panel();//����һ������
		Button btn = new Button("OK");
		Label l = new Label("Hello");
		p.add(l);
		p.add(btn);
		f.add(p);
		f.show();
		
	}

}

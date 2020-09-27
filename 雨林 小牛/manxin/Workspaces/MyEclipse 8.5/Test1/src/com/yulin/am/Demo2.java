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
		Frame f = new Frame();//创建边框
		//f.setTitle("Hello");
		f.setSize(600, 400);
		f.setBackground(Color.cyan);
		f.setAlwaysOnTop(true);//前置
		
		f.addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});//点击红叉后关闭
		
		Panel p = new Panel();//创建一个画布
		Button btn = new Button("OK");
		Label l = new Label("Hello");
		p.add(l);
		p.add(btn);
		f.add(p);
		f.show();
		
	}

}

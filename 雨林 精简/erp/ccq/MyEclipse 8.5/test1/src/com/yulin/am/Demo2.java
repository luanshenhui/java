package com.yulin.am;
import java.awt.Color;
import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.*;
public class Demo2 {
	public static void main(String[] args){
		
	
		
		Frame f =new Frame();
		
		
		
		
		f.setTitle("hello");
		f.setSize(800, 600);
		f.setBackground(Color.red);
		f.setAlwaysOnTop(true);
		
		f.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
			}
		);
		
		Panel p = new Panel();
		Button btn = new Button("����");
		Label l = new Label("��ӭ����");
		
		p.add(l);
		p.add(btn);
		f.add(p);
	
		f.show();//��ʾ
		//1����(����..) 2����(new) 3����(set..)4���(add..)
	}

}

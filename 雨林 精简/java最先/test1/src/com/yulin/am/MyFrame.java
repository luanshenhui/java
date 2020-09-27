package com.yulin.am;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
public class MyFrame extends Frame{
	public static void main(String[] args){
		MyFrame mf = new MyFrame();
		
		
		mf.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
			}
		);
		
		
		
		
		mf.show();
	}
		public MyFrame(){
	setTitle("hello");
	setSize(800, 1000);
	setBackground(Color.green);
	setAlwaysOnTop(true);
	
	
}
		}


package com.yulin.am;

import java.awt.*;
import java.awt.event.*;

public class MyFrame extends Frame {
	public static void main(String[] args){
		MyFrame mf = new MyFrame();
		mf.show();
	}

	public MyFrame(){
		setTitle("Hello");
		setSize(800,600);
		setBackground(Color.cyan);
		setAlwaysOnTop(true);
		addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});//µã»÷ºì²æºó¹Ø±Õ
		
	

	}
	

}

package com.yulin.Frame;
import java.awt.*;
import java.awt.event.*;

public class MyFrame extends Frame{
	public MyFrame(){
		setSize(800,600);
		setBackground(Color.cyan);
		setAlwaysOnTop(true);
		
		addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});
	}
}

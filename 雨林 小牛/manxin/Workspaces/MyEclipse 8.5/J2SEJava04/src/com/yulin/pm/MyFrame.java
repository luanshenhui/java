package com.yulin.pm;

import java.awt.*;
import java.awt.event.*;

public class MyFrame extends Frame{

	/**
	 * @param args
	 */
	
	public MyFrame(){
		init();
	}
	
	private void init(){
		setSize(800,600);
		setAlwaysOnTop(true);
		setTitle("MyFrame");
		setBackground(Color.cyan);
		addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});
	}


}

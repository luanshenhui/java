package com.yulin.pm;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import com.yulin.am.MyFrame;

public class Demo2{
	public static void main(String[] args){
		MyFrame mf =new MyFrame();
		MyPanel mp =new MyPanel();
		
		
		
		mf.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
			}
		);
		
		
		
		
		mf.add(mp);
		mf.show();
		//×¢²á¼àÌýÆ÷
		mp.addMouseMotionListener(mp);
		mf.addMouseMotionListener(mp);
	}
}
		
		
	


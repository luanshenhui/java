package com.yulin.am;
import java.awt.*;
import java.awt.event.*;

public class Test1Demo02 {
	public static void main(String[] args){
		Frame f = new Frame();
		f.setSize(800,600);
		f.setBackground(Color.cyan);
		f.addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});
	}

}


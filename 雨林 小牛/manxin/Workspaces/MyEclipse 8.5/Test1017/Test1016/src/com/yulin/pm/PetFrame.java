package com.yulin.pm;
import java.awt.*;
import java.awt.event.*;

public class PetFrame extends Frame{
	public static void main(String[] args){
		PetFrame pf = new PetFrame();
		pf.show();
	}
	public PetFrame(){
		setTitle("ÎÒµÄ³èÎï");
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

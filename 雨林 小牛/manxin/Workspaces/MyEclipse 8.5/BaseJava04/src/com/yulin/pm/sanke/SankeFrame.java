package com.yulin.pm.sanke;
import java.awt.*;
import java.awt.event.*;

public class SankeFrame extends Frame{
	public static void main(String[] args){
		
		SankeFrame sf = new SankeFrame();
		sf.show();
	}
	public SankeFrame(){
		setAlwaysOnTop(true);
		setTitle("SankGame");
		setSize(800,800);
		setBackground(Color.pink);
		addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e){
				System.exit(0);
			}
		});
	}
	
	
	
}

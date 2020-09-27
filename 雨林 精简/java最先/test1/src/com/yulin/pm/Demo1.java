package com.yulin.pm;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
public class Demo1 {
	public static void main(String[] args){
		Frame f =new Frame();
		
		
		f.setSize(800,600);
		Panel p =new Panel();
		Label l =new Label("123");
		
		p.add(l);
		f.add(p);
		f.show();
		
		
		
	}

}

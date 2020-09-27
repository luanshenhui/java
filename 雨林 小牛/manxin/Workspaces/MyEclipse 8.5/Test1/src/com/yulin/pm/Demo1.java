package com.yulin.pm;
import com.yulin.am.*;
import java.awt.event.*;
public class Demo1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MyFrame mf = new MyFrame();
		MyPanel pl = new MyPanel();
		mf.add(pl);
		// µœ÷ Û±Íº‡Ã˝
		pl.addMouseMotionListener(pl);
		mf.addMouseMotionListener(pl);
		mf.show();
	
	}

}

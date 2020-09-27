package com.yulin.Frame;

public class AwtDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		MyFrame mf = new MyFrame();
		
		MyPanel mp = new MyPanel();
		
		mp.addKeyListener(mp);
		mf.addKeyListener(mp);
		
		mf.add(mp);
		mf.show();

	}
}

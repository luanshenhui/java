package com.yulin.pm;

public class Demo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		MyFrame mf = new MyFrame();
		
		MyPanel mp = new MyPanel();
		mf.add(mp);
		mf.show();
		
		while(true){
			MyThread mt = new MyThread();
			try {
				mt.sleep(1000/24);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			mp.move();
			mp.repaint();
		}	
	}

}

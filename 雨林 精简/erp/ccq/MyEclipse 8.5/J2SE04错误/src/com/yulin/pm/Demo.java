package com.yulin.pm;

public class Demo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MyFrame mf = new MyFrame();
		MyPanel mp = new MyPanel();
		mf.add(mp);
		mf.show();
		while (2 > 1) {
			MyThread mt = new MyThread();
			try {
				mt.sleep(1000/24);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			mp.move();
			mp.repaint();

		}
		
	}

}

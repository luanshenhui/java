package com.yulin.Snake;
import java.util.*;

public class GameStart {

	/**
	 * 2014-10-24
	 * ���ԣ��������ߡ�����
	 */
	public static void main(String[] args) {
		Snake sk = new Snake();
		
		sk.show();
		sk.createFood();
		
		while(true){
			MyThread mt = new MyThread(sk);
			mt.start();
//			sk.change();
			sk.move();
			sk.show();
			try {
				Thread.sleep(800);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			
		}

	}

}

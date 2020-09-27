package com.yulin.pm;
import java.util.Timer;
import java.util.TimerTask;

public class InnerClassDemo3 {

	/**
	 * �����ڲ���
	 */
	public static void main1(String[] args) {
		// ��ʱը����10���ը
		final Timer tt = new Timer();
		tt.schedule(new TimerTask(){
			@Override
			public void run(){
				System.err.println("��~");
			}
		}, 10000);
		
		tt.schedule(new TimerTask(){
			@Override
			public void run(){
				tt.cancel();
			}
		}, 11000);
	}
	
	public static void main(String[] args) {
		// ��ʱը����10���ը
		final Timer tt = new Timer();
		tt.schedule(new TimerTask(){		
			int index = 10;
			@Override
			public void run(){
				System.out.println("��ʣ" + index-- + "�뱬ը��");
			}
		},0, 1000);	//�ӳ�0���룬ÿ��1000��������һ��
		
		tt.schedule(new TimerTask(){
			@Override
			public void run(){
				System.err.println("��~");
				tt.cancel();	//ȡ��ʱ��֮������ʹ��
			}
		}, 11000);
	}

}

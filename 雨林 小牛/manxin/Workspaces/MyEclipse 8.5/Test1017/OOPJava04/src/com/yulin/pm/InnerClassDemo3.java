package com.yulin.pm;
import java.util.Timer;
import java.util.TimerTask;

public class InnerClassDemo3 {

	/**
	 * 匿名内部类
	 */
	public static void main1(String[] args) {
		// 定时炸弹，10秒后爆炸
		final Timer tt = new Timer();
		tt.schedule(new TimerTask(){
			@Override
			public void run(){
				System.err.println("嘭~");
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
		// 定时炸弹，10秒后爆炸
		final Timer tt = new Timer();
		tt.schedule(new TimerTask(){		
			int index = 10;
			@Override
			public void run(){
				System.out.println("还剩" + index-- + "秒爆炸！");
			}
		},0, 1000);	//延迟0毫秒，每隔1000毫秒运行一次
		
		tt.schedule(new TimerTask(){
			@Override
			public void run(){
				System.err.println("嘭~");
				tt.cancel();	//取消时间之后不能再使用
			}
		}, 11000);
	}

}

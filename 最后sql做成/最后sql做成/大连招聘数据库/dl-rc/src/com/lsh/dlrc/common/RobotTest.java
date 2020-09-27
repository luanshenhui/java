package com.lsh.dlrc.common;

import java.awt.AWTException;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.event.InputEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.imageio.ImageIO;

public class RobotTest {

	public static void main(String[] args) throws AWTException,
			InterruptedException, IOException {
		timer1();
	}
	
	
	// 第四种方法：安排指定的任务task在指定的时间firstTime开始进行重复的固定速率period执行．
	// Timer.scheduleAtFixedRate(TimerTask task,Date firstTime,long period)
	public static void timer4() {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 13); // 控制时
		calendar.set(Calendar.MINUTE, 15); // 控制分
		calendar.set(Calendar.SECOND, 0); // 控制秒

		Date time = calendar.getTime(); // 得出执行任务的时间,此处为今天的12：00：00

		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {
			public void run() {
				System.out.println("-------设定要指定任务--------");
			}
		}, time, 1000 * 60 * 60 * 24);// 这里设定将延时每天固定执行

	}

	// 第一种方法：设定指定任务task在指定时间time执行 schedule(TimerTask task, Date time)
	public static void timer1() throws AWTException,
	InterruptedException, IOException {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 17); // 控制时
		calendar.set(Calendar.MINUTE, 11); // 控制分
		calendar.set(Calendar.SECOND, 0); // 控制秒
		Date time = calendar.getTime();
		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			public void run() {
				try {
					System.out.println("-------开始签到-------");
					runQiandao();
					System.out.println("-------结束签到-------");
				} catch (AWTException e) {
					e.printStackTrace();
				} catch (InterruptedException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}, time);// 设定指定的时间time,此处为2000毫秒
	}

	// 第二种方法：设定指定任务task在指定延迟delay后进行固定延迟peroid的执行
	// schedule(TimerTask task, long delay, long period)
	public static void timer2() {
		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			public void run() {
				System.out.println("-------设定要指定任务--------");
			}
		}, 1000, 5000);
	}

	// 第三种方法：设定指定任务task在指定延迟delay后进行固定频率peroid的执行。
	// scheduleAtFixedRate(TimerTask task, long delay, long period)
	public static void timer3() {
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {
			public void run() {
				System.out.println("-------设定要指定任务--------");
			}
		}, 1000, 2000);
	}
	private static void runQiandao() throws AWTException,
	InterruptedException, IOException {
		Robot robot = new Robot();
		// 设置Robot产生一个动作后的休眠时间,否则执行过快
		robot.setAutoDelay(3000);

		// 获取屏幕分辨率
		Dimension d = Toolkit.getDefaultToolkit().getScreenSize();
		System.out.println(d);
		// 以屏幕的尺寸创建个矩形
		Rectangle screenRect = new Rectangle(d);
		// 移动鼠标
		robot.mouseMove(700, 500);
		// // 鼠标右键
		System.out.println("右击");
		robot.mousePress(InputEvent.BUTTON3_MASK);
		robot.mouseRelease(InputEvent.BUTTON3_MASK);
		// 移动鼠标
		robot.mouseMove(850, 738);
		// 截图（截取整个屏幕图片）
		BufferedImage bufferedImage = robot.createScreenCapture(screenRect);
		// 保存截图
		File file = new File("C:/Users/Administrator/Desktop/screenRect1.png");
		ImageIO.write(bufferedImage, "png", file);
		// 鼠标左键
		System.out.println("单击");
		robot.mousePress(InputEvent.BUTTON1_MASK);
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
		// 移动鼠标
		robot.mouseMove(1090, 570);
		// 截图（截取整个屏幕图片）
		BufferedImage bufferedImage2 = robot.createScreenCapture(screenRect);
		// 保存截图
		File file2 = new File("C:/Users/Administrator/Desktop/screenRect2.png");
		ImageIO.write(bufferedImage2, "png", file2);
		System.out.println("单击");
		robot.mousePress(InputEvent.BUTTON1_MASK);
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
		// 截图（截取整个屏幕图片）
		BufferedImage bufferedImage3 = robot.createScreenCapture(screenRect);
		// 保存截图
		File file3 = new File("C:/Users/Administrator/Desktop/screenRect3.png");
		ImageIO.write(bufferedImage3, "png", file3);
		// 按下ESC，退出
		// System.out.println("按下ESC");
		// robot.keyPress(KeyEvent.VK_ESCAPE);
		// robot.keyRelease(KeyEvent.VK_ESCAPE);
		// // 滚动鼠标滚轴
		// System.out.println("滚轴");
		// robot.mouseWheel(5);
		//
		// // 按下Alt+TAB键（切换桌面窗口）
		// robot.keyPress(KeyEvent.VK_ALT);
		// for (int i = 1; i <= 2; i++) {
		// robot.keyPress(KeyEvent.VK_TAB);
		// robot.keyRelease(KeyEvent.VK_TAB);
		// }
		// robot.keyRelease(KeyEvent.VK_ALT);
		
	}

}

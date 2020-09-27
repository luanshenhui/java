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
	
	
	// �����ַ���������ָ��������task��ָ����ʱ��firstTime��ʼ�����ظ��Ĺ̶�����periodִ�У�
	// Timer.scheduleAtFixedRate(TimerTask task,Date firstTime,long period)
	public static void timer4() {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 13); // ����ʱ
		calendar.set(Calendar.MINUTE, 15); // ���Ʒ�
		calendar.set(Calendar.SECOND, 0); // ������

		Date time = calendar.getTime(); // �ó�ִ�������ʱ��,�˴�Ϊ�����12��00��00

		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {
			public void run() {
				System.out.println("-------�趨Ҫָ������--------");
			}
		}, time, 1000 * 60 * 60 * 24);// �����趨����ʱÿ��̶�ִ��

	}

	// ��һ�ַ������趨ָ������task��ָ��ʱ��timeִ�� schedule(TimerTask task, Date time)
	public static void timer1() throws AWTException,
	InterruptedException, IOException {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 17); // ����ʱ
		calendar.set(Calendar.MINUTE, 11); // ���Ʒ�
		calendar.set(Calendar.SECOND, 0); // ������
		Date time = calendar.getTime();
		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			public void run() {
				try {
					System.out.println("-------��ʼǩ��-------");
					runQiandao();
					System.out.println("-------����ǩ��-------");
				} catch (AWTException e) {
					e.printStackTrace();
				} catch (InterruptedException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}, time);// �趨ָ����ʱ��time,�˴�Ϊ2000����
	}

	// �ڶ��ַ������趨ָ������task��ָ���ӳ�delay����й̶��ӳ�peroid��ִ��
	// schedule(TimerTask task, long delay, long period)
	public static void timer2() {
		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			public void run() {
				System.out.println("-------�趨Ҫָ������--------");
			}
		}, 1000, 5000);
	}

	// �����ַ������趨ָ������task��ָ���ӳ�delay����й̶�Ƶ��peroid��ִ�С�
	// scheduleAtFixedRate(TimerTask task, long delay, long period)
	public static void timer3() {
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {
			public void run() {
				System.out.println("-------�趨Ҫָ������--------");
			}
		}, 1000, 2000);
	}
	private static void runQiandao() throws AWTException,
	InterruptedException, IOException {
		Robot robot = new Robot();
		// ����Robot����һ�������������ʱ��,����ִ�й���
		robot.setAutoDelay(3000);

		// ��ȡ��Ļ�ֱ���
		Dimension d = Toolkit.getDefaultToolkit().getScreenSize();
		System.out.println(d);
		// ����Ļ�ĳߴ紴��������
		Rectangle screenRect = new Rectangle(d);
		// �ƶ����
		robot.mouseMove(700, 500);
		// // ����Ҽ�
		System.out.println("�һ�");
		robot.mousePress(InputEvent.BUTTON3_MASK);
		robot.mouseRelease(InputEvent.BUTTON3_MASK);
		// �ƶ����
		robot.mouseMove(850, 738);
		// ��ͼ����ȡ������ĻͼƬ��
		BufferedImage bufferedImage = robot.createScreenCapture(screenRect);
		// �����ͼ
		File file = new File("C:/Users/Administrator/Desktop/screenRect1.png");
		ImageIO.write(bufferedImage, "png", file);
		// ������
		System.out.println("����");
		robot.mousePress(InputEvent.BUTTON1_MASK);
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
		// �ƶ����
		robot.mouseMove(1090, 570);
		// ��ͼ����ȡ������ĻͼƬ��
		BufferedImage bufferedImage2 = robot.createScreenCapture(screenRect);
		// �����ͼ
		File file2 = new File("C:/Users/Administrator/Desktop/screenRect2.png");
		ImageIO.write(bufferedImage2, "png", file2);
		System.out.println("����");
		robot.mousePress(InputEvent.BUTTON1_MASK);
		robot.mouseRelease(InputEvent.BUTTON1_MASK);
		// ��ͼ����ȡ������ĻͼƬ��
		BufferedImage bufferedImage3 = robot.createScreenCapture(screenRect);
		// �����ͼ
		File file3 = new File("C:/Users/Administrator/Desktop/screenRect3.png");
		ImageIO.write(bufferedImage3, "png", file3);
		// ����ESC���˳�
		// System.out.println("����ESC");
		// robot.keyPress(KeyEvent.VK_ESCAPE);
		// robot.keyRelease(KeyEvent.VK_ESCAPE);
		// // ����������
		// System.out.println("����");
		// robot.mouseWheel(5);
		//
		// // ����Alt+TAB�����л����洰�ڣ�
		// robot.keyPress(KeyEvent.VK_ALT);
		// for (int i = 1; i <= 2; i++) {
		// robot.keyPress(KeyEvent.VK_TAB);
		// robot.keyRelease(KeyEvent.VK_TAB);
		// }
		// robot.keyRelease(KeyEvent.VK_ALT);
		
	}

}

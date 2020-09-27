package day05;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JFrame;
import javax.swing.JPanel;
/**
 * KeyListener 接口定义了键盘事件处理的方法, 要想将
 * 代码与系统的键盘处理过程进行连接,就需要实现这个接口 
 */
public class Demo07 {
	public static void main(String[] args) {
		KeyTester l = new KeyTester();//相当于USB鼠标
		
		JFrame frame = new JFrame();
		JPanel panel = new JPanel();
		frame.add(panel);
		frame.setSize(300, 200);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
		//panel 相当于 电脑
		panel.addKeyListener(l);//插接l到面板上，
		// USB鼠标 插接到 电脑上 
		// 如果在面板上按下按键，l引用的对象的方法就被执行了
		panel.requestFocus();// 请求键盘输入焦点
		
	}
}
//继承KeyAdaper 就是实现 KeyListener 
class KeyTester implements KeyListener{
	//按键按下时候执行
	public void keyPressed(KeyEvent e) {
		System.out.println("Press:"+e.getKeyCode());
	}
  //按键释放下时候执行
	public void keyReleased(KeyEvent e) {
		System.out.println("Releas:"+e.getKeyCode());
	}
	//按键敲击时候执行
	public void keyTyped(KeyEvent e) {
		System.out.println("Type:"+e.getKeyCode());
	}
}






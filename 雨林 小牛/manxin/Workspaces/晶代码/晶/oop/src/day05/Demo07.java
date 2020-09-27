package day05;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JFrame;
import javax.swing.JPanel;
/**
 * KeyListener �ӿڶ����˼����¼�����ķ���, Ҫ�뽫
 * ������ϵͳ�ļ��̴�����̽�������,����Ҫʵ������ӿ� 
 */
public class Demo07 {
	public static void main(String[] args) {
		KeyTester l = new KeyTester();//�൱��USB���
		
		JFrame frame = new JFrame();
		JPanel panel = new JPanel();
		frame.add(panel);
		frame.setSize(300, 200);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
		//panel �൱�� ����
		panel.addKeyListener(l);//���l������ϣ�
		// USB��� ��ӵ� ������ 
		// ���������ϰ��°�����l���õĶ���ķ����ͱ�ִ����
		panel.requestFocus();// ����������뽹��
		
	}
}
//�̳�KeyAdaper ����ʵ�� KeyListener 
class KeyTester implements KeyListener{
	//��������ʱ��ִ��
	public void keyPressed(KeyEvent e) {
		System.out.println("Press:"+e.getKeyCode());
	}
  //�����ͷ���ʱ��ִ��
	public void keyReleased(KeyEvent e) {
		System.out.println("Releas:"+e.getKeyCode());
	}
	//�����û�ʱ��ִ��
	public void keyTyped(KeyEvent e) {
		System.out.println("Type:"+e.getKeyCode());
	}
}






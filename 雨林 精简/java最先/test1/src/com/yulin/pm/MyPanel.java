package com.yulin.pm;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
public class MyPanel extends Panel implements MouseMotionListener{
	int x =100,y =100;
	//���������Ϊ�������2ʵ��M..�ӿڣ��ƶ����ɷ���3�����������ƶ�4ע���������
	@Override
	public void paint(Graphics g){//����д�ĺ���
		g.clearRect(100, 200, 50, 40);
		g.fillOval(40, 40, 40, 40);
		g.drawLine(x, y, 800, 600);
		g.drawLine(x+300, y+500, 700, 750);
		g.fillOval(100,100, 10, 200);
		g.drawRect(100, y+600, x+100, 150);
		g.drawRoundRect(x+300, y+200, 200, 150, 100, 100);
		g.fillRoundRect(300,400,150,20,50,50);
		g.fillOval(200,10,0,0);
		
	}
	@Override
	public void mouseDragged(MouseEvent e) {//��ק��e�¼�Դ
		// TODO Auto-generated method stub(�����굱ǰλ�ã�����λ�ø�ֵ��x��y)
		x = e.getX();
		y = e.getY();
		repaint();//����ı�󣬴��»���
	}
	@Override
	public void mouseMoved(MouseEvent e) {
		// TODO Auto-generated method stub
		
		
	}

}


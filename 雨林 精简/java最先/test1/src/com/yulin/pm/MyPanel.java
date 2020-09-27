package com.yulin.pm;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
public class MyPanel extends Panel implements MouseMotionListener{
	int x =100,y =100;
	//绝对坐标改为相对坐标2实现M..接口，制动生成方法3坐标更随鼠标移动4注册监听功能
	@Override
	public void paint(Graphics g){//北改写的函数
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
	public void mouseDragged(MouseEvent e) {//托拽，e事件源
		// TODO Auto-generated method stub(获得鼠标当前位置，将此位置赋值给x，y)
		x = e.getX();
		y = e.getY();
		repaint();//坐标改变后，从新画画
	}
	@Override
	public void mouseMoved(MouseEvent e) {
		// TODO Auto-generated method stub
		
		
	}

}


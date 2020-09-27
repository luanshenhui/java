package com.yulin.pm;
import java.awt.*;
import java.awt.event.*;

public class MyPanel extends Panel implements MouseMotionListener{
	//将固定坐标变成相对坐标
	int x=100,y=100;
	@Override
	public void paint(Graphics g){
		g.setColor(Color.black);
		//g.drawArc(x, y, width, height, startAngle, arcAngle);
		//g.drawArc(200, 300, 300, 100, 50, 30);
		g.drawOval(40, 50, 550, 430);
		g.fillOval(150, 150, 80, 100);
		g.fillOval(400, 150, 80, 100);
		g.fillOval(120, 280, 20, 30);
		g.fillOval(100, 350, 20, 30);
		g.fillOval(490, 280, 20, 30);
		g.fillOval(510, 350, 20, 30);
		g.setColor(Color.RED);
		g.fillRoundRect(300, 250, 30, 20, 10, 10);
		
		g.drawLine(400, 400, x+215, y+200);
		g.drawLine(210, 400, x+215, y+200);
		g.setColor(Color.WHITE);
		g.fillOval(200, 180, 30, 50);
		g.fillOval(400, 180, 30, 50);
		g.fillOval(430, 225, 10, 10);
		g.fillOval(190, 225, 10, 10);
		
		g.setColor(Color.blue);
		
	
		//g.drawLine(x1, y1, x2, y2)
		//g.fillOval(x, y, width, height)
	}
	@Override
	public void mouseDragged(MouseEvent e) {//鼠标拖拽
		// TODO Auto-generated method stub
		x=e.getX();
		y=e.getY();
		repaint();//图像重绘
		
	}
	@Override
	public void mouseMoved(MouseEvent e) {//鼠标滑过
		// TODO Auto-generated method stub
		
	}
}

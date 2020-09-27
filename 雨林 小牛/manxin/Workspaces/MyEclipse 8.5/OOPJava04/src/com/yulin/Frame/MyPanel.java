package com.yulin.Frame;
import java.awt.*;
import java.awt.event.*;

public class MyPanel extends Panel implements KeyListener{
	int x = 200,y = 200;
	@Override
	
	public void paint(Graphics g){
//		g.drawOval(100, 100, 50, 200);
//		g.drawOval(300, 100, 50, 200);
//		g.fillOval(100, 300, 250, 50);		
//		g.drawRoundRect(200, 200, 50,80, 50, 30);
		
		showG(g);
		
	}
	
	public void showG(Graphics g){
		//正方体
		g.drawRect(x, y, 200, 200);
		g.drawRect(x-70, y+40, 200, 200);
		
		g.drawLine(x, y, x-70, y+40);	
		g.drawLine(x+200, y+200, x+130, y+240);
		g.drawLine(x+200, y, x+130, y+40);
		g.drawLine(x, y+200, x-70, y+240);
	}

	@Override
	public void keyPressed(KeyEvent e) {
		// 按下某键时，调用的方法，e事件源
		if(e.getKeyChar() == 'a'){
			x -= 10;
		}else if(e.getKeyChar() == 'd'){
			x += 10;
		}else if(e.getKeyChar() == 'w'){
			y -= 10;
		}else if(e.getKeyChar() == 's'){
			y += 10;
		}
		repaint();	//重新绘制
	}

	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}
}

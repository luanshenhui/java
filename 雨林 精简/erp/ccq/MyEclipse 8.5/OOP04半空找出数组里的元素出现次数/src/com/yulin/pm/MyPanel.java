package com.yulin.pm;

import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class MyPanel extends Panel implements KeyListener{
	int x=200,y=200;
	@Override
	public void paint(Graphics g){
		g.drawOval(100, 100, 50, 200);
		g.fillOval(200, 300, 200, 50);
		g.drawString("good", 20, 80);
		
		
		g.drawLine(400+x,y,200,200);
		g.drawLine(x,y,200,400);
		g.drawLine(x,400,600,400);
		g.drawLine(400+x,400,600,200);
		
		g.drawLine(250+x,50,50,50);
		g.drawLine(x-150,y-150,50,250);
		g.drawLine(x-150,y+50,450,250);
		g.drawLine(250+x,50+x,450,50);
		
		g.drawLine(400+x,y,450,50);
		g.drawLine(x,y,50,50);
		g.drawLine(x,200+y,50,250);
		g.drawLine(400+x,200+y,450,250);
		
		
		
		
		
		
		
		
		
		
		
		
	}
	@Override
	public void keyPressed(KeyEvent e) {
		// TODO Auto-generated method stub
		if(e.getKeyChar()=='a'){
			x--;
		}else if(e.getKeyChar()=='d')
		{
			x++;
			}else if(e.getKeyChar()=='w'){
				y--;
			}else if(e.getKeyChar()=='s'){
				y++;
			}
		repaint();//ÖØÐÂ»æÖÆ
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

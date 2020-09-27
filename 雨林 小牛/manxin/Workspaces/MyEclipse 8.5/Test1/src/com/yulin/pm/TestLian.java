package com.yulin.pm;
import java.util.*;
import java.awt.*;
import com.yulin.am.*;
import java.awt.event.*;

public class TestLian extends Panel implements MouseMotionListener{
	int x=100,y=100;
	public static void main(String[] args){
		MyFrame mf = new MyFrame();
		TestLian tl = new TestLian();
		
		mf.add(tl);
		
		//mf.add(tl);
		mf.show();
		tl.addMouseMotionListener(tl);
		mf.addMouseMotionListener(tl);
		}
	public void paint(Graphics g){	
		
		g.setColor(Color.blue);	
		Random ra = new Random();
		for(int i = 0; i < 500 ; i++){
			int a=ra.nextInt(800);
			int b=ra.nextInt(600);
			g.drawString("★", a, b);
		}
		g.setColor(Color.yellow);
		g.setFont(new Font("黑体",0,20));//设置字体大小
		g.drawString("★", x, y+100);
		g.drawString("★", 120, 230);
		g.drawString("★", 150, 230);
		g.drawString("★", 170, 200);
		g.drawString("★", 200, 200);
		g.drawString("★", 230, 200);
		g.drawString("★", 250, 220);
	}
	@Override
	public void mouseDragged(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void mouseMoved(MouseEvent e) {
		// TODO Auto-generated method stub
		x=e.getX();
		y=e.getY();
		repaint();
	}

}

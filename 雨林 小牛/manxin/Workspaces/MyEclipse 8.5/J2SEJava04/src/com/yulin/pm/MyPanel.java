package com.yulin.pm;

import java.awt.*;
import java.awt.event.*;
import java.util.*;

public class MyPanel extends Panel{
	
	int x,y;
	int dir = 1; //球的方向，1，-1，,10和-1分别对应右，左，下，上
	
	@Override
	public void paint(Graphics g){
		g.setColor(Color.pink);
		g.fillOval(x, y, 100, 100);
		g.fillOval(x+90, y+20, 50, 50);
		g.fillRect(x+120, y+38, 30, 15);
	}
	
	public void move(){
		int xc = (dir % 10) * 5;	//x方向的坐标差值
		int yc = (dir / 10) * 5;	//y方向的坐标差值
		
		if(x > 0 && x + 100 < 800){	//不能超出边界
			x += xc;
		}else{
			NPCChanged();
			x += xc;
		}
		if(y > 0 && y + 100 < 600){
			y += yc;
		}else{
			NPCChanged();
			y += yc;
		}
		Random rd = new Random();
		int r = rd.nextInt(10);	//每次移动有1/10的概率改变方向
		if(r == 8){	//如果随机数为8，则改变方向
			NPCChanged();
		}
	}
	
	private void NPCChanged(){	//电脑改变方向
		//随机出4个数，改变NPC的方向(1,-1,10,-10)
		int[] ds = {1,-1,10,-10};
		Random rd = new Random();
		dir = ds[rd.nextInt(4)];	//随机一个方向
	}
	
	private void start(){
		Timer timer = new Timer();
		TimerTask tt = new TimerTask(){	//TimerTask是抽象类 实现Runnable
			@Override
			public void run(){
				move();
				repaint();
			}
		};
		timer.schedule(tt, 0, 1000/24);	//计时器
	}
	
	public MyPanel(){
//		start();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

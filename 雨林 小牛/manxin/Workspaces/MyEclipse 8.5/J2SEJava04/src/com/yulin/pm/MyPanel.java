package com.yulin.pm;

import java.awt.*;
import java.awt.event.*;
import java.util.*;

public class MyPanel extends Panel{
	
	int x,y;
	int dir = 1; //��ķ���1��-1��,10��-1�ֱ��Ӧ�ң����£���
	
	@Override
	public void paint(Graphics g){
		g.setColor(Color.pink);
		g.fillOval(x, y, 100, 100);
		g.fillOval(x+90, y+20, 50, 50);
		g.fillRect(x+120, y+38, 30, 15);
	}
	
	public void move(){
		int xc = (dir % 10) * 5;	//x����������ֵ
		int yc = (dir / 10) * 5;	//y����������ֵ
		
		if(x > 0 && x + 100 < 800){	//���ܳ����߽�
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
		int r = rd.nextInt(10);	//ÿ���ƶ���1/10�ĸ��ʸı䷽��
		if(r == 8){	//��������Ϊ8����ı䷽��
			NPCChanged();
		}
	}
	
	private void NPCChanged(){	//���Ըı䷽��
		//�����4�������ı�NPC�ķ���(1,-1,10,-10)
		int[] ds = {1,-1,10,-10};
		Random rd = new Random();
		dir = ds[rd.nextInt(4)];	//���һ������
	}
	
	private void start(){
		Timer timer = new Timer();
		TimerTask tt = new TimerTask(){	//TimerTask�ǳ����� ʵ��Runnable
			@Override
			public void run(){
				move();
				repaint();
			}
		};
		timer.schedule(tt, 0, 1000/24);	//��ʱ��
	}
	
	public MyPanel(){
//		start();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

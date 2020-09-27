package com.yulin.pm;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
public class MyPanel extends Panel implements KeyListener{
	private pet pt;
	String[] msgs ={
		" ","吧唧","再喂就疯了",  "我爱洗澡","亮相"
	};
	int index = 0;//标记显示信息
	
	public MyPanel(pet pt){
	this.pt = pt;
	refresh();
	}
	@Override
	public void paint(Graphics g){
		g.setColor(Color.BLUE);
		g.setFont(new Font("隶书",Font.BOLD,30));
		g.drawString("1喂食", 120, 150);
		g.drawString("2洗澡", 120, 200);
		g.drawString("3打人", 120, 250);
		g.drawString("4亮相", 120, 300);
		/**
		 * *
		 */
		 
		
		 
		g.drawLine(50, 300, 750, 300);
		g.drawString("名字"+pt.name, 570, 150);
		g.drawString(pt.name+":"+ msgs[index],120, 350);
		
		/*int 饥饿 = 10;
		 int 清洁 = 1000000;
		 int 经验 = 10;*/
//TODO 
		g.drawString("饥饿" +pt.饥饿, 250, 450);
		 g.drawString("清洁" +pt. 清洁, 300, 500);
		 g.drawString("经验" +pt. 经验, 350, 550);
		
	}
	

	private void refresh(){
		new Timer().schedule(new TimerTask(){
			@Override
			public void run(){
				repaint();
			}
			},0,500);
		}
	
	public void keyPressed(KeyEvent e) {
		// TODO Auto-generated method stub
		char in = e.getKeyChar();
		if(in =='1'){
			pt.饥饿+=30;
			if(pt.饥饿>=100){
				pt.饥饿 =100;
				index = 2;
				
			}else{
				index = 1;
			}
			//index = 1;
			repaint();
		}else if(in =='2'){
			index =3;
			repaint();
		}else if(in =='3'){
			index =4;
			repaint();
		}else if(in =='4'){
			index =5;
			repaint();
			}
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


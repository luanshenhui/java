package com.yulin.pm;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
public class MyPanel extends Panel implements KeyListener{
	private pet pt;
	String[] msgs ={
		" ","����","��ι�ͷ���",  "�Ұ�ϴ��","����"
	};
	int index = 0;//�����ʾ��Ϣ
	
	public MyPanel(pet pt){
	this.pt = pt;
	refresh();
	}
	@Override
	public void paint(Graphics g){
		g.setColor(Color.BLUE);
		g.setFont(new Font("����",Font.BOLD,30));
		g.drawString("1ιʳ", 120, 150);
		g.drawString("2ϴ��", 120, 200);
		g.drawString("3����", 120, 250);
		g.drawString("4����", 120, 300);
		/**
		 * *
		 */
		 
		
		 
		g.drawLine(50, 300, 750, 300);
		g.drawString("����"+pt.name, 570, 150);
		g.drawString(pt.name+":"+ msgs[index],120, 350);
		
		/*int ���� = 10;
		 int ��� = 1000000;
		 int ���� = 10;*/
//TODO 
		g.drawString("����" +pt.����, 250, 450);
		 g.drawString("���" +pt. ���, 300, 500);
		 g.drawString("����" +pt. ����, 350, 550);
		
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
			pt.����+=30;
			if(pt.����>=100){
				pt.���� =100;
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


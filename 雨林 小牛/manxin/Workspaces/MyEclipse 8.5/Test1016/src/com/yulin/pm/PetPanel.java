package com.yulin.pm;
import java.awt.*;
import java.awt.event.*;
import java.util.*;


public class PetPanel extends Panel implements KeyListener{

	private Pet pet;
	String[] mags={
			"","吃····","撑死了~","洗澡中···","我已经洗的很干净了~","我已经很开心了"
			,"玩耍中~！","脏死了~！","我要离家出走","再打我啊"
	};
	int index=0;
	
	public PetPanel(Pet pet){
		this.pet=pet;
		refresh();
	}
	
	public void paint(Graphics g){
		g.setColor(Color.black);
		g.setFont(new Font("隶书",Font.BOLD,18));
		g.drawString("您想干什么",100, 100);
		g.drawString("1.喂食",100, 130);
		g.drawString("2.洗澡",100, 160);
		g.drawString("3.玩耍",100, 190);
		g.drawString("4.打我",100, 220);
		//g.drawString("5.查看信息",100, 250);
		g.drawLine(50, 280, 500, 280);
		
		g.drawRect(550, 100, 200, 400);//显示宠物信息
		g.setFont(new Font("隶书",Font.CENTER_BASELINE,13));
		g.drawString("姓名："+pet.name, 570, 120);
		g.drawString("年龄："+pet.age, 570, 140);
		g.drawString("饱食度："+pet.an, 570, 160);
		g.drawString("心情："+pet.heart, 570, 180);
		g.drawString("清洁："+pet.clene, 570, 200);
		g.drawString("叛逆："+pet.panni, 570, 220);
		
		g.drawString(pet.name+"："+mags[index], 100, 310);
	}
	private void refresh(){
		new Timer().schedule(new TimerTask(){
			@Override
			public void run(){
				repaint();
			}
		},0,500);
	}
	
	@Override
	public void keyPressed(KeyEvent e) {//键盘按下的事件
		char in = e.getKeyChar();
		if(in=='1'){//喂食
			pet.an +=30;
			if(pet.an>=100){
				pet.an=100;
				index=2;
			}
			else{
				 index=1;
			}
			
			repaint();
		}
		if(in=='2'){//洗澡
			pet.clene +=30;
			pet.an-=10;
			pet.heart+=10;
			if(pet.an>=0){
				if(pet.clene>=100){
					pet.clene=100;
					index=4;
				}
				else{
					index=3;
				}	
				//repaint();
			}else{
			index=1;
		    }
		   repaint();
		}
		if(in=='3'){//玩耍
			pet.heart +=30;
			pet.an-=10;
			pet.clene-=10;
			//if(pet.an>0){
				//if(pet.clene>0){
					if(pet.heart>=100){
					pet.heart=100;
					index=6;
					//}
				}else{
				 index=7;
				}
			
			//repaint();
		/*}else{
			index=7;
		}*/
			repaint();
		}
		
		if(in=='4'){//打
			pet.heart -=30;
			pet.panni+=30;
	
			if(pet.an>0){
				if(pet.heart>0){
					index=10;
					}
				}else if(pet.panni>=100){
					pet.panni=100;
				   index=9;
				}
			
			//repaint();
		}
			repaint();
		}
	
//	}	
	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}


}

package Pet;
import java.awt.*;
import java.awt.event.*;
import java.util.*;

public class PetPanel extends Panel implements KeyListener{
	
	private Pet pet;
	String[] mass = {"","�ԡ�������","������~","ϴ���С�����","���Ѿ�ϴ�ĺܸɾ���~","���Ѿ��ܿ�����"
			,"��ˣ��~��","������~��","��Ҫ��ҳ���","�ٴ��Ұ�"
		};
	private int index = 0;
	public PetPanel(Pet pet){
		this.pet = pet;
		resh();
	}
	
	public void paint(Graphics g){
		g.setColor(Color.black);
		g.setFont(new Font("����",Font.BOLD,30));
		g.drawString("�����ʲô",100, 100);
		g.drawString("1.ιʳ",100, 130);
		g.drawString("2.ϴ��",100, 160);
		g.drawString("3.��ˣ",100, 190);
		g.drawString("4.����",100, 220);
		g.drawLine(50, 280, 500, 280);
		
		g.drawRect(550, 100, 200, 400);
		g.setFont(new Font("����",Font.CENTER_BASELINE,13));
		g.drawString("������"+pet.name, 570, 120);
		g.drawString("���䣺"+pet.age, 570, 140);
		g.drawString("��ʳ�ȣ�"+pet.jie, 570, 160);
		g.drawString("���飺"+pet.heart, 570, 180);
		g.drawString("��ࣺ"+pet.qingjie, 570, 200);
		g.drawString("���棺"+pet.panni, 570, 220);
		
		g.drawString(pet.name+":"+mass[index], 100, 310);
	}
	
	private void resh(){
		new Timer().schedule(new TimerTask(){
			@Override
			public void run(){
				repaint();
			}
		},0,500);
	}

	@Override
	public void keyPressed(KeyEvent e) {
		// ���̰��´������¼�
		char in = e.getKeyChar();
		if(in == '1'){
			pet.jie += 20;
			if(pet.jie >= 100){
				pet.jie = 100;
				index = 2;
			}else{
				index = 1;
			}
			repaint();
		}
		if(in == '2'){
			pet.qingjie += 20;
			pet.jie -= 10;
			pet.heart += 30;
			if(pet.jie > 0){
				if(pet.qingjie >= 100 || pet.heart >= 100){
					pet.qingjie = 100;
					pet.heart = 100;
					index = 4;
				}else{
					index = 3;
				}
			}else{
				index = 1;
			}
			repaint();
		}
		if(in == '3'){
			pet.heart += 20;
			pet.jie -=10;
			pet.qingjie -= 10;
			if(pet.jie > 0){
				if(pet.heart >= 100){
					pet.heart = 100;
					index = 5;
				}else{
					index = 6;
				}
			}
			repaint();
		}
		if(in == '4'){
			pet.panni += 20;
			pet.heart -= 10;
			if(pet.panni >= 100){
				pet.panni = 100;
				index = 8;
			}else{
				index = 9;
			}
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

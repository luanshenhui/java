package com.yulin.am;

import java.util.*;
public class Pet {

	/**
	 * @param args
	 */
	public String name;
	public int age;
	//�ɳ����顢��������ࡢ���顢����
	private int level=0;//���� 100�㳤һ�� �Զ�����
	private int an=50;//���� 0~100
	private int heart=50;//���� 0~100 С��0 ���������½�
	private int clene=50;//��� 0~100 С��0��ҳ���
	private int panni=50;//����0~100 С��0 ҧ��
	
	public Pet(String name){
		this.name=name;
		age=0;
		System.out.println("�����ѵ���~��");
		this.chengZhang();
	}
	private void chengZhang(){//�ɳ�
		new Timer().schedule(new TimerTask(){
			@Override
			public void run(){
				level+=10;
				if(level>=100){
					age+=1;
					level=0;
				}
				an-=10;
				if(an<=0){
					System.out.println("������~��");
					System.out.println("Game Over~!");
					System.exit(0);
				}
				clene-=10;
				if(clene<=0){
					System.out.println("������~����ϴ��");
					System.out.println("Game Over~!");
					System.exit(0);
				}
				heart-=10;
				if(heart<=0){
					System.out.println("��Ҫ��ҳ���~��");
					System.out.println("Game Over~!");
					System.exit(0);
				}
			}
		}, 30000,10000);//�ӳ�3000����֮��ÿ��1000��������һ��run()
	}
	
	public void showM(){//��ʾ��Ϣ
		System.out.println("���֣�"+name);
		System.out.println("���䣺"+age);
		System.out.println("������"+an);
		System.out.println("���飺"+heart);
		System.out.println("��ࣺ"+clene);
		System.out.println("���棺"+panni);
	}
	public void eatM(){//ιʳ
		an+=30;//��ͬ�ڼ���+30
		heart+=10;
		if(an>=100){
			an=100;
			System.out.println(name+":������ιʳ��~Ҫ�����ˣ�");
		}
		else if(heart>=100)
		{
			heart=100;
		}
		else{
			System.out.println(name+"���ڽ�ʳ~��");
		}
	}
	
	public void qingJie(){//���
		clene+=10;
		heart+=10;
		an-=10;
		if(clene>=100 && an>0){
			clene=100;
			System.out.println(name+"�Ѿ�ϴ�ĺܸɾ���~��");
		}else if(an<=0){
		
				System.out.println("�����ˣ�������ϴ����~��");
				System.out.println("Game Over~!");
				System.exit(0);
			   
			
		}
		else if(heart>=100)
		{
			heart=100;
		}
		else{
			
			System.out.println(name+"����ϴ����");
		}
	}
	
	public void play(){//��ˣ
		heart+=10;
		an-=10;
		clene-=10;
		if(heart>=100){
			heart=100;
			System.out.println(name+"�Ѿ���ĺܿ�����~��");
		}
		else if(an<=0){
			System.out.println("�����ˣ�����������~��");
			System.out.println("Game Over~!");
			System.exit(0);
		}
		else if(clene<=0){
			System.out.println("�����ˣ�����������~��");
			System.out.println("Game Over~!");
			System.exit(0);
		}
		else{
			System.out.println("������ˣ��~��");
		}
			
	
	}
	
	public void da(){//��
		heart-=10;
		panni+=10;
		if(panni>=100){
			System.out.println(name+"�ٴ��ң���ҧ����~��");
			System.out.println("Game Over!~");
			System.exit(0);
		}
		else if(heart<=0){
			System.out.println(name+"��Ҫ��ҳ���~��");
			System.out.println("Game Over~!");
			System.exit(0);
		}
		else{
			System.out.println("�б������ٴ��Ұ�~��");
		}
	}
	


}

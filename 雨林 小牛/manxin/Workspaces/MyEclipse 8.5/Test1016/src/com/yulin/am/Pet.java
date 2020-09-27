package com.yulin.am;

import java.util.*;
public class Pet {

	/**
	 * @param args
	 */
	public String name;
	public int age;
	//成长经验、饥饿、清洁、心情、叛逆
	private int level=0;//经验 100点长一岁 自动生长
	private int an=50;//饥饿 0~100
	private int heart=50;//心情 0~100 小于0 心情叛逆下降
	private int clene=50;//清洁 0~100 小于0离家出走
	private int panni=50;//叛逆0~100 小于0 咬死
	
	public Pet(String name){
		this.name=name;
		age=0;
		System.out.println("宠物已诞生~！");
		this.chengZhang();
	}
	private void chengZhang(){//成长
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
					System.out.println("饿死了~！");
					System.out.println("Game Over~!");
					System.exit(0);
				}
				clene-=10;
				if(clene<=0){
					System.out.println("脏死了~！快洗澡");
					System.out.println("Game Over~!");
					System.exit(0);
				}
				heart-=10;
				if(heart<=0){
					System.out.println("我要离家出走~！");
					System.out.println("Game Over~!");
					System.exit(0);
				}
			}
		}, 30000,10000);//延迟3000毫秒之后，每隔1000毫秒运行一次run()
	}
	
	public void showM(){//显示信息
		System.out.println("名字："+name);
		System.out.println("年龄："+age);
		System.out.println("饥饿："+an);
		System.out.println("心情："+heart);
		System.out.println("清洁："+clene);
		System.out.println("叛逆："+panni);
	}
	public void eatM(){//喂食
		an+=30;//等同于饥饿+30
		heart+=10;
		if(an>=100){
			an=100;
			System.out.println(name+":不能再喂食了~要撑死了！");
		}
		else if(heart>=100)
		{
			heart=100;
		}
		else{
			System.out.println(name+"正在进食~！");
		}
	}
	
	public void qingJie(){//清洁
		clene+=10;
		heart+=10;
		an-=10;
		if(clene>=100 && an>0){
			clene=100;
			System.out.println(name+"已经洗的很干净了~！");
		}else if(an<=0){
		
				System.out.println("饿死了！不能再洗澡了~！");
				System.out.println("Game Over~!");
				System.exit(0);
			   
			
		}
		else if(heart>=100)
		{
			heart=100;
		}
		else{
			
			System.out.println(name+"正在洗澡中");
		}
	}
	
	public void play(){//玩耍
		heart+=10;
		an-=10;
		clene-=10;
		if(heart>=100){
			heart=100;
			System.out.println(name+"已经玩的很开心了~！");
		}
		else if(an<=0){
			System.out.println("饿死了！不能再玩了~！");
			System.out.println("Game Over~!");
			System.exit(0);
		}
		else if(clene<=0){
			System.out.println("脏死了！不能再玩了~！");
			System.out.println("Game Over~!");
			System.exit(0);
		}
		else{
			System.out.println("正在玩耍中~！");
		}
			
	
	}
	
	public void da(){//打
		heart-=10;
		panni+=10;
		if(panni>=100){
			System.out.println(name+"再打我！我咬死你~！");
			System.out.println("Game Over!~");
			System.exit(0);
		}
		else if(heart<=0){
			System.out.println(name+"我要离家出走~！");
			System.out.println("Game Over~!");
			System.exit(0);
		}
		else{
			System.out.println("有本事你再打我啊~！");
		}
	}
	


}

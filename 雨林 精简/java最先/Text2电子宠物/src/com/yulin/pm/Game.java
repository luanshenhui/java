package com.yulin.pm;

import java.util.Scanner;



public class Game {
public static void main(String[] args){
	
	System.out.println("开始游戏");
	System.out.println("输入民");
	Scanner sc = new Scanner(System.in);// 创建扫描工具
	String name = sc.next();//
	pet pt = new pet(name);
	
	
	
	
	MyFrame mf =new MyFrame();
	MyPanel mp =new MyPanel(pt);
	mf.add(mp);
	mf.show();
	
	mp.addKeyListener(mp);
	mf.addKeyListener(mp);
}
}

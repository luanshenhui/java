package com.yulin.pm;

import java.util.Scanner;



public class Game {
public static void main(String[] args){
	
	System.out.println("��ʼ��Ϸ");
	System.out.println("������");
	Scanner sc = new Scanner(System.in);// ����ɨ�蹤��
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

package com.b;

import java.util.List;

public class Client {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Com com=new Com("����","IBM");
		
		com.add(new Men("����","��",30));
		com.add(new Men("����","��",50));
		com.add(new Men("����","Ů",40));
		//com.add(new Men("�߰�","��",90));
		com.add("����","��",60);
//		com.add("����","Ů",20);
		
		com.printAll();
		
		//�������50���ϵ�Ա������
		List<Men>list=com.findByAge(50);
		for(Men m:list){
			System.out.println(m);
		}
		
		Men men=com.findByMen("����",50);
		System.out.println("��"+men);
		
		com.updateMen("����",33);
		com.printAll();

	}

}

package com.b;

import java.util.List;

public class Client {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Com com=new Com("大连","IBM");
		
		com.add(new Men("张三","男",30));
		com.add(new Men("王五","男",50));
		com.add(new Men("李四","女",40));
		//com.add(new Men("七八","男",90));
		com.add("赵六","男",60);
//		com.add("刘二","女",20);
		
		com.printAll();
		
		//输出年龄50以上的员工集合
		List<Men>list=com.findByAge(50);
		for(Men m:list){
			System.out.println(m);
		}
		
		Men men=com.findByMen("王五",50);
		System.out.println("是"+men);
		
		com.updateMen("张三",33);
		com.printAll();

	}

}

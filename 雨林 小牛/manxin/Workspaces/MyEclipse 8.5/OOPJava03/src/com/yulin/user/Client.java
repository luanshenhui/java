package com.yulin.user;

public class Client {
	public static void main(String[] args){
		Sys s = new Sys();
		s.regist();
		
		System.out.println(s.getUserList()[0].getUserName());
		System.out.println(s.getUserList()[0].getPassWord());
	}
}

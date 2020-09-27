package com.yulin.web.service;

import com.yulin.web.dao.*;
import com.yulin.web.entity.*;

public class UserService {
	private UserDao ud;

	public UserService() {
		ud = new UserDao();
	}
	
	/*登录*/
	public User Ligon(String id, String pwd){
		User u = ud.Login(id, pwd);
		return u;
	}
	
	/*注册*/
	public boolean regist(String id,String pwd,String name,String sex,int age,String email,
			String phone,String city){
		User u = new User(id,pwd,name,sex,age,email,phone,city);
		boolean bo = ud.regist(u);
		return bo;
	}
	
	/*修改*/
	public boolean Update(String id,String pwd,String name,String sex,int age,String email,
			String phone,String city){
		User u = new User(id, pwd, name, sex, age, phone, email, city);
		boolean bo = ud.Update(u);
		return bo;
	}
	
	public static void main(String[] args) {
		UserService us = new UserService();
		System.out.println();
	}
	//用户的操作。登录、注册、修改个人信息
}

package com.yulin.web.service;

import java.util.List;

import com.yulin.web.dao.UserDao;
import com.yulin.web.entity.User;

public class UserService {
	private UserDao ud;
	private List<User> list;
	
	public UserService(){
		ud = new UserDao();
	}
	//用户的操作，登录，注册，修改个人的信息。
	public User login(String loginid , String pwd){
//		if("".equals(loginid)||loginid==null||"".equals(pwd)||pwd==null){
//			return null;
//		}else{
			User u = ud.login(loginid, pwd);
			return u;
//		}
	}
	public boolean regist(String loginid,String pwd,String name){
		
		return ud.regist(new User(loginid,pwd,name));
	}
	public boolean update(String loginid,String pwd,String name,int salary,int age){
		User u = new User(loginid,pwd,name,salary,age);
		return ud.update(u);
	}
	public List<User> findAll(){
		return ud.findAll();
	}
	public static void main(String[] args) {
		UserService us = new UserService();
//		System.out.println(us.regist("11", "11", "11"));
		System.out.println(us.login("11","11"));
		
	}
}

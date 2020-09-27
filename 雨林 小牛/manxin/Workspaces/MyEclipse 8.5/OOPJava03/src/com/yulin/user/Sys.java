package com.yulin.user;
import java.util.*;

public class Sys {
	/**
	 * 系统：保存User的信息，代替数据库操作
	 * 功能：注册、登录、查看
	 */
	private User[] userList;
	private UserService us;
	private User u;	//已登录的用户
	
	//无参数的构造
	public Sys(){
		userList = new User[0];
		us = new UserService();
	}
	
	//快捷键生成的set和get方法
	public User[] getUserList() {
		return userList;
	}

	public void setUserList(User[] userList) {
		this.userList = userList;
	}

	//注册
	public void regist(){
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入您的用户名：");
		String name = scan.next();
		System.out.println("请输入您的密码：");
		String pwd = scan.next();
		
		User u = new User();
		u.setName(name);
		u.setPassWord(pwd);
		us.regise(u,this);	//this指代当前对象
	}
	
	//登录
	public void login(){}
	
	//查看
	public void look(){}

}

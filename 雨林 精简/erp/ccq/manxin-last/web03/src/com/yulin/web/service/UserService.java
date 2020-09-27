package com.yulin.web.service;

import java.util.ArrayList;

import com.yulin.web.dao.UserDao;
import com.yulin.web.entity.User;

public class UserService {
	private UserDao ud;
	
	public UserService(){
		ud = new UserDao();
	}

	public boolean regist(String loginId, String pwd, String name) {
		//验证loginId是否存在，如果存在，直接返回false
		return ud.regist(new User(loginId, pwd, name, 0, 0));
	}

	public User login(String loginId, String pwd) {
		return ud.login(loginId, pwd);
	}
	
	public ArrayList<User> getAll(){
		return (ArrayList<User>)ud.findAll();
	}
	//用户的操作。登录、注册、修改个人信息。
	public User findById(String id){
		return ud.findById(id);
	}

	public void update(String loginId, String name, int salary, int age) {
		ud.update(loginId, name, salary, age);
	}
}

package com.yulin.web.service;

import java.util.List;

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
	public boolean regist(String id,String pwd,String name){
		//验证loginid是否存在，如果存在，直接返回false
		User u = new User(id,pwd,name);
		boolean bo = ud.regist(u);
		return bo;
	}
	
	public boolean insert(String id,String pwd,String name,int salary,int age){
		User u = new User(id, pwd, name, salary, age);
		return ud.regist(u);
	}
	
	/*修改*/
	public boolean Update(String id,String pwd,String name,int salary,int age){
		User u = new User(id, pwd, name, salary, age);
		boolean bo = ud.Update(u);
		return bo;
	}
	
	/*查找所有*/
	public List<User> findAll(){
		return ud.findAll();
	}
	
	/*通过Id查找*/
	public List<User> findById(String id){
		return ud.findById(id);
	}
	
	/*删除*/
	public boolean Delete(String id){
		User u = new User();
		u.setLoginId(id);
		if(ud.Delete(u)){
			return true;
		}else{
			return false;
		}
	}
	
	/**/
//	public User insert(String id,String pwd,String name,int salary,int age){}
	
	public static void main(String[] args) {
		UserService us = new UserService();
//		System.out.println(us.regist("11", "11", "11"));
//		System.out.println(us.insert("33", "33", "33", 3, 3));
//		System.out.println(us.Delete("1"));
//		System.out.println(us.Update("44", "44", "55", 5, 5));
	}

	
}

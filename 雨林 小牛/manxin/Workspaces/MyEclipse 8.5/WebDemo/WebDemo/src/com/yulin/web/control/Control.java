//package com.yulin.web.control;
//
//import com.yulin.web.dao.*;
//import com.yulin.web.entity.*;
//import com.yulin.web.service.*;
//
//public class Control {
//	private User user = new User();
//	private UserService userService = new UserService();
//	private UserDao userDao = new UserDao();
//	
//	/*get set方法*/
//	public User getUser() {
//		return user;
//	}
//	public void setUser(User user) {
//		this.user = user;
//	}
//	public UserService getUserService() {
//		return userService;
//	}
//	public void setUserService(UserService userService) {
//		this.userService = userService;
//	}
//	public UserDao getUserDao() {
//		return userDao;
//	}
//	public void setUserDao(UserDao userDao) {
//		this.userDao = userDao;
//	}
//	/*登录*/
//	public boolean Login(String id, String pwd){
//		User u = userService.Ligon(id, pwd);
//		if(u != null){
//			return true;
//		}else{
//			return false;
//		}
//	}
//	/*注册*/
//	public boolean Regist(String id,String pwd,String name,int salary,int age){
//		return userService.regist(id, pwd, name, salary, age);
//	}
//	
//	/*修改*/
//	public boolean Update(String id,String pwd,String name,int salary,int age){
//		return userService.Update(id, pwd, name, salary, age);
//	}
//}

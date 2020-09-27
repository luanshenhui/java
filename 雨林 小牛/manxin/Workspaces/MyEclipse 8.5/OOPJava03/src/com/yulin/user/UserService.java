package com.yulin.user;

import java.util.Arrays;

public class UserService {
	/**
	 * ²Ù×÷UserÀà
	 * ×¢²á
	 * 
	 * µÇÂ¼
	 */
	//×¢²á
	public void regise(User u,Sys s){
		User[] us = s.getUserList();
		us = Arrays.copyOf(us, us.length + 1);
		us[us.length - 1] = u;
		s.setUserList(us);
	}
	
	//µÇÂ¼
	public User login(){
		
		return null;
	}
}

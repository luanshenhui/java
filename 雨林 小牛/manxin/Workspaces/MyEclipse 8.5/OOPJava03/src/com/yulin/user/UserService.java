package com.yulin.user;

import java.util.Arrays;

public class UserService {
	/**
	 * ����User��
	 * ע��
	 * 
	 * ��¼
	 */
	//ע��
	public void regise(User u,Sys s){
		User[] us = s.getUserList();
		us = Arrays.copyOf(us, us.length + 1);
		us[us.length - 1] = u;
		s.setUserList(us);
	}
	
	//��¼
	public User login(){
		
		return null;
	}
}

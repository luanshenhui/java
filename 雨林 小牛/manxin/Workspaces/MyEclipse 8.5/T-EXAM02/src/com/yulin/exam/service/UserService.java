package com.yulin.exam.service;

import com.yulin.exam.bean.User;
import com.yulin.exam.dao.UserDao;

public class UserService {

	UserDao ud = new UserDao();
	public User login(String loginId, String pwd) {
		// ��¼
		if("".equals(loginId) || loginId == null || "".equals(pwd) || pwd == null){
			return null;
		}else{
			User u = ud.findUser(loginId, pwd);
			return u;
		}
	}
	
	public boolean regist(String loginId,String pwd,String pwd2,String name,String email){
		//ע��
		if(pwd.equals(pwd2)){
			User u = new User(loginId,pwd,name,-1,email);
			return ud.insertUser(u);
		}
		return false;
	} 

}

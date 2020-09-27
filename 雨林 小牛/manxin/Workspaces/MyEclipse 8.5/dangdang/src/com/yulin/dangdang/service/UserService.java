package com.yulin.dangdang.service;

import java.util.Random;

import com.yulin.dangdang.bean.User;
import com.yulin.dangdang.dao.daoimpl.UserDaoImpl;

public class UserService {
	UserDaoImpl ud = new UserDaoImpl();
	public User regist(String email, String nickname, String pwd){
		//注册时创建的User对象
		if(checkRegist(email, nickname, pwd)){
			User u = new User(0, email, nickname, pwd, 'n');
			String code = new Random().nextInt(99999) + "";
			u.setEmail_verify_code(code);
			return new UserDaoImpl().insert(u);//成功注册后返回user
		}else{
			return null;
		}
	}
	
	public User login(String email, String pwd){
		User u = ud.findByLogin(email, pwd);
		return u;
	}

	public boolean checkRegist(String email, String nickname, String pwd) {
		/* 注册验证：
		 * 1.验证email是否存在
		 * 2.验证nickname和pwd是否合法，不能为null或者是“”
		 * 验证“”时，需要用到trim()
		 */
		boolean bo = ud.isExistByEmail(email);
		if(bo != false){
			if(pwd.trim() != null && nickname.trim() != null && pwd.trim() != "" && nickname.trim() != ""){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	
	public boolean updateCode(String email){
		
		return ud.updateCode(email);
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

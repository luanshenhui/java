package com.yulin.am;

import java.io.IOException;
import java.util.ArrayList;

public class UserService {
	private static String userDataPath = "src/user.data";
	public User login(String id, String pwd){
		ArrayList<String> list = null;
		try {
			list = FileUtil.read(userDataPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		for(String s : list){
			String[] ss = s.split("#");
			//第一个元素和第二个元素分别是用户名和密码，用这两个信息来进行比较
			if(id.equals(ss[0]) && pwd.equals(ss[1])){
				User u = new User(ss[0], ss[1], ss[2], ss[3]);
				return u;
			}
		}
		return null;
	}
	
	public boolean regist(String id,String pwd1,String pwd2
			, String name, String email){
		if(checkID(id) && checkPWD(pwd1, pwd2)){
			String context = id+"#"+pwd1+"#"+name+"#"+email;
			try {
				FileUtil.write("src/user.data", context);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return true;
		}else{
			return false;
		}
	}

	private boolean checkPWD(String pwd1, String pwd2) {
		// TODO Auto-generated method stub
		return false;
	}

	private boolean checkID(String id) {
		// TODO Auto-generated method stub
		return false;
	}
}

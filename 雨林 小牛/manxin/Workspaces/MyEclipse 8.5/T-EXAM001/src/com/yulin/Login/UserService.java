package com.yulin.Login;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

import javax.swing.JOptionPane;

public class UserService {
	/**
	 * 业务层
	 */
	private static String pathData = "src/User.data";
	private static String scorePath = "src/score.data";
	public User login(String id, String pwd){
		ArrayList<String> list = null;
		try {
			list = FileUtil.read(pathData);
		} catch (IOException e) {
			e.printStackTrace();
		}
		for(String s : list){
			String[] str = s.split("#");
			if(id.equals(str[0]) && pwd.equals(str[1])){
				User u = new User(str[0],str[1],str[2],str[3]);
				u.setScore(getScore(str[0]));//给得分属性赋值
				return u;
			}
		}
		return null;
	}
	
	private int getScore(String id) {
		// 获得登录用户的得分情况
		try {
			ArrayList<String> list = FileUtil.read(scorePath);
			for(String s : list){
				String[] ss = s.split("#");
				if(id.equals(ss[0])){
					return Integer.parseInt(ss[2]);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return -1;
	}

	public boolean regist(String id,String pwd1,String pwd2,String name,String email){
		if(checkID(id) && checkPWD(pwd1,pwd2) && checkEmail(email)){
			String context = id + "#" + pwd1 + "#" + name + "#" + email;// + pwd2 + "#"
			try {
				FileUtil.write(pathData, context);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return true;
		}else{
			return false;
		}
	}
	

	private boolean checkID(String id) {
		// 验证用户名
		ArrayList<String> list = null;
		try {
			list = FileUtil.read(pathData);
		} catch (IOException e) {
			e.printStackTrace();
		}
		for(String s : list){
			String[] str = s.split("#");
			if(id.equals(str[0])){
				return false;
			}
		}
		return true;
	}
	
	private boolean checkPWD(String pwd1, String pwd2) {
		// 验证密码
		return pwd1.equals(pwd2);
	}
	private boolean checkEmail(String email) {
		// 验证邮箱
		return email.matches("^[a-zA-Z_][a-zA-Z0-9_$]+@.+[([.][c][o][m])||([.][c][n])]");
	}

	public ArrayList<String> getUserAnswer(String loginId) {
		// 获得用户答案
		ArrayList<String> list = new ArrayList<String>();
		try {
			ArrayList<String> strs = FileUtil.read(scorePath);
			for(String s : strs){
				String[] ss = s.split("#");
				if(ss[0].equals(loginId)){
					for(String us : ss[3].split(" ")){
						list.add(us);
					}
					//用户答案
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}
}

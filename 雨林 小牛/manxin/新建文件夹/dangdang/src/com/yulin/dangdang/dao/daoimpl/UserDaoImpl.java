package com.yulin.dangdang.dao.daoimpl;

import java.util.*;

import org.apache.ibatis.session.SqlSession;

import com.yulin.dangdang.bean.User;
import com.yulin.dangdang.common.MyBatisUtil;
import com.yulin.dangdang.dao.UserDao;

public class UserDaoImpl implements UserDao{
	private String namespace = "com.yulin.userMapping";
	
	@Override
	public boolean deleUser(int id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public User findByLogin(String email, String pwd) {
		User u = null;
		SqlSession session = MyBatisUtil.getSession();
		Map<String, String> map = new HashMap<String, String>();
		map.put("email", email);
		map.put("pwd", pwd);
		u = session.selectOne(namespace + ".findByLogin", map);
		return u;
	}

	@Override
	public User insert(User u) {
		SqlSession session = MyBatisUtil.getSession();
		int flag = session.insert(namespace + ".insert", u);
		session.commit();
		if(flag > 0){
			return u;
		}else{
			return null;
		}
	}

	@Override
	public boolean isExistByEmail(String email) {
		User u = null;
		SqlSession session = MyBatisUtil.getSession();
		Map<String, String> map = new HashMap<String, String>();
		map.put("email", email);
		u = session.selectOne(namespace + ".findByEmail", email);
		if(u == null){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public boolean updateUser(User u) {
		return false;
	}

	@Override
	public boolean updateCode(String email) {
		SqlSession session = MyBatisUtil.getSession();
		int flag = session.update(namespace+".updateCode", email);
		session.commit();
		return flag == 1;
	}

	public static void main(String[] args) {
		UserDao ud = new UserDaoImpl();
//		boolean flag = ud.insert(new User(0,"root@163.com","Moty","1234",'y'));
//		System.out.println(flag);
//		User u = ud.findByLogin("root@163.com", "1234");
//		System.out.println(u);
	}
}

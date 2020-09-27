package com.keda.wuye.biz.impl;

import java.util.List;
import java.util.Map;

import com.keda.wuye.biz.UserBiz;
import com.keda.wuye.dao.UserDao;
import com.keda.wuye.dao.impl.UserDaoImpl;
import com.keda.wuye.entity.User;
import com.opensymphony.xwork2.ActionContext;

public class UserBizImpl implements UserBiz {
	private UserDao userDao = new UserDaoImpl();
	public boolean login(String username, String password)
	{
		User user = userDao.getUser(username,password);
		User user1=userDao.getAdminUser(username, password);
		//如果用户名和密码都正确，即user不为空，返回true,否则返回false
		if( user != null||user1!=null)
			return true;
		else 
			return false;	
	}
	//查询，显示所有信息
	public List<User> getUser()
	{	
		Map<String, String> session=ActionContext.getContext().getSession();
		String admin=session.get("admin");
		System.out.println("admin:"+admin);
		List<User> list_user =null;
		if ("admin".equals(admin)) {
			 list_user = userDao.getUser();
		}
		return list_user;
	}
	//查询，显示所有信息
	public List<User> select(String s)
	{
		List<User> list_user = userDao.select(s);
		return list_user;
	}
	//判断用户名是否重复
	public boolean nameEqual(String username)
	{
		boolean b = userDao.nameEqual(username);
		return b;
	}
	//注册添加
	public void insert(String username,String password)
	{
		userDao.insert(username, password);
	}
	//删除
	public void delete(String username)
	{
		userDao.delete(username);
	}
	//修改
	public void update(String username,String password)
	{
		userDao.update(username, password);
	}
	//查询一条信息
	public User getUser(String username)
	{
		User user = userDao.getUser(username);
		return user;
	}
}

package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.User;

public interface UserBiz {

	boolean login(String username, String password);
	//查询，显示所有信息
	public List<User> getUser();
	//判断用户名是否重复
	public boolean nameEqual(String username);
	//注册添加
	public void insert(String username,String password);
	//删除
	public void delete(String username);
	//修改
	public void update(String username,String password);
	//查询一条信息
	public User getUser(String username);
	//查询，显示所有信息
	public List<User> select(String s);
	
}

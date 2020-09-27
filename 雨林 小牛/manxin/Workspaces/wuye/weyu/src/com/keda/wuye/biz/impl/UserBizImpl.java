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
		//����û��������붼��ȷ����user��Ϊ�գ�����true,���򷵻�false
		if( user != null||user1!=null)
			return true;
		else 
			return false;	
	}
	//��ѯ����ʾ������Ϣ
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
	//��ѯ����ʾ������Ϣ
	public List<User> select(String s)
	{
		List<User> list_user = userDao.select(s);
		return list_user;
	}
	//�ж��û����Ƿ��ظ�
	public boolean nameEqual(String username)
	{
		boolean b = userDao.nameEqual(username);
		return b;
	}
	//ע�����
	public void insert(String username,String password)
	{
		userDao.insert(username, password);
	}
	//ɾ��
	public void delete(String username)
	{
		userDao.delete(username);
	}
	//�޸�
	public void update(String username,String password)
	{
		userDao.update(username, password);
	}
	//��ѯһ����Ϣ
	public User getUser(String username)
	{
		User user = userDao.getUser(username);
		return user;
	}
}

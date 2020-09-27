package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.User;

public interface UserBiz {

	boolean login(String username, String password);
	//��ѯ����ʾ������Ϣ
	public List<User> getUser();
	//�ж��û����Ƿ��ظ�
	public boolean nameEqual(String username);
	//ע�����
	public void insert(String username,String password);
	//ɾ��
	public void delete(String username);
	//�޸�
	public void update(String username,String password);
	//��ѯһ����Ϣ
	public User getUser(String username);
	//��ѯ����ʾ������Ϣ
	public List<User> select(String s);
	
}

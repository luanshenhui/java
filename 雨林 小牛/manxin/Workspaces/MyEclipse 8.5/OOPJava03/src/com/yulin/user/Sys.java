package com.yulin.user;
import java.util.*;

public class Sys {
	/**
	 * ϵͳ������User����Ϣ���������ݿ����
	 * ���ܣ�ע�ᡢ��¼���鿴
	 */
	private User[] userList;
	private UserService us;
	private User u;	//�ѵ�¼���û�
	
	//�޲����Ĺ���
	public Sys(){
		userList = new User[0];
		us = new UserService();
	}
	
	//��ݼ����ɵ�set��get����
	public User[] getUserList() {
		return userList;
	}

	public void setUserList(User[] userList) {
		this.userList = userList;
	}

	//ע��
	public void regist(){
		Scanner scan = new Scanner(System.in);
		System.out.println("�����������û�����");
		String name = scan.next();
		System.out.println("�������������룺");
		String pwd = scan.next();
		
		User u = new User();
		u.setName(name);
		u.setPassWord(pwd);
		us.regise(u,this);	//thisָ����ǰ����
	}
	
	//��¼
	public void login(){}
	
	//�鿴
	public void look(){}

}

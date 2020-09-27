package com.manxin.service;

import com.manxin.dao.DAO;
import com.manxin.dao.DAOImpl;

public class ServiceImpl implements Service{

	//以前实现的方法
//	private DAO dao = new DAOImpl();
	
	//依赖注入
	//依赖注入的方法
	//(1)构造器注入：构造方法的注入
	//(2)setter注入：setter方法注入
	private DAO dao;
	
	public DAO getDao() {
		return dao;
	}

	public void setDao(DAO dao) {
		this.dao = dao;
	}

	@Override
	public void add() {
		// TODO Auto-generated method stub
		dao.add();
	}

	@Override
	public void update() {
		// TODO Auto-generated method stub
		dao.update();
	}

}

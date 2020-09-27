package com.cost.Dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.junit.Ignore;
import org.junit.Test;

import com.cost.entity.Cost_Admin;

public class Admin_hibernate implements Cost_AdminDao{
	@SuppressWarnings("unchecked")
	@Test
	public Cost_Admin login(Cost_Admin admin){
		Session session = getSession();
		String sql = "from com.cost.entity.Cost_Admin where ADMIN_CODE = '" + admin.getAdmin_code() 
		+ "' and PASSWORD = '" + admin.getPassword() + "'";
		List<Cost_Admin> list = session.createQuery(sql).list();
		for(Cost_Admin a : list){
			admin = a;
		}
		return admin;
	}

	private Session getSession() {
		Configuration conf = new Configuration();
		conf.configure("/hibernate.cfg.xml");
		SessionFactory sf = conf.buildSessionFactory();
		Session session = sf.openSession();
		return session;
	}
	
	
}

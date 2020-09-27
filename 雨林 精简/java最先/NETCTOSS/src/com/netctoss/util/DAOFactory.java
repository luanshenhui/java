package com.netctoss.util;

import java.io.IOException;
import java.util.Properties;

import com.netctoss.cost.dao.CostDAOImpl;
import com.netctoss.cost.dao.ICostDAO;

public class DAOFactory {
	private static ICostDAO costdao=new CostDAOImpl();
	private static Properties p=new Properties();
	static{
		try {
			p.load(DAOFactory.class.getClassLoader()
					.getResourceAsStream("dao.properties"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static Object getInstance(String type){
		Object obj=null;
		try {
			Class c=Class.forName(p.getProperty(type));
			obj=c.newInstance();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return obj;
	}
	public static ICostDAO getCostDAO(){
		return costdao;
	}
	
}

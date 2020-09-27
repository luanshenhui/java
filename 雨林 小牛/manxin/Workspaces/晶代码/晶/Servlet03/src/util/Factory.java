package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import dao.EmpDAO;

public class Factory {
	private static Properties pro = new Properties();
	static {
		InputStream ips = Factory.class.getClassLoader().getResourceAsStream("util/factory.properties");
		try {
			pro.load(ips);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static Object getInstance(String type){
		Object obj = null;
		String className = pro.getProperty(type);
		try {
			Class c = Class.forName(className);
			obj = c.newInstance();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return obj;
	}
	public static void main(String[] args) {
		EmpDAO dao = (EmpDAO) getInstance("EmpDAO");
		System.out.println(dao);
	}
}

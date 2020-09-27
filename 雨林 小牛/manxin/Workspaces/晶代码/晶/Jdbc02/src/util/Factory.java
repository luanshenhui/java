package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import dao.UserDAOImpl;

public class Factory {
	private static Properties props = new Properties();
	static{
		InputStream ips = 
			Factory.class.getClassLoader().getResourceAsStream("util/factory.properties");
		try {
			props.load(ips);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
//	����������� ��һ��key�Ǹ�����  �Ϳ��Ի�ȡ�����·���Ķ���
	public static Object getIntance(String type){
		Object obj = null;
		  try {
			  String className = props.getProperty(type);
			  //ͨ��·���ҵ���
			Class c = Class.forName(className);
			//ͨ��������������
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
		UserDAOImpl dao = (UserDAOImpl)getIntance("UserDAO");
		System.out.println(dao);
	}
}

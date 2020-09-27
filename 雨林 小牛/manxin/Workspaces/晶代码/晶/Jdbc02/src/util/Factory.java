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
//	调用这个方法 传一个key那个参数  就可以获取后面的路径的对象
	public static Object getIntance(String type){
		Object obj = null;
		  try {
			  String className = props.getProperty(type);
			  //通过路径找到类
			Class c = Class.forName(className);
			//通过类来创建对象
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

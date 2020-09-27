package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Factory {
	private static Properties pro = new Properties();
	static{
		InputStream is = Factory.class.getClassLoader().getResourceAsStream("entity/Factory.properties");
		try {
			pro.load(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static Object getInstance(String type){
		Object ob = null;
		String className = pro.getProperty(type);
		try {
			Class c = Class.forName(className);
			ob = c.newInstance();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		return ob;
	}
}

package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Factory {
	private static Properties props = 
		new Properties();
	static{
		InputStream ips = 
			Factory.class.getClassLoader()
			.getResourceAsStream(
					"util/dao.properties");
		try {
			props.load(ips);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public static Object getInstance(String type){
		Object obj = null;
		//依据接口名称(type)找到类名
		String className = props.getProperty(type);
		System.out.println(className);
		try {
			Class c = Class.forName(className);
			//依据方法区中的class对象，创建
			//一个实例。
			obj = c.newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}
}

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
		//���ݽӿ�����(type)�ҵ�����
		String className = props.getProperty(type);
		System.out.println(className);
		try {
			Class c = Class.forName(className);
			//���ݷ������е�class���󣬴���
			//һ��ʵ����
			obj = c.newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}
}

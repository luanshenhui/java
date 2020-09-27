package test;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesTest {
	
	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		/*
		 * Properites�ྭ����.properties�ļ�һ��
		 * ������ɼ�������Ϣ�Ķ�ȡ��
		 */
		Properties props = new Properties();
		props.setProperty("username", "tom");
//		String username = props.getProperty("username");
//		System.out.println(username);
		InputStream ips = 
			PropertiesTest.class
			.getClassLoader()
			.getResourceAsStream(
					"test/config.properties");
		props.load(ips);
		String username = props.getProperty("username1");
		System.out.println(username);
		
		
	}

}

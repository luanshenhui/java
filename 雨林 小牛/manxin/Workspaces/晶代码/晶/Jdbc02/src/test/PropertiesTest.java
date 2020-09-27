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
		 * Properites类经常与.properties文件一起
		 * 用来完成简单配置信息的读取。
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

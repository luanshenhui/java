package com.yulin.tast;

import java.sql.*;
import java.util.*;
import java.io.*;

public class DBUtil {
	/*创建配置文件的连接*/
	public static Connection getConn(String fileName) throws IOException{
		File file = new File(fileName);
		FileInputStream fis = new FileInputStream(file);
		/*用来读取属性文件的类*/
		Properties pro = new Properties();
		/*加载*/
		pro.load(fis);
		/*通过key来获得value*/
		String url = pro.getProperty("url");
		String user = pro.getProperty("user");
		String pwd = pro.getProperty("pwd");
		Connection conn = null;
		
		try {
			/*利用反射机制加载一个类*/
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, user, pwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
}

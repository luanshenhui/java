package com.yulin.web.commen;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBUtil {
	private static String user="system";
	private static String pwd="1234";
	private static String url="jdbc:oracle:thin:@localhost:1521:xe";
//	static{
//		try {
//			FileInputStream fis = new FileInputStream(new File("src/cfg/database.properties"));//从外到内，输入流
//			Properties p = new Properties();
//			p.load(fis);
//			user =p.getProperty("user");
//			pwd =p.getProperty("pwd");
//			url =p.getProperty("url");
//		} catch (Exception e) {
//			
//			e.printStackTrace();
//		}
//	}
	public static Connection getConn(){
		Connection conn= null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url,user,pwd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return conn;
	}
	public static void main(String[] args) {
		System.out.println(DBUtil.getConn());
	}
}

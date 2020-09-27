package com.yulin.web.common;

import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBUtil {
	private static String user = "system";
	private static String pwd = "1234";
	private static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	/*static{
		try {
			FileInputStream fis = new FileInputStream(
					new File("database.properties"));
			Properties p = new Properties();
			p.load(fis);
			user = p.getProperty("user");
			pwd = p.getProperty("pwd");
			url = p.getProperty("url");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}*/
	public static Connection getConn(){
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, user, pwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
	public static void main(String[] args) {
		System.out.println(DBUtil.getConn());
	}
}







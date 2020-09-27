package com.yulin.web;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
	private static String name = "system";
	private static String pwd = "1234";
	private static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	
	public static Connection getConn(){
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url,name,pwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
	public static void main(String[] args) {
		System.out.println(getConn());
	}
}

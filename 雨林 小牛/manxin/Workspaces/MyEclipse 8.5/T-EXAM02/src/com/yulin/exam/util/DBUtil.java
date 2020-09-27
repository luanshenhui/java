package com.yulin.exam.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
	private static String name = "system";
	private static String pwd = "1234";
	private static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	
	public static Connection getConnection(){
		Connection conn = null;
		/* 1.注册驱动
		 * 2.建立连接
		 * 3.获取对象
		 * 4.执行SQL
		 * 5.处理结果
		 * 6.关闭连接
		 */
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url,name,pwd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
	
	public static void main(String[] args) {
		System.out.println(getConnection());
	}
}

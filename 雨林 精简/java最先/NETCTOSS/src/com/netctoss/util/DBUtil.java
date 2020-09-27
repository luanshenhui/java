package com.netctoss.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil {
	private static String user;
	private static String password;
	private static String url;
	private static String driver;
	private static Properties p=new Properties();
	private static ThreadLocal<Connection> threadpool=
		new ThreadLocal<Connection>();
	static{
		try {
			p.load(DBUtil.class.getClassLoader().
					getResourceAsStream("jdbc.properties"));
			user=p.getProperty("user");
			password=p.getProperty("password");
			url=p.getProperty("url");
			driver=p.getProperty("driver");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static Connection getConnection() {
		Connection conn=threadpool.get();
		if(conn==null){
			try {
				Class.forName(driver);
				conn=DriverManager.getConnection(url, user, password);
				threadpool.set(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
		return conn;

	}
	public static void closeConnection(){
		Connection conn=threadpool.get();
		if(conn!=null){
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				throw new RuntimeException("关闭失败");
			}
			threadpool.set(null);
		}
	}
	public static void main(String[] args) {
		System.out.println(p);
		System.out.println(getConnection());
	}
}

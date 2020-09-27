package com.cost.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil {
private static Properties pro = new Properties();
	
	static{
		InputStream ips = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
		try {
			pro.load(ips); 
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	private static String className = pro.getProperty("driver");
	private static String url = pro.getProperty("url");
	private static String user = pro.getProperty("name");
	private static String password = pro.getProperty("password");
	public static Connection getConnection(){
		Connection conn = null;
		try {
			Class.forName(className);
			conn = DriverManager.getConnection(url, user, password);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}
	
	public static void CloseConn(Connection conn){
		if(conn != null){
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void CloseStat(PreparedStatement stat){
		if(stat != null){
			try {
				stat.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void CloseRet(ResultSet rst){
		if(rst != null){
			try {
				rst.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	public static void main(String[] args) {
		System.out.println(DBUtil.getConnection());
	}
}

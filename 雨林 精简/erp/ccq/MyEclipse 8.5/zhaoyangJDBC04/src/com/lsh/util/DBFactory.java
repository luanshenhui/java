package com.lsh.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/*
 * 数据库工厂类：提供连接，关闭连接
 */
public final class DBFactory {
	private static final String DRIVER="org.gjt.mm.mysql.Driver";
	//常量是大写
	private static final String URL="jdbc:mysql://127.0.0.1:3306/luan";
	private static final String USERNAME="root";
	private static final String PASSWORD="12345";
	/**
	 * java中工具类的特征
	 * (1)finally
	 * (2)private构造
	 * (3)static方法
	 */
	private DBFactory(){
		//不用嘴说，告人直接类点，不能new
	}
	// 打开连接
	public static Connection openConnection() {
		Connection conn=null;
		try {
			Class.forName(DRIVER);
			conn=DriverManager.getConnection(URL,USERNAME,PASSWORD);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	

		return conn;

	}

	public static void closeConnection(Connection conn) {
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}

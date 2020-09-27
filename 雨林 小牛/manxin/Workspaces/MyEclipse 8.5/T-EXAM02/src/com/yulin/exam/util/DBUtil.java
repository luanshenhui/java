package com.yulin.exam.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
	private static String name = "system";
	private static String pwd = "1234";
	private static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	
	public static Connection getConnection(){
		Connection conn = null;
		/* 1.ע������
		 * 2.��������
		 * 3.��ȡ����
		 * 4.ִ��SQL
		 * 5.������
		 * 6.�ر�����
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

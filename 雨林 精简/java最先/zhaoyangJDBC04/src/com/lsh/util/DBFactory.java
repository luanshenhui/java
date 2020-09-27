package com.lsh.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/*
 * ���ݿ⹤���ࣺ�ṩ���ӣ��ر�����
 */
public final class DBFactory {
	private static final String DRIVER="org.gjt.mm.mysql.Driver";
	//�����Ǵ�д
	private static final String URL="jdbc:mysql://127.0.0.1:3306/luan";
	private static final String USERNAME="root";
	private static final String PASSWORD="12345";
	/**
	 * java�й����������
	 * (1)finally
	 * (2)private����
	 * (3)static����
	 */
	private DBFactory(){
		//������˵������ֱ����㣬����new
	}
	// ������
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

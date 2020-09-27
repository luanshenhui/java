package com.zhaoyang04;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
	private static final String DRIVER="org.gjt.mm.mysql.Driver";
	private static final String URL="jdbc:mysql://127.0.0.1:3306/luan";
	private static final String USERNAME="root";
	private static final String PASSWORD="12345";
	
			
	
	public static Connection DBUtil(){
		Connection conn = null;
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

	public static Connection DBCLOE(Connection conn){
		
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
}

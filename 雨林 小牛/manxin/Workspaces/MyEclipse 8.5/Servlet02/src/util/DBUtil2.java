package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil2 {
	private static Properties pro = new Properties();
	
	static{
		InputStream is = DBUtil2.class.getClassLoader().getResourceAsStream("entity/db.properties");
		try {
			pro.load(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private static String className = pro.getProperty("classname");
	private static String url = pro.getProperty("url");
	private static String user = pro.getProperty("user");
	private static String pwd = pro.getProperty("pwd");
	
	public static Connection getConnection(){
		Connection conn = null;
		try {
			Class.forName(className);
			conn = DriverManager.getConnection(url, user, pwd);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
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
}

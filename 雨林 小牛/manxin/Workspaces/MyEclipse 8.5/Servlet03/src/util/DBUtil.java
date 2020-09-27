package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import com.mysql.jdbc.PreparedStatement;

public class DBUtil {
	private static Properties pro = new Properties();
	static{
		InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("entity/db.properties");
		try {
			pro.load(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private static String className = pro.getProperty("classname");
	private static String url = pro.getProperty("url");
	private static String password = pro.getProperty("password");
	private static String user = pro.getProperty("user");
	
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
	
	public static void CloseStat(PreparedStatement ps){
		if(ps != null){
			try {
				ps.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void CloseSet(ResultSet rs){
		if(rs != null){
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void main(String[] args) {
		Connection conn = DBUtil.getConnection();
		System.out.println(conn);
	}
}

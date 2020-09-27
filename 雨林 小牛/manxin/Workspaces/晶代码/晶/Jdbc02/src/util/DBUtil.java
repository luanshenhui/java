package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * 		jdbc工具类，提供了获取连接，
 * 关闭连接的方法。
 *
 */
public class DBUtil {
	private static Properties props = 
		new Properties();
	static{
		InputStream ips = DBUtil.class.getClassLoader()
		.getResourceAsStream("util/db.properties");
		try {
			props.load(ips);
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("读取db.properties文件失败");
		}
	}
	private static String className =
		props.getProperty("classname");
	private static String url = props.getProperty("url");
	private static String username =  props.getProperty("username");
	private static String pwd = props.getProperty("pwd");
	/**
	 * 	获得一个连接
	 * @throws SQLException 
	 */
	public static Connection getConnection() throws SQLException{
		Connection conn = null;
		try {
			Class.forName(className);
			conn = DriverManager.getConnection(
					url,username,pwd);
		} catch (ClassNotFoundException e) {
			//记日志
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
		return conn;
	}
	/**
	 * 关闭连接
	 */
	public static void close(Connection conn){
		if(conn != null){
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	/**
	 * @param args
	 * @throws SQLException 
	 */
	public static void main(String[] args) throws SQLException {
		System.out.println(getConnection());
	}

}

package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * 		jdbc�����࣬�ṩ�˻�ȡ���ӣ�
 * �ر����ӵķ�����
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
			System.out.println("��ȡdb.properties�ļ�ʧ��");
		}
	}
	private static String className =
		props.getProperty("classname");
	private static String url = props.getProperty("url");
	private static String username =  props.getProperty("username");
	private static String pwd = props.getProperty("pwd");
	/**
	 * 	���һ������
	 * @throws SQLException 
	 */
	public static Connection getConnection() throws SQLException{
		Connection conn = null;
		try {
			Class.forName(className);
			conn = DriverManager.getConnection(
					url,username,pwd);
		} catch (ClassNotFoundException e) {
			//����־
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
		return conn;
	}
	/**
	 * �ر�����
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

package exam_util;

import java.sql.*;

public class exam_sql {
	//连接数据库
	public static Connection exam_Date(){
		String url = "jdbc:oracle:thin:@localhost:1521:XE";
		String user = "system";
		String pwd = "1234";
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, user, pwd);

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("数据库访问失败！");
		}
		return conn;
	}
	
}

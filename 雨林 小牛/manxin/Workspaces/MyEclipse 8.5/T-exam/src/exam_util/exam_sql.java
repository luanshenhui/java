package exam_util;

import java.sql.*;

public class exam_sql {
	//�������ݿ�
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
			System.out.println("���ݿ����ʧ�ܣ�");
		}
		return conn;
	}
	
}

package day01;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class FirstJdbc {
//oracle���ݿ�����ò���
//	private static String className =
//		"oracle.jdbc.driver.OracleDriver";
//	private static String url =
//		"jdbc:oracle:thin:@localhost:1521:XE";
//	private static String username = "system";
//	private static String pwd = "action";
	
	//mysql���ݿ�����ò���
	private static String className =
		"com.mysql.jdbc.Driver";
	private static String url =
		"jdbc:mysql://localhost:3306/test";
	private static String username = "root";
	private static String pwd = "1234";
	/**
	 * @param args
	 * @throws ClassNotFoundException 
	 * @throws SQLException 
	 */
	public static void main(String[] args) 
	throws ClassNotFoundException, SQLException {
		/*
		 * step1,��������
		 * 	   JVM�ڼ���OracleDriver��ʱ,��ִ��
		 * �����static��(��̬��ʼ����),static��
		 * �����������ע�ᡣ
		 */
		Class.forName(className);
		/*
		 * step2,�������
		 * 		getConnection����Ҫ���ݲ����ṩ����Ϣ��
		 * ���������ݿ�֮����������ӣ����ҷ���
		 * һ������Connection�ӿ�Ҫ��Ķ���
		 */
		Connection conn = 
			DriverManager.getConnection(
					url,username,pwd);
		System.out.println(conn);
		/*
		 * step3,����Statement
		 */
		Statement stat = conn.createStatement();
		/*
		 * step4,ִ��sql,����ǲ�ѯ��Ҫ����
		 * �������
		 */
		String sql = "select * from t_student";
		ResultSet rst = stat.executeQuery(sql);
		while(rst.next()){
			//get���������Ҫ�ͱ�������ֶ����ͱ���һ��
			//˫�����ڵı����� Ҫ�ͱ�����ֶ����ֱ���һ��
			int id = rst.getInt("id");
			String name = rst.getString("name");
			int age = rst.getInt("age");
			System.out.println("id:" 
					+ id + " name:" + name + " age:" + age);
		}
		/*
		 * step5,�ر���Դ
		 */
		rst.close();
		stat.close();
		conn.close();
	}

}

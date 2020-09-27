package day01;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class FirstJdbc {
//oracle数据库的配置参数
//	private static String className =
//		"oracle.jdbc.driver.OracleDriver";
//	private static String url =
//		"jdbc:oracle:thin:@localhost:1521:XE";
//	private static String username = "system";
//	private static String pwd = "action";
	
	//mysql数据库的配置参数
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
		 * step1,加载驱动
		 * 	   JVM在加载OracleDriver类时,会执行
		 * 该类的static块(静态初始化块),static块
		 * 会完成驱动的注册。
		 */
		Class.forName(className);
		/*
		 * step2,获得连接
		 * 		getConnection方法要依据参数提供的信息，
		 * 建立与数据库之间的物理连接，并且返回
		 * 一个符合Connection接口要求的对象。
		 */
		Connection conn = 
			DriverManager.getConnection(
					url,username,pwd);
		System.out.println(conn);
		/*
		 * step3,创建Statement
		 */
		Statement stat = conn.createStatement();
		/*
		 * step4,执行sql,如果是查询，要处理
		 * 结果集。
		 */
		String sql = "select * from t_student";
		ResultSet rst = stat.executeQuery(sql);
		while(rst.next()){
			//get后面的类型要和表里面的字段类型保持一致
			//双引号内的变量名 要和表里的字段名字保持一致
			int id = rst.getInt("id");
			String name = rst.getString("name");
			int age = rst.getInt("age");
			System.out.println("id:" 
					+ id + " name:" + name + " age:" + age);
		}
		/*
		 * step5,关闭资源
		 */
		rst.close();
		stat.close();
		conn.close();
	}

}

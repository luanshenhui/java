package com.zhaoyang;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
	
/**
 * javaSE:java 标准版(基础语法，面向对象，API) javaEE：java企业版，由13个核心技术构成
 * JDBC：java连接数据库连接标准，用来访问关系(表)型数据库 JSP：web应用中的页面 Servlet：web应用中的控制器
 * JNDI，JMS，RMI，EJB等
 * 
 * sun公司：定义访问数据库的规范，标准 数据库厂商：来实现标准 java程序员：调用者
 */
/*
 * java JDBC的API
 * (7个步骤5个API)
 * java.sql.DriverManager
 * java.sql.Connection
 * java.sql.Statement
 * java.sql.ResultSet
 * java.sql.SQLException
 */
public class JDBC02 {
	public static void main(String[] args) {
		// 使用JDBC访问数据库步骤和实现

		// (1)加载数据库驱动
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)获取数据库连接--借助一个驱动的管理类获得一个(返回)连接
			//URL://用户名：//密码：
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			
			//第三部:获取语句对象
			Statement st=conn.createStatement();
			//第四步：执行sql语句,返回结果的集合的对象
			String sql="select * from men";
			ResultSet rs=st.executeQuery(sql);
			while(rs.next()){//判断是否有下一条记录，有返回true
				int id=rs.getInt("id");//根据列名获取对应数据
				String name =rs.getString("name");
				double salary =rs.getDouble("salary");
				System.out.println(id+name+salary);
			}
			//5)关闭
			rs.close();
			st.close();
			conn.close();
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}

package com.zhaoyang;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * javaSE:java 标准版(基础语法，面向对象，API) javaEE：java企业版，由13个核心技术构成
 * JDBC：java连接数据库连接标准，用来访问关系(表)型数据库 JSP：web应用中的页面 Servlet：web应用中的控制器
 * JNDI，JMS，RMI，EJB等
 * 
 * sun公司：定义访问数据库的规范，标准 数据库厂商：来实现标准 java程序员：调用者
 */

public class JDBC01 {
	public static void main(String[] args) {
		// 使用JDBC访问数据库步骤和实现

		// (1)加载数据库驱动
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)获取数据库连接--借助一个驱动的管理类获得一个(返回)连接
			//URL://用户名：//密码：
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			System.out.println(conn);
			//(3)--	设置：如果是添加，修改，删除。需要设置事务为非自动提交
			conn.setAutoCommit(false);
			//(4) 	获取语句对象
			Statement st= conn.createStatement();
			//(5) 执行SQL语句
			//String sql="insert into men values(1,'张三',5555.33)";
			//String sql="update men set salary=6000 where name='张三'";
			String sql="delete from men where name='张三'";
			System.out.println("将要执行的语句是"+sql);
			int count=st.executeUpdate(sql);//执行st
			System.out.println("成功添加"+count+"条纪录");
			//6)--事物需要提交(增删改)
			conn.commit();
			//7)关闭数据库连接
			st.close();//关闭语句
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

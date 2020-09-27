package com.zhaoyang;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

public class JDBC03 {

	public static boolean loginBank(String username,String password){
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)获取数据库连接--借助一个驱动的管理类获得一个(返回)连接
			//URL://用户名：//密码：
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			
			//第三部:获取语句对象
			Statement st=conn.createStatement();
			//传参的拼写方式
			//如果是字符类型的：'"+变量+"'
			//如果是数字："+变量+"
			String sql="select * from bank where username='"+username+"'and password='"+password+"'";
			System.out.println("将要执行的SQL语句是"+sql);
			ResultSet rs=st.executeQuery(sql);
			while(rs.next()){
				return true;
			}
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return false;
	}
	
	public static void main(String[] args) {
		//实现一个银行登陆的方法,登陆成功返回true，失败返回false
		String username="李四";
		String password="1234";
//		String password="'or'1'='1";
		
		//专题 二：注入攻击
		boolean boo=loginBank(username,password);
		System.out.println(boo);
	}

	private static boolean loginBank2(String username, String password) {
		// TODO Auto-generated method stub
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)获取数据库连接--借助一个驱动的管理类获得一个(返回)连接
			//URL://用户名：//密码：
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			
			//第三部:获取语句对象
			
			//采用预编译后传参数的原理来实现
			//它会先得到sql语句的句式先发往数据库服务器端进行编译，然后再传参到数据库服务器进行执行
			//(1)防止注入攻击，安全
			//(2)对于反复执行的sql语句效率高
			String sql="select * from bank where username=?and password =?";//预编译
			PreparedStatement ps=conn.prepareStatement(sql);
			//后传参
			ps.setString(1, username);
			ps.setString(2, password);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				return true;
			}
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return false;
	}

}

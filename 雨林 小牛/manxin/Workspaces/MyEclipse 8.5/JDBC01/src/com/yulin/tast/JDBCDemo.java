package com.yulin.tast;

import java.sql.*;
import java.util.*;

public class JDBCDemo {

	/**
	 * JDBC应用
	 */
	
	//查询数据
	public static void query(){
		String url = "jdbc:oracle:thin:@localhost:1521:XE";
		String user = "system";
		String password = "1234";
		try {
			//加载驱动
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//建立连接
			Connection conn = DriverManager.getConnection(url, user, password);
			//获得statement对象
			Statement stmt = conn.createStatement();
			//执行sql,并获得结果集
			ResultSet rs = stmt.executeQuery("select * from emp");
			//处理结果集
			while(rs.next()){
				String name = rs.getString("ename");
				int salary = rs.getInt("salary");
				int bonus = rs.getInt("bonus");
				System.out.println(name+"\t"+salary+"\t"+bonus);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//删除数据
	public static void del(){
		String url = "jdbc:oracle:thin:@localhost:1521:XE";
		String user = "system";
		String password = "1234";		
		try {
			Scanner scan = new Scanner(System.in);
			System.out.println("请输入要删除的姓名：");
			String ename = scan.nextLine();
			//加载驱动
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//建立连接
			Connection conn = DriverManager.getConnection(url, user, password);
			
			//sql注入
//			String del = "delete emp where ename='"+ename+"'";
			
			//预编译
			String del = "delete emp where ename=?";
			PreparedStatement ps = conn.prepareStatement(del);
			ps.setString(1, ename);
			boolean bl = ps.execute();
			if(bl==true){
				System.out.println("删除成功");						
			}else{
				System.out.println("删除成功");	
			}	
			ps.close();
			conn.close();	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		del();
		query();
		/**
		 * 声明一个删除数据的方法，根据输入的ename删除数据
		 */
	}
}

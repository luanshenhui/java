package com.yulin.web;

import java.sql.*;

import java.util.*;
public class JDBCDemo {
	public void lik(){
		String url="jdbc:oracle:thin@loaclhost:1521:XE";
		String user="system";
		String password="1234";
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn=DriverManager.getConnection(url,user,password);
			Statement stmt=conn.createStatement();
			ResultSet rs=stmt.executeQuery("insert into value values()");
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}

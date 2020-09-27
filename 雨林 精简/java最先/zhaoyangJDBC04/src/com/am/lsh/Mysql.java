package com.am.lsh;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Mysql {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// π”√jdbc∑√Œ mysql
		
			try {
				Class.forName("org.gjt.mm.mysql.Driver");
				Connection conn=DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/luan","root","12345");
				System.out.println(conn);
				String sql="select * from member";
				PreparedStatement ps=conn.prepareStatement(sql);
				ResultSet rs=ps.executeQuery();
				while(rs.next()){
					int i=rs.getInt("id");
					String s=rs.getString("name");
					int a=rs.getInt("age");
					System.out.println(i+" "+s+"  "+a);
				}
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		

	}

}

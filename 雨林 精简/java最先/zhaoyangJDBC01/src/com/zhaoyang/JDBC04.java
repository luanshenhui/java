package com.zhaoyang;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBC04 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// ʵ������ת��
		boolean boo=menthod("����","����",50);
		System.out.println(boo);
		

	}

	private static boolean menthod(String name, String name2, double salary) {
		// TODO Auto-generated method stub
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)��ȡ���ݿ�����--����һ�������Ĺ�������һ��(����)����
			//URL://�û�����//���룺
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			conn.setAutoCommit(false);
			//������:��ȡ������
			String sql="update bank set money=money-? where username = ?";
			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setDouble(1, salary);
			ps.setString(2, name);
			int c1=ps.executeUpdate();
			
			String sql02="update bank set money=money+? where username = ?";
			PreparedStatement ps02=conn.prepareStatement(sql02);
			ps02.setDouble(1, salary);
			ps02.setString(2, name2);
			System.out.println("��Ҫִ�е�SQL�����"+sql);
			int c02=ps02.executeUpdate();
			
			if(c1==1&& c02==1){
				conn.commit();
				return true;
			}
			
			
//			sql="update bank set salary=salary+salary where username = ?";
//			 ps=conn.prepareStatement(sql);
//			 ps.setString(1, name2);
//			 
//			 ResultSet rs=ps.executeQuery();
//			 while(rs.next()){
//				 return true;
//			 }
			 conn.close();
			
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

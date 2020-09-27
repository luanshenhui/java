package com.yulin.tast;

import java.sql.*;
import java.util.*;

public class JDBCDemo {

	/**
	 * JDBCӦ��
	 */
	
	//��ѯ����
	public static void query(){
		String url = "jdbc:oracle:thin:@localhost:1521:XE";
		String user = "system";
		String password = "1234";
		try {
			//��������
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//��������
			Connection conn = DriverManager.getConnection(url, user, password);
			//���statement����
			Statement stmt = conn.createStatement();
			//ִ��sql,����ý����
			ResultSet rs = stmt.executeQuery("select * from emp");
			//��������
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
	
	//ɾ������
	public static void del(){
		String url = "jdbc:oracle:thin:@localhost:1521:XE";
		String user = "system";
		String password = "1234";		
		try {
			Scanner scan = new Scanner(System.in);
			System.out.println("������Ҫɾ����������");
			String ename = scan.nextLine();
			//��������
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//��������
			Connection conn = DriverManager.getConnection(url, user, password);
			
			//sqlע��
//			String del = "delete emp where ename='"+ename+"'";
			
			//Ԥ����
			String del = "delete emp where ename=?";
			PreparedStatement ps = conn.prepareStatement(del);
			ps.setString(1, ename);
			boolean bl = ps.execute();
			if(bl==true){
				System.out.println("ɾ���ɹ�");						
			}else{
				System.out.println("ɾ���ɹ�");	
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
		 * ����һ��ɾ�����ݵķ��������������enameɾ������
		 */
	}
}

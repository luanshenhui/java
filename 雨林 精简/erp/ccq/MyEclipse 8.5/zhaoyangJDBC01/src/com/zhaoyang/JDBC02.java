package com.zhaoyang;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
	
/**
 * javaSE:java ��׼��(�����﷨���������API) javaEE��java��ҵ�棬��13�����ļ�������
 * JDBC��java�������ݿ����ӱ�׼���������ʹ�ϵ(��)�����ݿ� JSP��webӦ���е�ҳ�� Servlet��webӦ���еĿ�����
 * JNDI��JMS��RMI��EJB��
 * 
 * sun��˾������������ݿ�Ĺ淶����׼ ���ݿ⳧�̣���ʵ�ֱ�׼ java����Ա��������
 */
/*
 * java JDBC��API
 * (7������5��API)
 * java.sql.DriverManager
 * java.sql.Connection
 * java.sql.Statement
 * java.sql.ResultSet
 * java.sql.SQLException
 */
public class JDBC02 {
	public static void main(String[] args) {
		// ʹ��JDBC�������ݿⲽ���ʵ��

		// (1)�������ݿ�����
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)��ȡ���ݿ�����--����һ�������Ĺ�������һ��(����)����
			//URL://�û�����//���룺
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			
			//������:��ȡ������
			Statement st=conn.createStatement();
			//���Ĳ���ִ��sql���,���ؽ���ļ��ϵĶ���
			String sql="select * from men";
			ResultSet rs=st.executeQuery(sql);
			while(rs.next()){//�ж��Ƿ�����һ����¼���з���true
				int id=rs.getInt("id");//����������ȡ��Ӧ����
				String name =rs.getString("name");
				double salary =rs.getDouble("salary");
				System.out.println(id+name+salary);
			}
			//5)�ر�
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

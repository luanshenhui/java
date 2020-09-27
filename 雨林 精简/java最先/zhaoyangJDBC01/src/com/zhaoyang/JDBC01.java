package com.zhaoyang;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * javaSE:java ��׼��(�����﷨���������API) javaEE��java��ҵ�棬��13�����ļ�������
 * JDBC��java�������ݿ����ӱ�׼���������ʹ�ϵ(��)�����ݿ� JSP��webӦ���е�ҳ�� Servlet��webӦ���еĿ�����
 * JNDI��JMS��RMI��EJB��
 * 
 * sun��˾������������ݿ�Ĺ淶����׼ ���ݿ⳧�̣���ʵ�ֱ�׼ java����Ա��������
 */

public class JDBC01 {
	public static void main(String[] args) {
		// ʹ��JDBC�������ݿⲽ���ʵ��

		// (1)�������ݿ�����
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)��ȡ���ݿ�����--����һ�������Ĺ�������һ��(����)����
			//URL://�û�����//���룺
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			System.out.println(conn);
			//(3)--	���ã��������ӣ��޸ģ�ɾ������Ҫ��������Ϊ���Զ��ύ
			conn.setAutoCommit(false);
			//(4) 	��ȡ������
			Statement st= conn.createStatement();
			//(5) ִ��SQL���
			//String sql="insert into men values(1,'����',5555.33)";
			//String sql="update men set salary=6000 where name='����'";
			String sql="delete from men where name='����'";
			System.out.println("��Ҫִ�е������"+sql);
			int count=st.executeUpdate(sql);//ִ��st
			System.out.println("�ɹ����"+count+"����¼");
			//6)--������Ҫ�ύ(��ɾ��)
			conn.commit();
			//7)�ر����ݿ�����
			st.close();//�ر����
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

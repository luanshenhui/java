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
			// (2)��ȡ���ݿ�����--����һ�������Ĺ�������һ��(����)����
			//URL://�û�����//���룺
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			
			//������:��ȡ������
			Statement st=conn.createStatement();
			//���ε�ƴд��ʽ
			//������ַ����͵ģ�'"+����+"'
			//��������֣�"+����+"
			String sql="select * from bank where username='"+username+"'and password='"+password+"'";
			System.out.println("��Ҫִ�е�SQL�����"+sql);
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
		//ʵ��һ�����е�½�ķ���,��½�ɹ�����true��ʧ�ܷ���false
		String username="����";
		String password="1234";
//		String password="'or'1'='1";
		
		//ר�� ����ע�빥��
		boolean boo=loginBank(username,password);
		System.out.println(boo);
	}

	private static boolean loginBank2(String username, String password) {
		// TODO Auto-generated method stub
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// (2)��ȡ���ݿ�����--����һ�������Ĺ�������һ��(����)����
			//URL://�û�����//���룺
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			
			//������:��ȡ������
			
			//����Ԥ����󴫲�����ԭ����ʵ��
			//�����ȵõ�sql���ľ�ʽ�ȷ������ݿ�������˽��б��룬Ȼ���ٴ��ε����ݿ����������ִ��
			//(1)��ֹע�빥������ȫ
			//(2)���ڷ���ִ�е�sql���Ч�ʸ�
			String sql="select * from bank where username=?and password =?";//Ԥ����
			PreparedStatement ps=conn.prepareStatement(sql);
			//�󴫲�
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

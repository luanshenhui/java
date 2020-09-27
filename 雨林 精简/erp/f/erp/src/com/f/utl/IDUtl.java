package com.f.utl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;



/**
 * 
 * @author ��ѧ��
 *
 * 2015-2-2����10:30:03
 *	������:��������ΨһID
 *	��ǰʱ�������+���������   ��   �����ݿ⣬ȡ����
 *	
 */
public final class IDUtl {
	private IDUtl(){
		
	}
	public synchronized static long getID(){
//		Date date=new Date();
//		long time=date.getTime();
//		
//		Random random =new Random();
//		
//		long number =random.nextLong();
		
		//(1)�������ݿ�����
		long id = 0;
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//(2)��ȡ���ݿ�����
			//URL,�û���,����
			conn =DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl","b1","123qwe");
			
			//(4)��ȡ������
			Statement sta= conn.createStatement();
			//(5)ִ��SQL���
			String sql ="select erp_id.nextval id from dual ";
			
			ResultSet rs =sta.executeQuery(sql);
			while(rs.next()){
				id=rs.getLong("id");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			//(7)�ر�
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	
		
		return id;
	}
}

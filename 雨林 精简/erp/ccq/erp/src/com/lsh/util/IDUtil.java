package com.lsh.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Date;
import java.util.Random;

import com.sun.corba.se.spi.orbutil.fsm.Guard.Result;






/**
 * 
 * @author ������
 *
 * 2015-2-2����10:34:28
 * �����࣬��������Ψһidֵ
 * 
 * ��ǰʱ��ĺ�����+���������
 */
public  final class IDUtil {
	private IDUtil(){
		
	}
	/**
	 * ����+�����
	 * @return
	 */
	public synchronized static long getId(){
		Date date=new Date();
		long time=date.getTime();
		
		Random random=new Random();
		long number=random.nextLong();
		
		return time+number;
	}
	
	/**
	 * ͨ����������
	 * 
	 */
	public synchronized static long getSequenceID(){
		long id=0;
	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn=DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a2a", "123");
		String sql="select erp_id.nextval id from dual";
		PreparedStatement pt=conn.prepareStatement(sql);
		ResultSet rs=pt.executeQuery();
		while(rs.next()){
			id=rs.getInt("id");
//			return id;
		}
	} catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
		
		return id;
		
	}
}

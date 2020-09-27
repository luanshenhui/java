/**
 * 
 */
package com.dongxianglong.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.Random;

/**
 * @author ������
 *
 * 2015-2-2����10:30:56
 * 
 * �����ࣺ��������Ψһ��IDֵ������ԭ����ǰʱ��ĺ�����+�������
 */
public final class IDUtil {

	private IDUtil()
	{
		
	}
	/**
	 * ������+�����
	 * @return
	 */
	public synchronized static long getID()
	{
		Date date=new Date();
		long time=date.getTime();
		
		Random random=new Random();
		long number=random.nextLong();
		return time+number;
		
	}
	/**
	 * ͨ������ʵ��
	 * @return
	 */
	public synchronized static long getsequenceID()
	{
	   long code=0;	
		
		try {
			
			Class.forName("oracle.jdbc.driver.OracleDriver");
Connection conn=DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl","dong","dong");
			
			Statement st=conn.createStatement();
			String sql="select erp_id.nextval erpid from dual";
			//System.out.println("��Ҫִ�е����Ϊ��"+sql);
			ResultSet rs=st.executeQuery(sql);
			while(rs.next())
			{
				code= rs.getLong("erpid");	
				return code;
			}
		} catch (ClassNotFoundException e) {
			
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return code;
		
	}
	
	
}

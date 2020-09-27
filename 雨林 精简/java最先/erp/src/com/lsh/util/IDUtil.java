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
 * @author 栾慎辉
 *
 * 2015-2-2上午10:34:28
 * 工具类，用来生成唯一id值
 * 
 * 当前时间的毫秒数+随机数生成
 */
public  final class IDUtil {
	private IDUtil(){
		
	}
	/**
	 * 毫秒+随机数
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
	 * 通过序列生成
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

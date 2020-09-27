package com.f.utl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;



/**
 * 
 * @author 冯学明
 *
 * 2015-2-2上午10:30:03
 *	工具类:用来生成唯一ID
 *	当前时间毫秒数+随机数生成   或   连数据库，取序列
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
		
		//(1)加载数据库驱动
		long id = 0;
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//(2)获取数据库连接
			//URL,用户名,密码
			conn =DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl","b1","123qwe");
			
			//(4)获取语句对象
			Statement sta= conn.createStatement();
			//(5)执行SQL语句
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
			//(7)关闭
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	
		
		return id;
	}
}

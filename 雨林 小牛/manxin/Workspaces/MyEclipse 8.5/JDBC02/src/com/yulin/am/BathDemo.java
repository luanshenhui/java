package com.yulin.am;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.swing.text.html.HTMLDocument.HTMLReader.PreAction;

public class BathDemo {
	
	public static void main(String[] args) {
		/*
		 * 批处理，在短时间内执行多条SQL语句
		 */
		String insert = "insert into test1 values(?)";
		Connection conn = DBUtil.getConnection();
		try {
			PreparedStatement ps = conn.prepareStatement(insert);
			long time1 = System.nanoTime()/1000;
			for(int i = 0;i < 100; i++){
				ps.setInt(1, i);
				ps.addBatch();//添加一个处理
			}
			ps.executeBatch();//批处理
			long time2 = System.nanoTime()/1000;
			System.out.println(time2 - time2);
			ps.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}

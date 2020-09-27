package com.yulin.tast;

import java.io.IOException;
import java.sql.*;
public class JDBCDemo2 {

	/**
	 * 读取emp表中的数据
	 */
	public static void main(String[] args) {
		try {
			Connection conn = DBUtil.getConn("src/ojdbc.properties");
			PreparedStatement ps = conn.prepareStatement("select * from emp");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String name = rs.getString("ename");
				int salary = rs.getInt("salary");
				int bonus = rs.getInt("bonus");
				System.out.println(name+"\t"+salary+"\t"+bonus);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		//练习：利用控制台，插入一条数据
	}

}

package com.yulin.tast;

import java.io.IOException;
import java.sql.*;
public class JDBCDemo2 {

	/**
	 * ��ȡemp���е�����
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
		//��ϰ�����ÿ���̨������һ������
	}

}

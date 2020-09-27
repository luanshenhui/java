package com.lushenhui;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MemberDAOImpl implements MemberDAO {

	@Override
	public List<Member> getAll() {

		Connection conn = null;
	
		List<Member> list = new ArrayList<Member>();
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");

			String sq = "select * from member ";
			PreparedStatement ps = conn.prepareStatement(sq);

			ResultSet rs = ps.executeQuery();
			System.out.println(rs.toString());
			while (rs.next()) {// while里面是一条条记录
				// System.out.println("结果是"+rs.next());
				Member member=new Member();//9个人要9个对象
				member.setId(rs.getInt("id"));
				member.setName(rs.getString("name"));
				member.setDepartment(rs.getString("department"));
				member.setSalary(rs.getDouble("salary"));
				member.setSex(rs.getString("sex"));
				list.add(member);
			}
			return list;
		} catch (ClassNotFoundException e) {
			// TODO
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;

	}

	@Override
	public List<Member> search(String name, double i, double j) {


		Connection conn = null;
	
		List<Member> list = new ArrayList<Member>();
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");

			String sq = "select * from member where name like ? and salary between ? and ? order by salary desc";
			PreparedStatement ps = conn.prepareStatement(sq);
			ps.setString(1, name+"%");
			ps.setDouble(2, i);
			ps.setDouble(3, j);
			
			ResultSet rs = ps.executeQuery();
			//System.out.println(rs.toString());
			while (rs.next()) {// while里面是一条条记录
			// System.out.println("结果是"+rs.next());
				Member member=new Member();
				member.setId(rs.getInt("id"));
				member.setName(rs.getString("name"));
				member.setDepartment(rs.getString("department"));
				member.setSalary(rs.getDouble("salary"));
				member.setSex(rs.getString("sex"));
				list.add(member);
			}
			return list;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;

	
		
	}

}

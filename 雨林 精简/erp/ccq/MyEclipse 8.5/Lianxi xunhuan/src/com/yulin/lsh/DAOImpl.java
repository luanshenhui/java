package com.yulin.lsh;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOImpl implements DAO {

	@Override
	public void add(Member member) {

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			conn.setAutoCommit(false);
			String sql = "insert into member values(member_id.nextval,?,?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, member.getName());
			ps.setInt(2, member.getAge());
			System.out.println("名字是"+member.getName());
			int rs = ps.executeUpdate();
			conn.commit();
			System.out.println("执行" + rs + "条记录");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@Override
	public void delete(Member member) {

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			conn.setAutoCommit(false);
			String sql = "delete from member where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, member.getId());
			int rs = ps.executeUpdate();
			System.out.println("执行" + rs + "条记录");
			conn.commit();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@Override
	public List<Member> getAll() {
		List<Member>list =new ArrayList<Member>();

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			String sql = "select * from member";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Member m2=new Member();
				m2.setId(rs.getInt("id"));
				m2.setName(rs.getString("name"));
				m2.setAge(rs.getInt("age"));
				//System.out.println(m);
				list.add(m2);
			}

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	
	
		return list;
	}

	@Override
	public Member getMemberByName(String name) {
		Member m = new Member();
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");

			String sql = "select * from member where name=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, name);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				m.setId(rs.getInt("id"));
				m.setName(rs.getString("name"));
				m.setAge(rs.getInt("age"));
				System.out.println(m);
			}

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return m;
	}

	@Override
	public void update(Member member) {

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			conn.setAutoCommit(false);
			String sq = "update member set name= ? , age= ? where id=?";
			PreparedStatement ps = conn.prepareStatement(sq);

			ps.setString(1,member.getName());
			ps.setInt(2,member.getAge());
			ps.setInt(3, member.getId());
			int rs = ps.executeUpdate();
//			Member m1=new Member();
//			ResultSet r=ps.executeQuery();
			System.out.println("执行" + rs + "条记录");
			conn.commit();
//			while(r.next()){
//				m1.setId(r.getInt("id"));
//				m1.setName(r.getString("name"));
//				m1.setAge(r.getInt("age"));
//			}
//			System.out.println(m1);
			conn.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	

}

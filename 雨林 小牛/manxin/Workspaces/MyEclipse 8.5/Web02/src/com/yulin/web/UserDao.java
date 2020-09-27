package com.yulin.web;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {	
	private String insertUser = "insert into regist values(?,?,?)";
	private String selectUser = "select * from regist where loginid = ? and pwd = ?";
	
	public boolean insertUser(User u){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(insertUser);
			ps.setInt(1, u.getLoginId());
			ps.setInt(2, u.getPwd());
			ps.setString(3, u.getName());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	public User find(int loginId,int pwd){
		Connection conn = DBUtil.getConn();
		User u = null;
		try {
			PreparedStatement ps = conn.prepareStatement(selectUser);
			ps.setInt(1, loginId);
			ps.setInt(2, pwd);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				u = new User(rs.getInt(1),rs.getInt(2),rs.getString(3));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}
	public static void main(String[] args) {
		UserDao ua = new UserDao();
//		System.out.println(ua.insertUser(new User(2,2,"b")));
		System.out.println(ua.find(1, 1));
	}
}

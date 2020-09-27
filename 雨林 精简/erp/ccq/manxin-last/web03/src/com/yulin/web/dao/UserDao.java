package com.yulin.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.yulin.web.common.DBUtil;
import com.yulin.web.entity.User;

public class UserDao {
	private String findAll = "select * from t_user";
	private String login = "select * from t_user where u_loginid=?" +
			" and u_pwd = ? ";
	private String regist = "insert into t_user values(?,?,?,?,?)";
	
	private String findById = "select * from t_user where u_loginid = ? ";
	
	private String update="update t_user set u_name = ?, u_salary = ?, " +
			"u_age = ? where u_loginId = ?";
	//TODO update
	
	
	public List<User> findAll(){
		List<User> list = new ArrayList<User>();
		Connection conn = DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(findAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				list.add(new User(rs.getString(1), rs.getString(2),	rs.getString(3)
						, rs.getInt("u_salary"), rs.getInt("u_age")));
			}
			rs.close();
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	public User login(String id, String pwd){
		User u = null;
		Connection conn = DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(login);
			ps.setString(1, id);
			ps.setString(2, pwd);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u = new User(rs.getString(1), rs.getString(2),	rs.getString(3)
						, rs.getInt("u_salary"), rs.getInt("u_age"));
			}
			rs.close();
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}
	public boolean regist(User u){
		boolean flag = false;
		Connection conn = DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(regist);
			ps.setString(1, u.getLoginId());
			ps.setString(2, u.getPwd());
			ps.setString(3, u.getName());
			ps.setInt(4, u.getSalary());
			ps.setInt(5, u.getAge());
			if(ps.executeUpdate() == 1){
				flag = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
	
	public User findById(String id){
		User u = new User();
		Connection conn = DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(findById);
			ps.setString(1, id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u = new User(rs.getString(1), rs.getString(2),	rs.getString(3)
						, rs.getInt("u_salary"), rs.getInt("u_age"));
			}
			rs.close();
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}
	public static void main(String[] args) {
		System.out.println(new UserDao().regist(new User("1001", "1234", "Monty", 12000, 18)));
		System.out.println(new UserDao().findAll().size());
		System.out.println(new UserDao().findById("1001"));
		System.out.println(new UserDao().login("1001", "1234"));
	}
	public void update(String loginId, String name, int salary, int age) {
		Connection conn = DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(update);
			ps.setString(1, name);
			ps.setInt(2, salary);
			ps.setInt(3, age);
			ps.setString(4, loginId);
			System.out.println(ps.executeUpdate());
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}







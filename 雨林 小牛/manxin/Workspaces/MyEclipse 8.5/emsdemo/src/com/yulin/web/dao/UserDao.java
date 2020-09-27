package com.yulin.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.yulin.web.commen.DBUtil;
import com.yulin.web.entity.User;

public class UserDao {
	private String findAll ="select * from t_user";
	private String login="select * from t_user where u_loginid =? and u_pwd=?";
	private String regist ="insert into t_user values(?,?,?,?,?)";
	private String findById="select * from t_user where u_loginid =?";
	private String update ="update t_user set pwd=? ,name=? ,salary=?,age=?where loginid=?";
	
	
	public List<User> findAll(){
		Connection conn= DBUtil.getConn();
		User u = null;
		List<User> list = new ArrayList<User>();
		try {
			PreparedStatement ps = conn.prepareStatement(findAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u= new User(rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getInt(5));
				list.add(u);
			}
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	public User login(String id, String pwd){
		User u = new User();
		Connection conn=DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(login);
			ps.setString(1,id);
			ps.setString(2, pwd);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u= new User(rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getInt(5));
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}
	public boolean regist(User u){
		int flag = 0;
		Connection conn= DBUtil.getConn();
		try {
			PreparedStatement ps= conn.prepareStatement(regist);
			ps.setString(1,u.getLoginId());
			ps.setString(2,u.getPwd());
			ps.setString(3,u.getName());
			ps.setInt(4,u.getSalary());
			ps.setInt(5,u.getAge());
			flag=ps.executeUpdate();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag==1;
	}
	public User findById(String id){
		User u = new User();
		Connection conn= DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(findById);
			ps.setString(1,id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u= new User(rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getInt(5));
			}
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return u;
	}
	public boolean update(User u){
		int flag = 0;
		Connection conn= DBUtil.getConn();
		try {
			PreparedStatement ps= conn.prepareStatement(regist);
			ps.setString(1,u.getLoginId());
			ps.setString(1,u.getPwd());
			ps.setString(1,u.getName());
			ps.setInt(1,u.getSalary());
			ps.setInt(1,u.getAge());
			flag=ps.executeUpdate();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag==1;
	}
	public static void main(String[]args){
		UserDao ud = new UserDao();
		System.out.println(ud.findAll().size());
		System.out.println(ud.findById("1001"));
		System.out.println(ud.login("1001","1234"));
		
	}
}

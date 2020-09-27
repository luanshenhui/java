package com.yulin.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.yulin.web.common.DBUtil;
import com.yulin.web.entity.*;

public class UserDao {
	private String findAll = "select * from jsp_user";
	private String Login = "select * from jsp_user where u_loginid = ? and u_pwd = ?";
	private String regist = "insert into jsp_user values(?,?,?,?,?)";
	private String findById = "select * from jsp_user where u_loginid = ?";
	private String update = "update jsp_user set u_pwd = ?,u_name = ?,u_salary = ?,u_age = ? where u_loginid = ?";
	private String delete = "delete from jsp_user where u_loginid = ?";
	
	/*查询所有*/
	public List<User> findAll(){
		Connection conn = DBUtil.getConn();
		User u = null;
		List<User> list = new ArrayList<User>();
		try {
			PreparedStatement ps = conn.prepareStatement(findAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u = new User(rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getInt(5));
				list.add(u);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	/*登录*/
	public User Login(String id,String pwd){
		User u = null;
		Connection conn = DBUtil.getConn();
		try {
			PreparedStatement ps = conn.prepareStatement(Login);
			ps.setString(1, id);
			ps.setString(2, pwd);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u = new User(rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getInt(5));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}
	/*注册*/
	public boolean regist(User u){
		Connection conn = DBUtil.getConn();
		int flag = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(regist);
			ps.setString(1, u.getLoginId());
			ps.setString(2, u.getPwd());
			ps.setString(3, u.getName());
			ps.setInt(4, u.getSalary());
			ps.setInt(5, u.getAge());
			flag = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag == 1;
	}
	/*通过id查User*/
	public List<User> findById(String id){
		Connection conn = DBUtil.getConn();
		User u = null;
		List<User> list = new ArrayList<User>();
		try {
			PreparedStatement ps = conn.prepareStatement(findById);
			ps.setString(1, id);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				u = new User(rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getInt(5));
				list.add(u);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/*修改*/
	public boolean Update(User u){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(update);
			ps.setString(1, u.getPwd());
			ps.setString(2, u.getName());
			ps.setInt(3, u.getSalary());
			ps.setInt(4, u.getAge());
			ps.setString(5, u.getLoginId());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	/*删除*/
	public boolean Delete(User u){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(delete);
			ps.setString(1, u.getLoginId());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	public static void main(String[] args) {
		UserDao ud = new UserDao();
		System.out.println(ud.regist(new User("1","1","1",1,1)));
//		System.out.println(ud.Login("1", "1"));
//		System.out.println(ud.findAll().size());
//		System.out.println(ud.findById("1"));
//		System.out.println(ud.regist(new User("44","44","44",4,4)));
//		System.out.println(ud.Delete(new User("1","1","1",1,1)));
//		System.out.println(ud.Update(new User("44","44","44",5,5)));
	}
}

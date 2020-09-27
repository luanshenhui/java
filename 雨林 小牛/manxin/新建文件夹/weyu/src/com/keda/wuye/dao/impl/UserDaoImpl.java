package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.UserDao;
import com.keda.wuye.entity.User;
import com.keda.wuye.util.ConnectionUtils;

public class UserDaoImpl implements UserDao {
	//登陆验证
	public User getUser(String username,String password){
		
		User user = new User();
		try {
			
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houseAdmin where admin_username='"+username+"' and admin_password='"+password+"'");
			ResultSet rs = stmt.executeQuery();
			if(rs.next()){
				String name = rs.getString(1);
				System.out.println(name);
				String pwd = rs.getString(2);
				
				user.setPassword(pwd);
				user.setUsername(name);
			}
			else
				return null;
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user;
	}
	
	//注册添加
	public void insert(String username,String password)
	{
		String data1 = username;			
		String data2 = password;		
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("insert into houseAdmin(admin_username,admin_password) values('"+data1+"','"+data2+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	//查询，显示所有信息
	public List<User> getUser()
	{
		List<User> listUser = new ArrayList<User>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houseAdmin");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String username = rs.getString(1); 		//用户名
				String password = rs.getString(2);		//密码
								
				User user = new User();
				
				user.setUsername(username);
				user.setPassword(password);
			
				listUser.add(user);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listUser;
	}
	//查询，显示所有信息
	public List<User> select(String s)
	{
		List<User> listUser = new ArrayList<User>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houseAdmin " +
					"where admin_username like '%"+s+"%' " +
					"or admin_password like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String username = rs.getString(1); 		//用户名
				String password = rs.getString(2);		//密码
								
				User user = new User();
				
				user.setUsername(username);
				user.setPassword(password);
			
				listUser.add(user);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listUser;
	}
	//判断用户名是否重复
	public boolean nameEqual(String username)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from houseAdmin where admin_username='"+username+"'");
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
			{
				b = true;
			}
			else
			{
				b = false;
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return b;		
	}
	
	//删除
	public void delete(String username)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from houseAdmin where admin_username='"+username+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//修改
	public void update(String username,String password)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("update houseAdmin set admin_password='" +password+"'"+"where admin_username='"+username+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//查询一条信息
	public User getUser(String username)
	{
		User user = new User();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houseAdmin where admin_username='"+username+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String name = rs.getString(1);		//报警编号
				String pwd = rs.getString(2); 		//报警时间
				
				user.setPassword(pwd);
				user.setUsername(name);			
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user;
	}

	public User getAdminUser(String username, String password) {
		User user = new User();
		try {
			
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houseUser where admin_username='"+username+"' and admin_password='"+password+"'");
			ResultSet rs = stmt.executeQuery();
			if(rs.next()){
				String name = rs.getString(1);
				System.out.println(name);
				String pwd = rs.getString(2);
				
				user.setPassword(pwd);
				user.setUsername(name);
			}
			else
				return null;
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user;
	}

}

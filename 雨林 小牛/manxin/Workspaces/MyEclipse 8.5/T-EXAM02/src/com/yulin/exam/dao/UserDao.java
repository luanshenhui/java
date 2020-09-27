package com.yulin.exam.dao;

import java.sql.*;

import com.yulin.exam.bean.User;
import com.yulin.exam.util.DBUtil;

public class UserDao {
	private String queryAll = "select * from t_user";
	private String queryUser = "select * from t_user where loginid = ? and pwd = ?";
	private String insert = "insert into t_user values(?,?,?,?,?)";
	private String delete = "delete t_user where loginid = ?";
	private String modify = "update t_user set pwd = ? where loginid = ?";
	
	/*通过LoginID获得User 登录功能*/
	public User findUser(String loginId, String pwd){
		Connection conn = DBUtil.getConnection();	//获得链接对象
		User u = null;	//如果没有查询出数据，则返回初始值null
		try {
			PreparedStatement ps = conn.prepareStatement(queryUser);
			ps.setString(1, loginId);
			ps.setString(2, pwd);
			ResultSet rs = ps.executeQuery();
			//通过loginId主键获得的数据只有一条，所以用不到while循环
			if(rs.next()){//结果集的指针默认位置在"地址前"，所以需要next
				u = new User(rs.getString(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getString(5));
			}	
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}
	
	/*注册 插入数据*/
	public boolean insertUser(User u){//保存用户
		Connection conn = DBUtil.getConnection();
		int flag = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(insert);
			ps.setString(1, u.getLoginId());
			ps.setString(2, u.getPwd());
			ps.setString(3, u.getName());
			ps.setInt(4, u.getScore());
			ps.setString(5, u.getEmail());
			flag = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag == 1;
	}
	
//	public static void main(String[] args) {
//		UserDao ud = new UserDao();
//		User user = new User("1002","1234","JACK",-1,"qq.com");
//		System.out.println(ud.findUser("1001", "1234"));
//		System.out.println(ud.insertUser(user));
//	}
}































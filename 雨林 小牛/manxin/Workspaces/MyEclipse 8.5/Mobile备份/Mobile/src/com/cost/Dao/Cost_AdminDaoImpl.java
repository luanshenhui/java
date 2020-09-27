package com.cost.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cost.entity.Cost_Admin;
import com.cost.util.DBUtil;

public class Cost_AdminDaoImpl implements Cost_AdminDao{

	public Cost_Admin login(String admin_code, String password) throws Exception {
		Cost_Admin admin = null;
		if(admin_code == null || password == null){
			return null;
		}
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "select * from admin_info where admin_code = ? and password = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, admin_code);
			ps.setString(2, password);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				admin = createAdmin(rs);
				return admin;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return admin;
	}
	
	public void UpAdminPwd(int id, String password) throws Exception {
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "update admin_info set password = ? where id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, password);
			ps.setInt(2, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	private Cost_Admin createAdmin(ResultSet rs) throws SQLException {
		Cost_Admin admin = new Cost_Admin(rs.getInt(1),rs.getString(2),rs.getString(3),
				rs.getString(4),rs.getString(5),rs.getString(6),rs.getDate(7));
		return admin;
	}
	public static void main(String[] args) {
		Cost_AdminDaoImpl dao = new Cost_AdminDaoImpl();
		try {
			System.out.println(dao.login("admin", "1234"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}





	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

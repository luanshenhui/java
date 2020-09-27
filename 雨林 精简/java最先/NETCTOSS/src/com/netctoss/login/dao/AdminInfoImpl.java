package com.netctoss.login.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.netctoss.exception.DAOException;
import com.netctoss.login.entity.AdminInfo;
import com.netctoss.util.DBUtil;

public class AdminInfoImpl implements IAdminInfoDAO{

	public AdminInfo findByCodeAndPwd(String adminCode, String password)
			throws DAOException {
		AdminInfo admin=null;
		if(adminCode==null||password==null){
			return null;
		}
		Connection conn=DBUtil.getConnection();
		String sql="select * from admin_info" +
				" where admin_code=? and password=?";
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setString(1, adminCode);
			pst.setString(2, password);
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				admin = createAdminInfo(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据帐号密码查询管理员失败",e);
		}finally{
			DBUtil.closeConnection();
		}
		return admin;
	}

	private AdminInfo createAdminInfo(ResultSet rs) throws SQLException {
		AdminInfo admin=new AdminInfo();
		admin.setId(rs.getInt("id"));
		admin.setAdminCode(rs.getString("admin_code"));
		admin.setPassword(rs.getString("password"));
		admin.setName(rs.getString("name"));
		admin.setTelephone(rs.getString("telephone"));
		admin.setEmail(rs.getString("email"));
		admin.setEnrollDate(rs.getDate("enrolldate"));
		return admin;
	}

	public void modify(AdminInfo admin) throws DAOException {
		Connection conn=DBUtil.getConnection();
		String sql="update admin_info set password=?," +
				"name=?,telephone=?,email=?,enrolldate=? where id=?";
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setString(1, admin.getPassword());
			pst.setString(2, admin.getName());
			pst.setString(3, admin.getTelephone());
			pst.setString(4, admin.getEmail());
			pst.setDate(5, admin.getEnrollDate());
			pst.setInt(6, admin.getId());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}

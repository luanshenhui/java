package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBUtil;

import entity.Emp;

public class EmpDaoImpl implements EmpDao{

	public List<Emp> findAll() throws Exception{
		// 查询所有
		Connection conn = null;
		PreparedStatement ps = null;
		List<Emp> list = new ArrayList<Emp>();
		Emp emp = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from d_user";
			ps = (PreparedStatement) conn.prepareCall(sql);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				emp = new Emp(rs.getInt(1), rs.getString(2),rs.getString(3), rs.getInt(4), rs.getDouble(5));
				list.add(emp);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(ps);
			DBUtil.CloseConn(conn);
		}
		return list;
	}

	public List<Emp> findById(int id) throws Exception{
		// 根据id查询
		Connection conn = null;
		PreparedStatement ps = null;
		List<Emp> list = new ArrayList<Emp>();
		Emp emp = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from d_user where d_id=?";
			ps = (PreparedStatement) conn.prepareCall(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				emp = new Emp(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getDouble(5));
				list.add(emp);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(ps);
			DBUtil.CloseConn(conn);
		}
		return list;
	}


	public Emp findLogin(String name, String pwd) throws Exception{
		// 登录
		Connection conn = null;
		PreparedStatement ps = null;
		Emp emp = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from d_user where d_id=? and d_pwd=?";
			ps = (PreparedStatement) conn.prepareCall(sql);
			ps.setString(1, name);
			ps.setString(2, pwd);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				emp = new Emp(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getInt(4),rs.getDouble(5));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(ps);
			DBUtil.CloseConn(conn);
		}
		return emp;
	}

	public void regist(Emp emp) throws Exception {
		// 注册
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "insert into d_user(d_name,d_age,d_salary,d_pwd) values(?,?,?,?)";
			ps = (PreparedStatement) conn.prepareCall(sql);
			ps.setString(1, emp.getD_name());
			ps.setInt(2, emp.getD_age());
			ps.setDouble(3, emp.getD_salary());
			ps.setString(4, emp.getD_pwd());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(ps);
			DBUtil.CloseConn(conn);
		}
	}

	public Emp findLoginId(int id) throws Exception {
		// 验证登陆
		Connection conn = null;
		PreparedStatement ps = null;
		Emp emp = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from d_user where d_id=?";
			ps = (PreparedStatement) conn.prepareCall(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				emp = new Emp(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getInt(4), rs.getDouble(5));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(ps);
			DBUtil.CloseConn(conn);
		}
		return emp;
	}

	public Emp findName(String name) throws Exception {
		// 验证用户名
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Emp emp = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from d_user where d_name=?";
			ps = (PreparedStatement) conn.prepareCall(sql);
			ps.setString(1, name);
			rs = ps.executeQuery();
			if(rs.next()){
				emp = new Emp(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getInt(4), rs.getDouble(5));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(ps);
			DBUtil.CloseConn(conn);
		}
		return emp;
	}
	
	public static void main(String[] args) {
		EmpDaoImpl dao = new EmpDaoImpl();
		try {
			Emp emp =  dao.findName("aa");
			System.out.println(emp);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	
	
	
	
	
}

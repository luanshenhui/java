package DAO;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBUtil;

import com.mysql.jdbc.PreparedStatement;

import entity.Emp;

public class EmpDaoImpl implements EmpDao{
	public void save(Emp emp) throws Exception{
		Connection conn = null;
		PreparedStatement stat = null;
		try{
			conn = DBUtil.getConnection();
			String sql = "insert into d_user(d_name,d_age,d_salary) values(?,?,?)";
			stat = (PreparedStatement) conn.prepareStatement(sql);
			stat.setString(1, emp.getD_name());
			stat.setDouble(2, emp.getD_salary());
			stat.setInt(3, emp.getD_age());
			stat.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(stat);
			DBUtil.CloseConn(conn);
		}
	}
	public List<Emp> findEmp() throws Exception {
		// 查
		Connection conn = null;
		PreparedStatement stat = null;
		List<Emp> list = new ArrayList<Emp>();
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from d_user";
			stat = (PreparedStatement)conn.prepareStatement(sql);
			ResultSet rs = stat.executeQuery();
			Emp emp = null;
			while(rs.next()){
				emp = new Emp(rs.getInt(1),rs.getString(2),rs.getInt(3),rs.getDouble(4));
				list.add(emp);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(stat);
			DBUtil.CloseConn(conn);
		}
		
		return list;
	}
	
	public List<Emp> findEmpById(int id) throws Exception {
		// 根据id查
		Connection conn = null;
		PreparedStatement stat = null;
		Emp emp = null;
		List<Emp> list = new ArrayList<Emp>();
		conn = DBUtil.getConnection();
		String sql = "select * from d_user where d_id = ?";
		stat = (PreparedStatement) conn.prepareStatement(sql);
		stat.setInt(1, id);
		ResultSet rs = stat.executeQuery();
		if(rs.next()){
			emp = new Emp(rs.getInt(1),rs.getString(2),rs.getInt(3),rs.getDouble(4));
			list.add(emp);
		}
		return list;
	}
	public void update(Emp emp) throws Exception {
		// 修改
		Connection conn = null;
		PreparedStatement stat = null;
		conn = DBUtil.getConnection();
		String sql = "update d_user set d_name = ?,d_age = ?,d_salary = ? where d_id = ?";
		stat = (PreparedStatement) conn.prepareStatement(sql);
		stat.setString(1, emp.getD_name());
		stat.setInt(2, emp.getD_age());
		stat.setDouble(3, emp.getD_salary());
		stat.setInt(4, emp.getD_id());
		stat.executeUpdate();
	}
	public void delete(Emp emp) throws Exception {
		//删除
		Connection conn = null;
		PreparedStatement stat = null;
		conn = DBUtil.getConnection();
		try{
			String sql = "delete from d_user where d_id = ?";
			stat = (PreparedStatement) conn.prepareStatement(sql);
			stat.setInt(1, emp.getD_id());
			stat.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(stat);
			DBUtil.CloseConn(conn);
		}
	}
	public List<Emp> findEmpPage(int page) throws Exception{
		// 分页
		Connection conn = null;
		PreparedStatement stat = null;
		List<Emp> list = new ArrayList<Emp>();
		Emp emp = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from d_user where d_id limit ?, ?";
			stat = (PreparedStatement) conn.prepareStatement(sql);
			stat.setInt(1, page);
			ResultSet rs = stat.executeQuery();
			while(rs.next()){
				emp = new Emp(rs.getInt(1),rs.getString(2),rs.getInt(3),rs.getDouble(4));
				list.add(emp);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	public static void main(String[] args) {
		EmpDaoImpl ei = new EmpDaoImpl();
		Emp emp = new Emp();
		try {
			List<Emp> list = ei.findEmpById(1003);
			System.out.println(list);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	
	
	
	
	
	
}

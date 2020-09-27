package dao.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import util.DBUtil;

import dao.EmployeeDAO;
import entity.Employee;

public class EmployeeDAOImpl implements EmployeeDAO{

	public List<Employee> findAll() throws Exception {
		List<Employee> employees = 
			new ArrayList<Employee>();
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try{
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement(
					"select * from emp");
			rst = stat.executeQuery();
			while(rst.next()){
				Employee e = new Employee();
				e.setId(rst.getInt("id"));
				e.setName(rst.getString("name"));
				e.setSalary(rst.getDouble("salary"));
				e.setAge(rst.getInt("age"));
				employees.add(e);
			}
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}finally{
			if(rst != null){
				rst.close();
			}
			if(stat != null){
				stat.close();
			}
			DBUtil.close();
		}
		return employees;
	}

	public void delete(int id) throws Exception {
		Connection conn = null;
		PreparedStatement stat = null;
		try{
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement(
					"delete from emp where id=?");
			stat.setInt(1, id);
			stat.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close();
		}
	}

	public Employee findById(int id) throws Exception {
		Employee e = null;
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try{
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement(
					"select * from emp where id=?");
			stat.setInt(1, id);
			rst = stat.executeQuery();
			if(rst.next()){
				e = new Employee();
				e.setId(id);
				e.setName(rst.getString("name"));
				e.setSalary(rst.getDouble("salary"));
				e.setAge(rst.getInt("age"));
			}
		}catch(Exception e1){
			e1.printStackTrace();
			throw e1;
		}finally{
			if(rst != null){
				rst.close();
			}
			if(stat != null){
				stat.close();
			}
			DBUtil.close();
		}
		return e;
	}

	public void modify(Employee e) throws Exception {
		Connection conn = null;
		PreparedStatement stat = null;
		try{
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement(
					"update emp set name=?," +
					"salary=?,age=? where id=?");
			stat.setString(1, e.getName());
			stat.setDouble(2, e.getSalary());
			stat.setInt(3, e.getAge());
			stat.setInt(4, e.getId());
			stat.executeUpdate();
		}catch(Exception e1){
			e1.printStackTrace();
			throw e1;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close();
		}		
	}

	public void save(Employee e) throws Exception {
		Connection conn = null;
		PreparedStatement stat = null;
		try{
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement(
					"insert into emp(name,salary,age) " +
					"values(?,?,?)");
			stat.setString(1, e.getName());
			stat.setDouble(2, e.getSalary());
			stat.setInt(3, e.getAge());
			stat.executeUpdate();
		}catch(Exception e1){
			e1.printStackTrace();
			throw e1;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close();
		}
	}
	
}

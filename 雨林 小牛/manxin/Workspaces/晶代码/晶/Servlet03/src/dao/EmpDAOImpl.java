package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DBUtil;

import entity.Emp;

public class EmpDAOImpl implements EmpDAO{

	public void save(Emp emp) throws Exception {
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "insert into emp(name,salary,age) values (?,?,?)";
			stat = conn.prepareStatement(sql);
			stat.setString(1, emp.getName());
			stat.setDouble(2, emp.getSalary());
			stat.setInt(3, emp.getAge());
			stat.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally{
			DBUtil.CloseStat(stat);
			DBUtil.CloseConn(conn);
		}
	}
	
}

package com.netctoss.cost.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DBUtil;

public class CostDAOImpl implements ICostDAO {

	public List<Cost> findAll() throws DAOException {
		List<Cost> costs = new ArrayList<Cost>();
		String sql = "select * from cost";
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			pst = conn.prepareCall(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				Cost c = createCost(rs);
				costs.add(c);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("查询资费数据失败", e);
		} finally {
			DBUtil.closeConnection();
			try {
				if (pst != null) {
					pst.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		return costs;
	}

	private Cost createCost(ResultSet rs) throws SQLException {
		Cost c = new Cost();
		c.setId(rs.getInt("id"));
		c.setName(rs.getString("name"));
		c.setBaseDuration(rs.getInt("base_duration"));
		c.setBaseCost(rs.getDouble("base_cost"));
		c.setUnitCost(rs.getDouble("unit_cost"));
		c.setStatus(rs.getString("status"));
		c.setDescr(rs.getString("descr"));
		c.setStartTime(rs.getDate("startime"));
		c.setCreateTime(rs.getDate("creatime"));
		c.setCostType(rs.getString("cost_type"));
		return c;
	}

	public int getTotalPage(int pageSize) throws DAOException {
		int totalPage = 0;
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select count(*) from cost";
		try {
			pst = conn.prepareStatement(sql);
			rs = pst.executeQuery();
			if (rs.next()) {
				int rows = rs.getInt(1);
				totalPage = rows % pageSize == 0 ? rows / pageSize : rows
						/ pageSize + 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("查询失败", e);
		} finally {
			try {
				if (pst != null) {
					pst.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

			DBUtil.closeConnection();
		}
		return totalPage;
	}

	public List<Cost> findByPages(int pages, int pageSize) throws DAOException {
		List<Cost> lists = new ArrayList<Cost>();
		Connection conn = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from (select a.*,rownum rn from" +
				" cost a where rownum<?) where rn>=?";
		try {
			conn = DBUtil.getConnection();
			pst = conn.prepareStatement(sql);
			int start = pageSize * (pages - 1) + 1;
			int end = start + pageSize;
			pst.setInt(1, end);
			pst.setInt(2, start);
			rs = pst.executeQuery();
			while (rs.next()) {
				Cost c = createCost(rs);
				lists.add(c);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (pst != null) {
					pst.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			DBUtil.closeConnection();
		}
		return lists;
	}

	public void deleteById(int id) throws DAOException {
		Connection conn=DBUtil.getConnection();
		PreparedStatement pst=null;
		String sql="delete from cost where id=?";
		try {
			pst=conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
	}

	public Cost findById(int id) throws DAOException {
		Cost c=null;
		Connection conn=DBUtil.getConnection();
		PreparedStatement pst=null;
		ResultSet rs=null;
		String sql="select * from cost_heyanguang where id=?";
		try {
			pst=conn.prepareStatement(sql);
			pst.setInt(1, id);
			rs=pst.executeQuery();
			if(rs.next()){
				c=createCost(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return c;
	}

	public Cost findByName(String name) throws DAOException {
		Cost c=null;
		Connection conn=DBUtil.getConnection();
		PreparedStatement pst=null;
		ResultSet rs=null;
		String sql="select * from cost where name=?";
		try {
			pst=conn.prepareStatement(sql);
			pst.setString(1, name);
			rs=pst.executeQuery();
			if(rs.next()){
				c=createCost(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return c;
	}

	public void modify(Cost cost) throws DAOException {
		if(cost==null){
			return;
		}
		Connection conn=DBUtil.getConnection();
		String sql="update cost set name=?,base_duration=?," +
				"base_cost=?,unit_cost=?,descr=?," +
				"cost_type=? where id=?";
		PreparedStatement pst=null;
		try {
			pst=conn.prepareStatement(sql);
			pst.setString(1, cost.getName());
			pst.setInt(2, cost.getBaseDuration());
			pst.setDouble(3, cost.getBaseCost());
			pst.setDouble(4, cost.getUnitCost());
			pst.setString(5, cost.getDescr());
			pst.setString(6,cost.getCostType());
			pst.setInt(7, cost.getId());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("更新失败",e);
		}finally{
			DBUtil.closeConnection();
		}
	}

	public void save(Cost cost) throws DAOException {
		if(cost.getBaseDuration()==null){
			cost.setBaseDuration(0);
		}
		if(cost.getBaseCost()==null){
			cost.setBaseCost(0.0);
		}
		if(cost.getUnitCost()==null){
			cost.setUnitCost(0.0);
		}
		System.out.println(cost);
		Connection conn=DBUtil.getConnection();
		String sql="insert into cost " +
				"values(cost_id.nextval,?,?,?,?,'1',?,default,null,?)";
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setString(1, cost.getName());
			pst.setDouble(2, cost.getBaseDuration());
			pst.setDouble(3,cost.getBaseCost());
			pst.setDouble(4, cost.getUnitCost());
			pst.setString(5,cost.getDescr());
			pst.setString(6, cost.getCostType());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBUtil.closeConnection(); 
		}
		
	}

	public Cost vaildModiName(int id, String name) throws DAOException {
		Cost cost=null;
		Connection conn=DBUtil.getConnection();
		PreparedStatement pst=null;
		ResultSet rs=null;
		String sql="select * from cost where name=? and id<>?";
		try {
			pst=conn.prepareStatement(sql);
			pst.setString(1, name);
			pst.setInt(2, id);
			rs=pst.executeQuery();
			if(rs.next()){
				cost=createCost(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBUtil.closeConnection();
		}
		return cost;
	}

	public List<Cost> findByPagesAsc(int pages, int pageSize, String colName)
			throws DAOException {
		List<Cost> lists = new ArrayList<Cost>();
		Connection conn = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from (select a.*,rownum rn from " +
				"(select * from cost order by "+
				colName+") a where rownum<?) where rn>=?";
		try {
			conn = DBUtil.getConnection();
			pst = conn.prepareStatement(sql);
			int start = pageSize * (pages - 1) + 1;
			int end = start + pageSize;
			pst.setInt(1, end);
			pst.setInt(2, start);
			rs = pst.executeQuery();
			while (rs.next()) {
				Cost c = createCost(rs);
				lists.add(c);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (pst != null) {
					pst.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			DBUtil.closeConnection();
		}
		return lists;
	}

	public List<Cost> findByPagesDesc(int pages, int pageSize, String colName)
			throws DAOException {
		List<Cost> lists = new ArrayList<Cost>();
		Connection conn = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from (select a.*,rownum rn from " +
				"(select * from cost order by "+
				colName+" desc) a where rownum<?) where rn>=?";
		try {
			conn = DBUtil.getConnection();
			pst = conn.prepareStatement(sql);
			int start = pageSize * (pages - 1) + 1;
			int end = start + pageSize;
			pst.setInt(1, end);
			pst.setInt(2, start);
			rs = pst.executeQuery();
			while (rs.next()) {
				Cost c = createCost(rs);
				lists.add(c);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (pst != null) {
					pst.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			DBUtil.closeConnection();
		}
		return lists;
	}

}

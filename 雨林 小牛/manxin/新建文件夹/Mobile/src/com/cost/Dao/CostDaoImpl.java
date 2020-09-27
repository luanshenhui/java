package com.cost.Dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cost.entity.Cost;
import com.cost.util.DBUtil;


public class CostDaoImpl implements CostDao{
	/*
	 *  id            NUMBER(4) not null,
  name          VARCHAR2(50) not null,
  base_duration NUMBER(11),
  base_cost     NUMBER(7,2),
  unit_cost     NUMBER(7,4),
  status        CHAR(1),
  descr         VARCHAR2(100),
  creatime      DATE default SYSDATE,
  startime      DATE,
  cost_type     CHAR(1)
	 * */
	public List<Cost> findAll() throws Exception{
		List<Cost> list = new ArrayList<Cost>();
		// 查询
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "select * from COST";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Cost cost = getCost(rs);
				list.add(cost);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public void deleteCost(int id) throws Exception {
		// 删除
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "delete cost where id = ?";
			PreparedStatement ps;
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public Cost insertCost(Cost cost)  throws Exception{
		// 添加
		Connection conn = DBUtil.getConnection();
		try {
			String sql = "insert into cost(id,name,base_duration,base_cost,unit_cost,status,descr," +
					"creatime,startime,cost_type) values(c_costId.nextval,?,?,?,?,?,?,?,?,?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, cost.getName());
			ps.setInt(2, cost.getBase_duration());
			ps.setDouble(3, cost.getBase_cost());
			ps.setDouble(4, cost.getUnit_cost());
			ps.setString(5, "0");
			ps.setString(6, cost.getDescr());
			ps.setDate(7, (Date) cost.getCreatime());
			ps.setDate(8, (Date) cost.getStartime());
			ps.setString(9, cost.getCost_type());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cost;
	}
	

	public Cost finById(int id) throws Exception {
		// id查找
		Cost cost = null;
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "select * from cost where id = ?";
			PreparedStatement ps;
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				cost = getCost(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cost;
	}

	public void updateCost(Cost cost) throws Exception{
		// 修改
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "update cost set name=?,base_duration=?,base_cost=?,unit_cost=?,status=?,descr=?,creatime=?," +
					"startime=?,cost_type=? where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, cost.getName());
			ps.setInt(2, cost.getBase_duration());
			ps.setDouble(3, cost.getBase_cost());
			ps.setDouble(4, cost.getUnit_cost());
			ps.setString(5, cost.getStatus());
			ps.setString(6, cost.getDescr());
			ps.setDate(7, (Date) cost.getCreatime());
			ps.setDate(8, (Date) cost.getStartime());
			ps.setString(9, cost.getCost_type());
			ps.setInt(10, cost.getId());
			cost = new Cost();
			ps.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	public List<Cost> findPage(int page, int pageSize) throws Exception {
		//分页
		List<Cost> list = new ArrayList<Cost>();
		Cost cost = null;
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "select * from(select c.*,rownum r from cost c where rownum<?)where r>?";
			PreparedStatement ps = conn.prepareStatement(sql);
			//小于下一页的最小值
			int nextMin = page * pageSize + 1;
			ps.setInt(1, nextMin);
			//大于上一页的最大值
			int lastMax = (page - 1) * pageSize;
			ps.setInt(2, lastMax);
			ResultSet rs = ps.executeQuery();
//			System.out.println(rs.toString());
			while(rs.next()){
				cost = getCost(rs);
				list.add(cost);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	//获得总页数
	public int findTotalPage(int pageSize) throws Exception {
		int totalPage = 0;
		int totalRow = 0;
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "select count(*) from cost";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				totalRow = rs.getInt(1);
			}
			if(totalRow % pageSize == 0){
				totalPage = totalRow / pageSize;
			}else{
				totalPage = totalRow / pageSize + 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return totalPage;
	}
	
	//查询资费名称是否重复
	public Cost findByName(String name) throws Exception {
		Cost cost = null;
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "select * from cost where name = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, name);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				cost = getCost(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cost;
	}
	
	private Cost getCost(ResultSet rs) throws SQLException {
		Cost cost = new Cost();
		cost.setId(rs.getInt("id"));
		cost.setName(rs.getString("name"));
		cost.setBase_duration(rs.getInt("base_duration"));
		cost.setBase_cost(rs.getDouble("base_cost"));
		cost.setUnit_cost(rs.getDouble("unit_cost"));
		cost.setStatus(rs.getString("status"));
		cost.setDescr(rs.getString("descr"));
		cost.setCreatime(rs.getDate("creatime"));
		cost.setStartime(rs.getDate("startime"));
		cost.setCost_type(rs.getString("cost_type"));
		return cost;
	}

}

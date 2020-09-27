package com.netctoss.cost.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.junit.Ignore;
import org.junit.Test;

import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DBUtil;

public class CostDAOImpl implements ICostDAO {

	public static Session session() {
		Configuration c = new Configuration();
		c.configure("/hibernate.cfg.xml");
		SessionFactory fc = c.buildSessionFactory();
		Session session = fc.openSession();
		return session;
	}

	@Ignore
	public void test() throws DAOException {
		CostDAOImpl daoImpl = new CostDAOImpl();
		daoImpl.deleteById(31);
	}

	public static void main(String[] args) throws DAOException {
		CostDAOImpl c = new CostDAOImpl();
		Session session = CostDAOImpl.session();
		Cost cost = (Cost) session.get(Cost.class, 32);

		// cost.setBaseCost(100.10);
		c.modify(cost);

	}

	public void deleteById(int id) throws DAOException {
		// TODO Auto-generated method stub
		Session ss = CostDAOImpl.session();
		Cost cost = (Cost) ss.get(Cost.class, id);
		Transaction tr = ss.beginTransaction();
		ss.delete(cost);
		tr.commit();
		ss.close();

	}

	 public List<Cost> findAll() throws DAOException {
	 // TODO Auto-generated method stub
	 Query a=CostDAOImpl.session().createQuery("from Cost ");
	 List<Cost> list=a.list();
	 for(Cost c:list){
	 System.out.println(c);
	 }
	 return list;
	 }

	@Ignore
	public Cost findById(int id) throws DAOException {
		// public void findById(){
		Cost c = (Cost) CostDAOImpl.session().get(Cost.class, id);
		System.out.println(c.getName() + c.getCostType() + c.getDescr());
		return c;

	}

	public Cost findByName(String name) throws DAOException {
		Session session = CostDAOImpl.session();
		Query hql = session.createQuery("from Cast where name=" + name);

		return null;
	}

//	public List<Cost> findByPages(int pages, int pageSize) throws DAOException {
//		// TODO Auto-generated method stub
//		return null;
//	}

	public List<Cost> findByPagesAsc(int pages, int pageSize, String colName)
			throws DAOException {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Cost> findByPagesDesc(int pages, int pageSize, String colName)
			throws DAOException {
		// TODO Auto-generated method stub
		return null;
	}

	public int getTotalPage(int pageSize) throws DAOException {
		// TODO Auto-generated method stub
		return 0;
	}

	public void modify(Cost cost) throws DAOException {
		Session session = CostDAOImpl.session();
		// cost=(Cost)session.get(Cost.class, 32);
		// cost.setBaseCost(100.10);
		Transaction s = session.beginTransaction();

		session.update(cost);
		s.commit();

	}

	// 添加一个
	//

	public void a() throws DAOException {
		CostDAOImpl cdi = new CostDAOImpl();
		Cost cost = new Cost();
		// 根据33找cost
		cdi.modify(cost);
	}

	public void save(Cost cost) throws DAOException {
		// TODO Auto-generated method stub
		// Cost c=new Cost();
		Session ss = CostDAOImpl.session();
		Transaction tr = ss.beginTransaction();
		// cost.setCostType("slkfd");
		Cost cost1 = new Cost();
		cost1.setName("name");
		cost1.setDescr("asdf");
		ss.save(cost1);
		tr.commit();
		ss.close();

	}

	public Cost vaildModiName(int id, String name) throws DAOException {
		// TODO Auto-generated method stub
		return null;
	}

	// try {
	// Cost cost=new Cost();
	// // cost.setCostType("sl");

	// } catch (DAOException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }

	// 2
	// try {
	// c.deleteById(30);
	// } catch (DAOException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }

	//
//	public List<Cost> findAll() throws DAOException {
//		List<Cost> costs = new ArrayList<Cost>();
//		String sql = "select * from cost";
//		Connection conn = DBUtil.getConnection();
//		PreparedStatement pst = null;
//		ResultSet rs = null;
//		try {
//			pst = conn.prepareCall(sql);
//			rs = pst.executeQuery();
//			while (rs.next()) {
//				Cost c = createCost(rs);
//				costs.add(c);
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//			throw new DAOException("查询资费数据失败", e);
//		} finally {
//			DBUtil.closeConnection();
//			try {
//				if (pst != null) {
//					pst.close();
//				}
//				if (rs != null) {
//					rs.close();
//				}
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
//
//		}
//		return costs;
//	}

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
	//
	// public int getTotalPage(int pageSize) throws DAOException {
	// int totalPage = 0;
	// Connection conn = DBUtil.getConnection();
	// PreparedStatement pst = null;
	// ResultSet rs = null;
	// String sql = "select count(*) from cost";
	// try {
	// pst = conn.prepareStatement(sql);
	// rs = pst.executeQuery();
	// if (rs.next()) {
	// int rows = rs.getInt(1);
	// totalPage = rows % pageSize == 0 ? rows / pageSize : rows
	// / pageSize + 1;
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// throw new DAOException("查询失败", e);
	// } finally {
	// try {
	// if (pst != null) {
	// pst.close();
	// }
	// if (rs != null) {
	// rs.close();
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }
	//
	// DBUtil.closeConnection();
	// }
	// return totalPage;
	// }
	//
	 public List<Cost> findByPages(int pages, int pageSize) throws
	 DAOException {
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
	//
	// public void deleteById(int id) throws DAOException {
	// Connection conn=DBUtil.getConnection();
	// PreparedStatement pst=null;
	// String sql="delete from cost where id=?";
	// try {
	// pst=conn.prepareStatement(sql);
	// pst.setInt(1, id);
	// pst.executeUpdate();
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }
	//		
	//		
	// }
	//
	// public Cost findById(int id) throws DAOException {
	// Cost c=null;
	// Connection conn=DBUtil.getConnection();
	// PreparedStatement pst=null;
	// ResultSet rs=null;
	// String sql="select * from cost_heyanguang where id=?";
	// try {
	// pst=conn.prepareStatement(sql);
	// pst.setInt(1, id);
	// rs=pst.executeQuery();
	// if(rs.next()){
	// c=createCost(rs);
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }
	// return c;
	// }
	//
	// public Cost findByName(String name) throws DAOException {
	// Cost c=null;
	// Connection conn=DBUtil.getConnection();
	// PreparedStatement pst=null;
	// ResultSet rs=null;
	// String sql="select * from cost where name=?";
	// try {
	// pst=conn.prepareStatement(sql);
	// pst.setString(1, name);
	// rs=pst.executeQuery();
	// if(rs.next()){
	// c=createCost(rs);
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }
	// return c;
	// }
	//
	// public void modify(Cost cost) throws DAOException {
	// if(cost==null){
	// return;
	// }
	// Connection conn=DBUtil.getConnection();
	// String sql="update cost set name=?,base_duration=?," +
	// "base_cost=?,unit_cost=?,descr=?," +
	// "cost_type=? where id=?";
	// PreparedStatement pst=null;
	// try {
	// pst=conn.prepareStatement(sql);
	// pst.setString(1, cost.getName());
	// pst.setInt(2, cost.getBaseDuration());
	// pst.setDouble(3, cost.getBaseCost());
	// pst.setDouble(4, cost.getUnitCost());
	// pst.setString(5, cost.getDescr());
	// pst.setString(6,cost.getCostType());
	// pst.setInt(7, cost.getId());
	// pst.executeUpdate();
	// } catch (SQLException e) {
	// e.printStackTrace();
	// throw new DAOException("更新失败",e);
	// }finally{
	// DBUtil.closeConnection();
	// }
	// }
	//
	// public void save(Cost cost) throws DAOException {
	// if(cost.getBaseDuration()==null){
	// cost.setBaseDuration(0);
	// }
	// if(cost.getBaseCost()==null){
	// cost.setBaseCost(0.0);
	// }
	// if(cost.getUnitCost()==null){
	// cost.setUnitCost(0.0);
	// }
	// System.out.println(cost);
	// Connection conn=DBUtil.getConnection();
	// String sql="insert into cost " +
	// "values(cost_id.nextval,?,?,?,?,'1',?,default,null,?)";
	// try {
	// PreparedStatement pst=conn.prepareStatement(sql);
	// pst.setString(1, cost.getName());
	// pst.setDouble(2, cost.getBaseDuration());
	// pst.setDouble(3,cost.getBaseCost());
	// pst.setDouble(4, cost.getUnitCost());
	// pst.setString(5,cost.getDescr());
	// pst.setString(6, cost.getCostType());
	// pst.executeUpdate();
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }finally{
	// DBUtil.closeConnection();
	// }
	//		
	// }
	//
	// public Cost vaildModiName(int id, String name) throws DAOException {
	// Cost cost=null;
	// Connection conn=DBUtil.getConnection();
	// PreparedStatement pst=null;
	// ResultSet rs=null;
	// String sql="select * from cost where name=? and id<>?";
	// try {
	// pst=conn.prepareStatement(sql);
	// pst.setString(1, name);
	// pst.setInt(2, id);
	// rs=pst.executeQuery();
	// if(rs.next()){
	// cost=createCost(rs);
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }finally{
	// DBUtil.closeConnection();
	// }
	// return cost;
	// }
	//
	// public List<Cost> findByPagesAsc(int pages, int pageSize, String colName)
	// throws DAOException {
	// List<Cost> lists = new ArrayList<Cost>();
	// Connection conn = null;
	// PreparedStatement pst = null;
	// ResultSet rs = null;
	// String sql = "select * from (select a.*,rownum rn from " +
	// "(select * from cost order by "+
	// colName+") a where rownum<?) where rn>=?";
	// try {
	// conn = DBUtil.getConnection();
	// pst = conn.prepareStatement(sql);
	// int start = pageSize * (pages - 1) + 1;
	// int end = start + pageSize;
	// pst.setInt(1, end);
	// pst.setInt(2, start);
	// rs = pst.executeQuery();
	// while (rs.next()) {
	// Cost c = createCost(rs);
	// lists.add(c);
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// } finally {
	// try {
	// if (pst != null) {
	// pst.close();
	// }
	// if (rs != null) {
	// rs.close();
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }
	// DBUtil.closeConnection();
	// }
	// return lists;
	// }
	//
	// public List<Cost> findByPagesDesc(int pages, int pageSize, String
	// colName)
	// throws DAOException {
	// List<Cost> lists = new ArrayList<Cost>();
	// Connection conn = null;
	// PreparedStatement pst = null;
	// ResultSet rs = null;
	// String sql = "select * from (select a.*,rownum rn from " +
	// "(select * from cost order by "+
	// colName+" desc) a where rownum<?) where rn>=?";
	// try {
	// conn = DBUtil.getConnection();
	// pst = conn.prepareStatement(sql);
	// int start = pageSize * (pages - 1) + 1;
	// int end = start + pageSize;
	// pst.setInt(1, end);
	// pst.setInt(2, start);
	// rs = pst.executeQuery();
	// while (rs.next()) {
	// Cost c = createCost(rs);
	// lists.add(c);
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// } finally {
	// try {
	// if (pst != null) {
	// pst.close();
	// }
	// if (rs != null) {
	// rs.close();
	// }
	// } catch (SQLException e) {
	// e.printStackTrace();
	// }
	// DBUtil.closeConnection();
	// }
	// return lists;
	// }

}

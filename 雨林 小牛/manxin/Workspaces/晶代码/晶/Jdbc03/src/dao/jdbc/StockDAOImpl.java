package dao.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBUtil;
import dao.IStockDAO;
import entity.Stock;

public class StockDAOImpl implements IStockDAO{

	@Override
	public Stock findbyStockNo(String stockNo) throws Exception {
		Stock s = null;
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try{
			conn = DBUtil.getConnection();
			String sql = "select * from t_stock " +
					"where stockNo=?";
			stat = conn.prepareStatement(sql);
			stat.setString(1, stockNo);
			rst = stat.executeQuery();
			if(rst.next()){
				s = new Stock();
				s.setId(rst.getInt("id"));
				s.setStockNo(stockNo);
				s.setQty(rst.getInt("qty"));
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
			DBUtil.close(conn);
		}
		return s;
	}

	@Override
	public void modify(Stock s) throws Exception {
		Connection conn = null;
		PreparedStatement stat = null;
		try{
			conn = DBUtil.getConnection();
			String sql = "update t_stock set " +
					"qty=? where stockNo=?";
			stat = conn.prepareStatement(sql);
			stat.setInt(1, s.getQty());
			stat.setString(2, s.getStockNo());
			stat.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close(conn);
		}
	}

}

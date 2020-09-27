package dao.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBUtil;

import dao.IAccountDAO;
import entity.Account;

public class AccountDAOImpl implements IAccountDAO{

	@Override
	public Account findByAccountNo(
			String accountNo) throws Exception {
		Account a = null;
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try{
			conn = DBUtil.getConnection();
			String sql = "select * from t_account " +
					"where accountNo=?";
			stat = conn.prepareStatement(sql);
			stat.setString(1, accountNo);
			rst = stat.executeQuery();
			if(rst.next()){
				a = new Account();
				a.setAccountNo(accountNo);
				a.setBalance(rst.getInt("balance"));
				a.setId(rst.getInt("id"));
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
		return a;
	}

	@Override
	public void modify(Account a) throws Exception {
		Connection conn = null;
		PreparedStatement stat = null;
		try{
			conn = DBUtil.getConnection();
			String sql = "update t_account set " +
					"balance=? where accountNo=?";
			stat = conn.prepareStatement(sql);
			stat.setInt(1, a.getBalance());
			stat.setString(2, a.getAccountNo());
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

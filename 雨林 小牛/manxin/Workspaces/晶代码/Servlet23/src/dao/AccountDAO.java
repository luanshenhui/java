package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBUtil;
import entity.Account;

public class AccountDAO {
	public Account findByAccountNo(
			String accountNo) throws Exception{
		Account a = null;
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try{
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement(
					"select * from t_account where " +
					"accountNo=?");
			stat.setString(1, accountNo);
			rst = stat.executeQuery();
			if(rst.next()){
				a = new Account();
				a.setAccountNo(accountNo);
				a.setBalance(rst.getDouble("balance"));
				a.setId(rst.getInt("id"));
			}
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}finally{
			if( rst!= null){
				rst.close();
			}
			if(stat  != null){
				stat.close();
			}
			DBUtil.close();
		}
		return a;
	}
}

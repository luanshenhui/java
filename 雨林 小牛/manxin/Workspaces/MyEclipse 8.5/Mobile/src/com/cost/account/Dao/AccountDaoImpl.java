package com.cost.account.Dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cost.account.entity.Account;
import com.cost.util.DBUtil;

public class AccountDaoImpl implements AccountDao{

	public List<Account> findByCondition(String idcardNo, String realName,
			String loginName, String status, int page, int pageSize) throws Exception {
		//根据条件拼SQL
		List<Object> params = new ArrayList<Object>();
		String sql = "select * from(select a.*,rownum r from account a " + "where 1=1 ";
		if(idcardNo != null && idcardNo.length() > 0) {
			sql += "and IDCARD_NO=? ";
			params.add(idcardNo);
		}
		if(realName != null && realName.length() > 0) {
			sql += "and REAL_NAME=? ";
			params.add(realName);
		}
		if(loginName != null && loginName.length() > 0) {
			sql += "and LOGIN_NAME=? ";
			params.add(loginName);
		}
		if(status != null && !status.equals("-1")){
			sql += "and STATUS=? ";
			params.add(status);
		}
		sql += "and rownum<?";
		sql += ") where r>?";
		
		List<Account> list = new ArrayList<Account>();
		Connection con = DBUtil.getConnection();
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			int nextMin = page * pageSize + 1;
			params.add(nextMin);
			int lastMax = (page - 1) * pageSize;
			params.add(lastMax);
			for(int i=0;i<params.size();i++){
				ps.setObject(i+1, params.get(i));
			}
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				Account account = getAccount(rs);
				list.add(account);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("查询账务账号失败！", e);
		} 
		return list;
	}
	
	//查询总页数
	public int findTotalPage(String idcardNo, String realName,
			String loginName, String status, int pageSize) throws Exception {
		int totalPage = 0;
		int totalRow = 0;
		List<Object> params = new ArrayList<Object>();
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "select count(*) from account" + " where 1=1";
			if(idcardNo != null && idcardNo.length() > 0) {
				sql += "and IDCARD_NO=? ";
				params.add(idcardNo);
			}
			if(realName != null && realName.length() > 0) {
				sql += "and REAL_NAME=? ";
				params.add(realName);
			}
			if(loginName != null && loginName.length() > 0) {
				sql += "and LOGIN_NAME=? ";
				params.add(loginName);
			}
			if(status != null && !status.equals("-1")){
				sql += "and STATUS=? ";
				params.add(status);
			}
			PreparedStatement ps = conn.prepareStatement(sql);
			for(int i=0;i<params.size();i++){
				ps.setObject(i+1, params.get(i));
			}
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

	public void pause(int id) throws Exception {
		// 暂停
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "update account set status='1',pause_date=sysdate where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("暂停账务账号失败！",e);
		}
	}

	public void start(int id) throws Exception{
		// 开通
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "update account set status='0',pause_date=null where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("开通账务账号失败！", e);
		}
	}
/*
 * id number(9) primary key,
recommender_id number(9),
login_name varchar2(30) unique not null,
login_passwd varchar2(30)  not null,
status char check (status in(0,1,2)) ,
create_date date,
pause_date date,
close_date date,
real_name varchar(20) not null,
idcard_no char(18) unique not null,
birthdate date,
gender char check(gender in(0,1)),
occupation varchar2(50),
telephone varchar2(15),
email varchar2(50),
mailaddress varchar2(50),
zipcode char(6),
qq varchar2(15),
last_login_time date,
last_login_ip varchar2(15),*/
	
	public void saveAccount(Account account)  throws Exception{
		//添加
		Connection conn = DBUtil.getConnection();
		String sql = "insert into account values(account_id.nextval" +
				",?,?,?,'1',sysdate,null,null,?,?,?,?,?,?,?,?,?,?,null,null)" ;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setObject(1, account.getRecommender_id());
			ps.setObject(2, account.getLogin_name());
			ps.setObject(3, account.getLogin_passwd());
			ps.setObject(4, account.getReal_name());
			ps.setObject(5, account.getIdcard_no());
			ps.setObject(6, account.getBirthdate());
			ps.setObject(7, account.getGender());
			ps.setObject(8, account.getOccupation());
			ps.setObject(9, account.getTelephone());
			ps.setObject(10, account.getEmail());
			ps.setObject(11, account.getMailaddress());
			ps.setObject(12, account.getZipcode());
			ps.setObject(13, account.getQq());
			
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	//根据身份证号查询
	public Account findByIdcardNo(String idcardNo) throws Exception{
		Connection conn = DBUtil.getConnection();
		String sql = "select * from account where idcard_no=?";
		Account account = null;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, idcardNo);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				account = getAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return account;
	}

	public Account findById(int id) throws Exception {
		// 根据ID查询
		Connection conn = DBUtil.getConnection();
		String sql = "select * from account where id=?";
		Account account = null;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				account = getAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return account;
	}

	public void delAccount(int id) throws Exception {
		// 删除
		Connection conn = DBUtil.getConnection();
		String sql = "update account set status='2',pause_date=null where id=?";
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("删除账号失败", e);
		}
	}

	public Account findByIdPwd(int id, String password) throws Exception {
		// id和密码查询
		Connection conn = DBUtil.getConnection();
		String sql = "select * from account where id=? and login_passwd=?";
		Account account = null;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.setString(2, password);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				account = getAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return account;
	}

	public void upAccount(Account account) throws Exception {
		// 修改
		Connection conn = DBUtil.getConnection();
		String sql = "update account set recommender_id=?,login_name=?,login_passwd=?,real_name=?,idcard_no=?" +
				",birthdate=?,gender=?,occupation=?,telephone=?,email=?,mailaddress=?,zipcode=?,qq=?" +
				" where id=?";
		Account acc = this.findByIdcardNo(account.getIdcard_no());
		
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, acc.getId());
			ps.setString(2, account.getLogin_name());
			ps.setString(3, account.getLogin_passwd());
			ps.setString(4, account.getReal_name());
			ps.setString(5, account.getIdcard_no());
			ps.setDate(6, (Date) account.getBirthdate());
			ps.setString(7, account.getGender());
			ps.setString(8, account.getOccupation());
			ps.setString(9, account.getTelephone());
			ps.setString(10, account.getEmail());
			ps.setString(11, account.getMailaddress());
			ps.setString(12, account.getZipcode());
			ps.setString(13, account.getQq());
			ps.setInt(14, account.getId());
			
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	private Account getAccount(ResultSet rs) throws SQLException{
		Account account = new Account();
		account.setId(rs.getInt(1));
		account.setRecommender_id(rs.getInt(2));
		account.setLogin_name(rs.getString(3));
		account.setLogin_passwd(rs.getString(4));
		account.setStatus(rs.getString(5));
		account.setCreate_date(rs.getDate(6));
		account.setPause_date(rs.getDate(7));
		account.setClose_date(rs.getDate(8));
		account.setReal_name(rs.getString(9));
		account.setIdcard_no(rs.getString(10));
		account.setBirthdate(rs.getDate(11));
		account.setGender(rs.getString(12));
		account.setOccupation(rs.getString(13));
		account.setTelephone(rs.getString(14));
		account.setEmail(rs.getString(15));
		account.setMailaddress(rs.getString(16));
		account.setZipcode(rs.getString(17));
		account.setQq(rs.getString(18));
		account.setLast_login_time(rs.getDate(19));
		account.setLast_login_ip(rs.getString(20));
		return account;
	}

}

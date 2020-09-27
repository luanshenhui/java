package com.netctoss.account.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.netctoss.account.entity.Account;
import com.netctoss.account.entity.QueryCodi;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DBUtil;

public class AccountDAOImpl implements IAccountDAO {

	public List<Account> findAll() throws DAOException {
		List<Account> list = new ArrayList<Account>();
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from account";
		try {
			pst = conn.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				Account a = createAccount(rs);
				list.add(a);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("查询所有账户失败", e);
		} finally {
			DBUtil.closeConnection();
		}
		return list;
	}

	private Account createAccount(ResultSet rs) throws SQLException {
		Account a = new Account();
		a.setId(rs.getInt("id"));
		a.setRecommenderId(rs.getInt("recommender_id"));
		a.setLoginName(rs.getString("login_name"));
		a.setLoginPassword(rs.getString("login_passwd"));
		a.setStatus(rs.getString("status"));
		a.setCreateDate(rs.getDate("create_date"));
		a.setPauseDate(rs.getDate("pause_date"));
		a.setCloseDate(rs.getDate("close_date"));
		a.setRealName(rs.getString("real_name"));
		a.setIdcardNo(rs.getString("idcard_no"));
		a.setBirthDate(rs.getDate("birthdate"));
		a.setGendar(rs.getString("gender"));
		a.setOccupation(rs.getString("occupation"));
		a.setTelephone(rs.getString("telephone"));
		a.setEmail(rs.getString("email"));
		a.setMailaddress(rs.getString("mailaddress"));
		a.setZipcode(rs.getString("zipcode"));
		a.setQq(rs.getString("qq"));
		a.setLastLoginTime(rs.getDate("last_login_time"));
		a.setLastLoginIp(rs.getString("last_login_ip"));
		return a;
	}

	public List<Account> findByCondition(QueryCodi q, int page, int pageSize)
			throws DAOException {
		List<Account> list = new ArrayList<Account>();
		List<Object> params = new ArrayList<Object>();
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from (";

		sql += "select a.*,rownum rn from account a where 1=1";
		if (q != null) {
			if (q.getIdcardNo() != null && q.getIdcardNo().length() > 0) {
				sql += "and idcard_NO=?";
				params.add(q.getIdcardNo());
			}
			if (q.getLoginName() != null && q.getLoginName().length() > 0) {
				sql += "and login_name=?";
				params.add(q.getLoginName());
			}
			if (q.getRealName() != null && q.getRealName().length() > 0) {
				sql += "and real_name=?";
				params.add(q.getRealName());
			}
			if (q.getStatus() != null && !q.getStatus().equals("-1")) {
				sql += "and status=?";
				params.add(q.getStatus());
			}
		}
		sql += "and rownum<?) where rn>=?";
		int start = pageSize * (page - 1) + 1;
		int end = start + pageSize;
		params.add(end);
		params.add(start);
		try {
			pst = conn.prepareStatement(sql);
			for (int i = 0; i < params.size(); i++) {
				pst.setObject((i + 1), params.get(i));
			}
			rs = pst.executeQuery();
			while (rs.next()) {
				Account a = createAccount(rs);
				list.add(a);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("按条件查询账户失败", e);
		} finally {
			DBUtil.closeConnection();
		}
		return list;
	}

	public int getTotalPage(QueryCodi q, int pageSize) throws DAOException {
		int total = 0;
		List<Object> params = new ArrayList<Object>();
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select count(*) from account where 1=1";
		if (q != null) {
			if (q.getIdcardNo() != null && q.getIdcardNo().length() > 0) {
				sql += "and idcard_NO=?";
				params.add(q.getIdcardNo());
			}
			if (q.getLoginName() != null && q.getLoginName().length() > 0) {
				sql += "and login_name=?";
				params.add(q.getLoginName());
			}
			if (q.getRealName() != null && q.getRealName().length() > 0) {
				sql += "and real_name=?";
				params.add(q.getRealName());
			}
			if (q.getStatus() != null && !q.getStatus().equals("-1")) {
				sql += "and status=?";
				params.add(q.getStatus());
			}
		}
		try {
			pst = conn.prepareStatement(sql);
			for (int i = 0; i < params.size(); i++) {
				pst.setObject(i + 1, params.get(i));
			}
			rs = pst.executeQuery();
			if (rs.next()) {
				int rows = rs.getInt(1);
				total = rows % pageSize == 0 ? rows / pageSize : rows
						/ pageSize + 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("查询总页数失败", e);
		}

		return total;
	}

	public Account findById(int id) throws DAOException {
		Account a = null;
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from account where id=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			rs = pst.executeQuery();
			if (rs.next()) {
				a = createAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据ID查询Account失败", e);
		} finally {
			DBUtil.closeConnection();
		}
		return a;
	}

	public void setStart(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update account set status='0',pause_date=null where id=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("开通帐号失败", e);
		} finally {
			DBUtil.closeConnection();
		}

	}

	public void setPause(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update account set status='1',pause_date=sysdate where id=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("暂停帐号失败", e);
		} finally {
			DBUtil.closeConnection();
		}

	}

	public void setDelete(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update account set status='2',pause_date=null where id=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("删除帐号失败", e);
		} finally {
			DBUtil.closeConnection();
		}

	}

	public void saveAccount(Account a) throws DAOException {
		if (a == null) {
			return;
		}
		String sql = "insert into account values(hyg_account_id.nextval,?,?,?,'0',sysdate,?,?,?,?,?,?,?,?,?,?,?,?,null,null)";
		Connection conn = DBUtil.getConnection();
		try {
			PreparedStatement pst = conn.prepareStatement(sql);
			int index = 1;
			pst.setObject(index++, a.getRecommenderId());
			pst.setObject(index++, a.getLoginName());
			pst.setObject(index++, a.getLoginPassword());
			pst.setObject(index++, a.getPauseDate());
			pst.setObject(index++, a.getCloseDate());
			pst.setObject(index++, a.getRealName());
			pst.setObject(index++, a.getIdcardNo());
			pst.setObject(index++, a.getBirthDate());
			pst.setObject(index++, a.getGendar());
			pst.setObject(index++, a.getOccupation());
			pst.setObject(index++, a.getTelephone());
			pst.setObject(index++, a.getEmail());
			pst.setObject(index++, a.getMailaddress());
			pst.setObject(index++, a.getZipcode());
			pst.setObject(index++, a.getQq());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("新增账务帐号失败", e);
		} finally {
			DBUtil.closeConnection();
		}
	}

	public Account findByIdcardNo(String idcardNo) throws DAOException {
		if (idcardNo == null) {
			return null;
		}
		Account a = null;
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from account where IDCARD_NO=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setString(1, idcardNo);
			rs = pst.executeQuery();
			if (rs.next()) {
				a = createAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据身份证号查询Account失败", e);
		} finally {
			DBUtil.closeConnection();
		}
		return a;
	}

	public void modifyAccount(Account a) throws DAOException {
		if(a==null){
			return;
		}
		String sql = "update account set real_name=?," +
				"login_passwd=?,telephone=?,recommender_id=?,"
				+ "email=?,occupation=?,gender=?,mailaddress=?,zipcode=?,qq=? where id=?";
		Connection conn=DBUtil.getConnection();
		try {
			
			PreparedStatement pst=conn.prepareStatement(sql);
			int index=1;
			pst.setObject(index++, a.getRealName());
			pst.setObject(index++, a.getLoginPassword());
			pst.setObject(index++, a.getTelephone());
			pst.setObject(index++, a.getRecommenderId());
			pst.setObject(index++, a.getEmail());
			pst.setObject(index++, a.getOccupation());
			pst.setObject(index++, a.getGendar());
			pst.setObject(index++, a.getMailaddress());
			pst.setObject(index++, a.getZipcode());
			pst.setObject(index++, a.getQq());
			pst.setObject(index++, a.getId());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("修改失败",e);
		}
	}

	public Account findByIdAndPwd(int id, String password) throws DAOException {
		Account a = null;
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		ResultSet rs = null;
		String sql = "select * from account where id=? and login_passwd=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.setString(2, password);
			rs = pst.executeQuery();
			if (rs.next()) {
				a = createAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据ID和loginpwd查询Account失败", e);
		} finally {
			DBUtil.closeConnection();
		}
		return a;
	}

	public void deleteServiceByAccountId(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update service set status='2',pause_date=null where account_id=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("删除业务帐号失败", e);
		} finally {
			DBUtil.closeConnection();
		}

	}

	public void pauseServiceByAccountId(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update service set status='1',pause_date=sysdate where account_id=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("暂停业务帐号失败", e);
		} finally {
			DBUtil.closeConnection();
		}

	}

}

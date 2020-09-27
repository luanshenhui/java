package com.service.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cost.account.entity.Account;
import com.cost.util.DBUtil;
import com.service.entity.Service;
import com.service.entity.VO;

public class ServiceDaoImpl implements ServiceDao{

	public List<VO> findByCondition(String os_username, String unix_host,
			String idcard_no, String status, int page, int pageSize)
			throws Exception {
		// 查询
		List<Object> params = new ArrayList<Object>();
		String sql = "select * from(" +
				"select s.*,a.idcard_no,a.real_name,c.name,c.descr,rownum r from service s inner join account a" +
				" on s.account_id=a.id" +
				" inner join " +
				"cost c on s.cost_id=c.id" +
				" where 1=1 ";
		if(os_username != null && os_username.length() > 0){
			sql += "and os_username=? ";
			params.add(os_username);
		}
		if(unix_host != null && unix_host.length() > 0){
			sql += "and unix_host=? ";
			params.add(unix_host);
		}
		if(idcard_no != null && idcard_no.length() > 0){
			sql += "and idcard_no=? ";
			params.add(idcard_no);
		}
		if(status != null && !status.equals("-1")){
			sql += "and status=? ";
			params.add(status);
		}
		sql += "and rownum<?";
		sql += ") where r>?";
		List<VO> list = new ArrayList<VO>();
		Connection conn = DBUtil.getConnection();
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			int nextMin = page * pageSize + 1;
			params.add(nextMin);
			int lastMax = (page - 1) * pageSize;
			params.add(lastMax);
			for(int i=0;i<params.size();i++){
				ps.setObject(i+1, params.get(i));
			}
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				VO vo = createVO(rs);
				list.add(vo);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("查询业务账号失败！", e);
		}
		return list;
	}
	
	public int findTotalPage(String os_username, String unix_host,
			String idcard_no, String status, int pageSize) throws Exception {
		// 查询总页数
		int totalPage = 0;
		int totalRow = 0;
		List<Object> params = new ArrayList<Object>();
		Connection conn = DBUtil.getConnection();
		String sql = "select count(*) from(select * from service s inner join account a on s.account_id=a.id" +
				" inner join cost c on s.cost_id=c.id)" +
				"where 1=1 ";
		if(os_username != null && os_username.length() > 0){
			sql += "and os_username=? ";
			params.add(os_username);
		}
		if(unix_host != null && unix_host.length() > 0){
			sql += "and unix_host=? ";
			params.add(unix_host);
		}
		if(idcard_no != null && idcard_no.length() > 0){
			sql += "and idcard_no=? ";
			params.add(idcard_no);
		}
		if(status != null && !status.equals("-1")){
			sql += "and status=? ";
			params.add(status);
		}
		try {
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
		//暂停
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "update service set status='1',pause_date=sysdate where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("暂停业务账号失败", e);
		}
	}

	public void start(int id) throws Exception {
		// 开通
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "update service set status='0',pause_date=sysdate where id=?";
			PreparedStatement ps;
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("开通业务账号失败", e);
		}
	}

	public void delService(int id) throws Exception {
		// 删除
		Connection conn = DBUtil.getConnection();
		String sql = "delete service where id = ?";
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void saveService(Service service) throws Exception {
		// 添加
		Connection conn = DBUtil.getConnection();
		String sql = "insert into service values(serviceId.nextval,?,?,?,?,'0',sysdate,null,null,?)";
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, service.getAccount_id());
			ps.setString(2, service.getUnix_host());
			ps.setString(3, service.getOs_username());
			ps.setString(4, service.getLogin_passwd());
			ps.setInt(5, service.getCost_id());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("添加业务账号失败", e);
		}
	}
	
	public Account findAccountByServiceId(int serviceId) throws Exception {
		//根据业务账号查询账务账号
		Account account = null;
		String sql="select * from account where id in " +
				"(select account_id from service where id=?)";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1, serviceId);
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				account = getAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("根据业务帐号查询帐务帐号失败",e);
		}
		return account;
	}

	public VO findById(int id) throws Exception {
		// 根据id查询
		Connection conn = DBUtil.getConnection();
		String sql = "select s.*,a.real_name,a.idcard_no,c.name,c.descr "+
		"from service s join  cost c on s.cost_id=c.id "+
		"join account a on a.id=s.account_id where s.id=?";
		VO vo = null;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				vo = new VO();
				vo.setId(rs.getInt(1));
				vo.setAccount_id(rs.getInt(2));
				vo.setUnix_host(rs.getString(3));
				vo.setOs_username(rs.getString(4));
				vo.setLogin_passwd(rs.getString(5));
				vo.setStatus(rs.getString(6));
				vo.setCreate_date(rs.getDate(7));
				vo.setPause_date(rs.getDate(8));
				vo.setClose_date(rs.getDate(9));
				vo.setCost_id(rs.getInt(10));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return vo;
	}

	public void upService(Service service) {
		// 修改
		Connection conn = DBUtil.getConnection();
		
		
	}
	
	private VO createVO(ResultSet rs) throws Exception {
		VO vo = new VO();
		vo.setId(rs.getInt(1));
		vo.setAccount_id(rs.getInt(2));
		vo.setUnix_host(rs.getString(3));
		vo.setOs_username(rs.getString(4));
		vo.setLogin_passwd(rs.getString(5));
		vo.setStatus(rs.getString(6));
		vo.setCreate_date(rs.getDate(7));
		vo.setPause_date(rs.getDate(8));
		vo.setClose_date(rs.getDate(9));
		vo.setCost_id(rs.getInt(10));
		vo.setIdcard_no(rs.getString(11));
		vo.setReal_name(rs.getString(12));
		vo.setName(rs.getString(13));
		vo.setDescr(rs.getString(14));
		return vo;
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

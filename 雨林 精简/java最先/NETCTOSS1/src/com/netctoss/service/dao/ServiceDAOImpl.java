package com.netctoss.service.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.service.entity.QueryCodi;
import com.netctoss.service.entity.Service;
import com.netctoss.service.entity.ServiceUpdate;
import com.netctoss.service.vo.ServiceVO;
import com.netctoss.util.DBUtil;

public class ServiceDAOImpl implements IServiceDAO{

	public List<ServiceVO> findByCodition(QueryCodi q, int page, int pageSize)
			throws DAOException {
		List<ServiceVO> list=new ArrayList<ServiceVO>();
		StringBuffer sql=new StringBuffer();
		sql.append("select * from (");
		sql.append("select s.*,a.real_name,a.idcard_no,c.name,c.descr,rownum rn ");
		sql.append("from service s inner join ");
		sql.append("account a on s.account_id=a.id ");
		sql.append("inner join cost c on s.cost_id=c.id ");
		sql.append("where 1=1 ");
		List<Object> params=new ArrayList<Object>();
		if(q!=null){
			if(q.getOsUsername()!=null&&q.getOsUsername().length()>0){
				sql.append("and s.os_username=? ");
				params.add(q.getOsUsername());
			}
			if(q.getUnixHost()!=null&&q.getUnixHost().length()>0){
				sql.append("and s.unix_host=? ");
				params.add(q.getUnixHost());
			}
			if(q.getIdcardNo()!=null&&q.getIdcardNo().length()>0){
				sql.append("and a.idcard_no=? ");
				params.add(q.getIdcardNo());
			}
			if(!q.getStatus().equals("-1")&&q.getStatus().length()>0){
				sql.append("and s.status=? ");
				params.add(q.getStatus());
			}
		}
		sql.append("and rownum<?) where rn>=? ");
		int start=(page-1)*pageSize+1;
		int end=start+pageSize;
		params.add(end);
		params.add(start);
		Connection conn=DBUtil.getConnection();
		String str=new String(sql);
		try {
			PreparedStatement pst=conn.prepareStatement(str);
			for(int i=0;i<params.size();i++){
				pst.setObject(i+1, params.get(i));
			}
			ResultSet rs=pst.executeQuery();
			while(rs.next()){
				ServiceVO s=createServiceVO(rs);
				list.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据条件查询失败",e);
		}
		return list;
	}

	private ServiceVO createServiceVO(ResultSet rs) throws SQLException {
		ServiceVO s=new ServiceVO();
		s.setId(rs.getInt("id"));
		s.setAccountId(rs.getInt("account_id"));
		s.setUnixHost(rs.getString("unix_host"));
		s.setOsUsername(rs.getString("os_username"));
		s.setLoginPasswd(rs.getString("login_passwd"));
		s.setStatus(rs.getString("status"));
		s.setCreateDate(rs.getDate("create_date"));
		s.setPauseDate(rs.getDate("pause_date"));
		s.setCloseDate(rs.getDate("close_date"));
		s.setCostId(rs.getInt("cost_id"));
		s.setRealName(rs.getString("real_name"));
		s.setIdcardNo(rs.getString("idcard_no"));
		s.setCostName(rs.getString("name"));
		s.setDescr(rs.getString("descr"));
		return s;
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

	public int getTotalPage(QueryCodi q, int pageSize) throws DAOException {
		int totalPage=0;
		StringBuffer sb=new StringBuffer();
		sb.append("select count(*) ");
		sb.append("from service s inner join ");
		sb.append("account a on s.account_id=a.id ");
		sb.append("inner join cost c on s.cost_id=c.id ");
		sb.append("where 1=1 ");
		List<Object> params=new ArrayList<Object>();
		if(q!=null){
			if(q.getOsUsername()!=null&&q.getOsUsername().length()>0){
				sb.append("and s.os_username=? ");
				params.add(q.getOsUsername());
			}
			if(q.getUnixHost()!=null&&q.getUnixHost().length()>0){
				sb.append("and s.unix_host=? ");
				params.add(q.getUnixHost());
			}
			if(q.getIdcardNo()!=null&&q.getIdcardNo().length()>0){
				sb.append("and a.idcard_no=? ");
				params.add(q.getIdcardNo());
			}
			if(!q.getStatus().equals("-1")&&q.getStatus().length()>0){
				sb.append("and s.status=? ");
				params.add(q.getStatus());
			}
		}
		Connection conn=DBUtil.getConnection();
		String sql=new String(sb);
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			for(int i=0;i<params.size();i++){
				pst.setObject(i+1, params.get(i));
			}
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				int rows=rs.getInt(1);
				totalPage=rows%pageSize==0?rows/pageSize:rows/pageSize+1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return totalPage;
	}

	public void SetStart(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update service set status='0',pause_date=null where id=?";
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, id);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("开通业务帐号失败", e);
		} finally {
			DBUtil.closeConnection();
		}

	}

	public Account findAccountByServiceId(int serviceId) throws DAOException {
		Account a=null;
		String sql="select * from account where id in " +
				"(select account_id from service where id=?)";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1, serviceId);
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				a=createAccount(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据业务帐号查询帐务帐号失败",e);
		}finally{
			DBUtil.closeConnection();
		}
		return a;
	}

	public void SetDelete(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update service set status='2',pause_date=null where id=?";
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

	public void SetPause(int id) throws DAOException {
		Connection conn = DBUtil.getConnection();
		PreparedStatement pst = null;
		String sql = "update service set status='1',pause_date=sysdate where id=?";
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

	public void save(Service s) throws DAOException {
		if(s==null){
			return;
		}
		String sql="insert into service values" +
				"(service_id_seq.nextval,?,?,?,?,'0',sysdate,null,null,?)";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setObject(1, s.getAccountId());
			pst.setString(2, s.getUnixHost());
			pst.setString(3,s.getOsUsername());
			pst.setString(4,s.getLoginPasswd());
			pst.setObject(5, s.getCostId());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("新增服务明细失败",e);
		}finally{
			DBUtil.closeConnection();
		}
		
	}

	public ServiceVO findById(int id) throws DAOException {
		ServiceVO s=null;
		String sql="select s.*,a.real_name,a.idcard_no,c.name,c.descr "+
		"from service s join  cost c on s.cost_id=c.id "+
		"join account a on a.id=s.account_id where s.id=?";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1, id);
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				s=createServiceVO(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据ID查询业务明细失败",e);
		}
		
		return s;
	}

	public void saveServiceBak(ServiceUpdate sud) throws DAOException {
		if(sud==null){
			return;
		}
		String sql="insert into service_update_bak values(service_bak_id_seq.nextval,?,?)";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1, sud.getServiceId());
			pst.setInt(2, sud.getCostId());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("更新资费失败",e);
		}finally{
			
			DBUtil.closeConnection();
		}
		
	}

	public ServiceUpdate findServiceUpdateByServiceId(int ServiceId) throws DAOException {
		ServiceUpdate sud=null;
		Connection conn=DBUtil.getConnection();
		String sql="select * from service_update_bak where service_id=?";
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1, ServiceId);
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				sud=new ServiceUpdate();
				sud.setId(rs.getInt("id"));
				sud.setServiceId(rs.getInt("service_id"));
				sud.setCostId(rs.getInt("cost_id"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			DBUtil.closeConnection();
		}
		
		return sud;
	}

	public void updateServiceUpdate(ServiceUpdate sud) throws DAOException {
		if(sud==null){
			return;
		}
		String sql="update service_update_bak set cost_id=? where service_id=?";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1, sud.getCostId());
			pst.setInt(2, sud.getServiceId());
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("更新资费备份表失败",e);
		}finally{
			DBUtil.closeConnection();
		}
	}

}

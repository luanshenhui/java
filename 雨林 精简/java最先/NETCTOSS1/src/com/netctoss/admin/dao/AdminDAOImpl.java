package com.netctoss.admin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.netctoss.admin.entity.Admin;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DBUtil;

public class AdminDAOImpl implements IAdminDAO{
	
	public List<Admin> findByCondition(Integer roleId, Integer privilegeId,
			int page, int pageSize) throws DAOException {
		List<Admin> list=new ArrayList<Admin>();
		List<Object> params =new ArrayList<Object>();
		StringBuffer sb=new StringBuffer();
		sb.append("select * from ( ");
		sb.append("select a.*,rownum rn from admin_info a ");
		sb.append("where 1=1 ");
		if(roleId!=null&&roleId.intValue()!=-1){
			sb.append("and id in( ");
			sb.append("select admin_id from " +
					"admin_role where role_id=? )");
			params.add(roleId);
		}
		if(privilegeId!=null&&privilegeId.intValue()!=-1){
			sb.append("and id in( ");
			sb.append("select a.admin_id from role_privilege p ");
			sb.append("join role r on r.id=p.role_id ");
			sb.append("join  admin_role a on a.role_id=r.id ");
			sb.append("where p.privilege_id=?)");
			params.add(privilegeId);
		}
		sb.append("and rownum<?) ");
		sb.append("where rn>=?");
		int start=(page-1)*pageSize+1;
		int end=start+pageSize;
		params.add(end);
		params.add(start);
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sb.toString());
			for (int i = 0; i < params.size(); i++) {
				pst.setObject(i+1, params.get(i));
			}
			ResultSet rs=pst.executeQuery();
			while(rs.next()){
				Admin a=createAdmin(rs);
				String sql2="select name from role where id in " +
						"(select role_id from admin_role where admin_id=? )";
				PreparedStatement pst2=conn.prepareStatement(sql2);
				pst2.setInt(1, a.getId());
				ResultSet rs2=pst2.executeQuery();
				String nameStr="";
				while(rs2.next()){
					String name=rs2.getString("name");
					nameStr+=","+name;
				}
				if(nameStr.length()>0){
					nameStr=nameStr.replaceFirst(",", "");
				}
				a.setRoleName(nameStr);
				list.add(a);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据条件查询管理员失败",e);
		}
		return list;
	}

	public int findTotalPage(Integer roleId, Integer privilegeId, int pageSize)
			throws DAOException {
		int totalPage=0;
		List<Object> params =new ArrayList<Object>();
		StringBuffer sb=new StringBuffer();
		sb.append("select count(*) from admin_info a ");
		sb.append("where 1=1 ");
		if(roleId!=null&&roleId.intValue()!=-1){
			sb.append("and id in( ");
			sb.append("select admin_id from " +
					"admin_role where role_id=? )");
			params.add(roleId);
		}
		if(privilegeId!=null&&privilegeId.intValue()!=-1){
			sb.append("and id in( ");
			sb.append("select a.admin_id from role_privilege p ");
			sb.append("join role r on r.id=p.role_id ");
			sb.append("join  admin_role a on a.role_id=r.id ");
			sb.append("where p.privilege_id=?)");
			params.add(privilegeId);
		}
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sb.toString());
			for (int i = 0; i < params.size(); i++) {
				pst.setObject(i+1, params.get(i));
			}
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				int rows=rs.getInt(1);
				totalPage=rows%pageSize==0?rows/pageSize:rows/pageSize+1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("查询总页数失败",e);
		}
		
		return totalPage;
	}
	private Admin createAdmin(ResultSet rs) throws SQLException{
		Admin admin=new Admin();
		admin.setId(rs.getInt("id"));
		admin.setAdminCode(rs.getString("admin_code"));
		admin.setPassword(rs.getString("password"));
		admin.setName(rs.getString("name"));
		admin.setTelephone(rs.getString("telephone"));
		admin.setEmail(rs.getString("email"));
		admin.setEnrollDate(rs.getDate("enrolldate"));
		return admin;
	}

	public void resetPassword(String[] ids) throws DAOException {
		if(ids==null||ids.length==0){
			return;
		}
		String sql="update admin_info set password='123456' " +
				"where id in (";
		for (int i = 0; i < ids.length; i++) {
			if(i==0){
				sql+=ids[i];
			}else{
				sql+=","+ids[i];
			}
		}
		sql+=")";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("重置密码失败",e);
		}finally{
			DBUtil.closeConnection();
		}
	}

	public void saveAdmin(Admin a) throws DAOException {
		if(a==null){
			return;
		}
		String sql="insert into admin_info " +
				"values(admin_seq.nextval,?,?,?,?,?,sysdate)";
		Connection conn=DBUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			String[] cols={"id"};
			PreparedStatement pst=conn.prepareStatement(sql,cols);
			int index=1;
			pst.setObject(index++, a.getAdminCode());
			pst.setObject(index++, a.getPassword());
			pst.setObject(index++, a.getName());
			pst.setObject(index++, a.getTelephone());
			pst.setObject(index++, a.getEmail());
			pst.executeUpdate();
			ResultSet rs=pst.getGeneratedKeys();
			int adminId=0;
			if(rs.next()){
				adminId=rs.getInt(1);
			}
			String[] roleIds=a.getRoleIds();
			String sql2="insert into admin_role values(?,?)";
			for(String roleId:roleIds){
				PreparedStatement pst2=conn.prepareStatement(sql2);
				pst2.setObject(1,adminId);
				pst2.setObject(2, roleId);
				pst2.executeUpdate();
			}
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
				throw new DAOException("增加管理员失败",e1);
			}
		}
	}

	public Admin findById(Integer id) throws DAOException {
		if(id==null){
			return null;
		}
		Admin admin=null;
		String sql="select * from admin_info where id=?";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1, id);
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				admin=createAdmin(rs);
			}
			String sql2="select role_id from admin_role where admin_id=?";
			PreparedStatement pst2=conn.prepareStatement(sql2);
			pst2.setInt(1, id);
			ResultSet rs2=pst2.executeQuery();
			List<String> roleIds=new ArrayList<String>();
			while(rs2.next()){
				roleIds.add(rs2.getString(1));
			}
			admin.setRoleIds(roleIds.toArray(new String[0]));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return admin;
	}

	public void deleteAdmin(Integer id) throws DAOException {
		String sql1="delete from admin_role where admin_id=?";
		String sql2="delete from admin_info where id=?";
		Connection conn=DBUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pst=conn.prepareStatement(sql1);
			pst.setInt(1, id);
			pst.executeUpdate();
			PreparedStatement pst2=conn.prepareStatement(sql2);
			pst2.setInt(1, id);
			pst2.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
				throw new DAOException("删除管理员失败",e1);
			}
		}
		
	}

	public void updateAdmin(Admin a) throws DAOException {
		if(a==null){
			return;
		}
		String sql="update admin_info " +
				"set name=?,telephone=?,email=? where id=?";
		Connection conn=DBUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setString(1, a.getName());
			pst.setString(2, a.getTelephone());
			pst.setString(3, a.getEmail());
			pst.setInt(4, a.getId());
			pst.executeUpdate();
			//删除中间表的数据
			String sql2="delete from admin_role where admin_id=?";
			PreparedStatement pst2=conn.prepareStatement(sql2);
			pst2.setInt(1, a.getId());
			pst2.executeUpdate();
			String sql3="insert into admin_role values(?,?)";
			
			String[] roleIds=a.getRoleIds();
			PreparedStatement pst3=conn.prepareStatement(sql3);
			for(String roleId:roleIds){
				pst3.setObject(1, a.getId());
				pst3.setObject(2, roleId);
				pst3.addBatch();
			}
			pst3.executeBatch();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
				throw new DAOException("更新管理员失败",e1);
			}
		}finally{
			DBUtil.closeConnection();
		}
	}
}

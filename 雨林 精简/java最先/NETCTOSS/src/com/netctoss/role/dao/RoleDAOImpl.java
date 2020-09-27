package com.netctoss.role.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.netctoss.exception.DAOException;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DBUtil;
import com.netctoss.util.PrivilegeReader;

public class RoleDAOImpl implements IRoleDAO {

	public List<Role> findByPage(int page, int pageSize) throws DAOException {
		List<Role> list = new ArrayList<Role>();
		String sql = "select * from (select r.*,rownum rn from " +
				"role r where rownum<?) where rn>=?";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			int start=(page-1)*pageSize+1;
			int end=start+pageSize;
			pst.setInt(1, end);
			pst.setInt(2, start);
			ResultSet rs=pst.executeQuery();
			while(rs.next()){
				Role r=createRole(rs);
				String sql2="select * from ROLE_PRIVILEGE " +
						"where role_id=?";
				PreparedStatement pst2=conn.prepareStatement(sql2);
				pst2.setInt(1, r.getId());
				ResultSet rs2=pst2.executeQuery();
				String nameStr="";
				while(rs2.next()){
					String privilegeId=rs2.getString("privilege_id");
					String privilegeName=PrivilegeReader
					.getPrivilegeNameById(privilegeId);
					nameStr+=","+privilegeName;
				}
				if(nameStr.length()>0){
					nameStr=nameStr.replaceFirst(",", "");
				}
				r.setPrivilegeName(nameStr);
				list.add(r);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("查询角色数据失败！", e);
		}
		
		return list;
	}

	private Role createRole(ResultSet rs) throws SQLException {
		Role r=new Role();
		r.setId(rs.getInt("id"));
		r.setName(rs.getString("name"));
		return r;
	}

	public int getTotalPage(int pageSize) throws DAOException {
		int totalPage=0;
		String sql="select count(*) from role ";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
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

	public void saveRole(Role role) throws DAOException {
		if(role==null){
			return;
		}
		//1.新增角色表
		String sql="insert into role " +
				"values(role_id_seq.nextval,?)";
		Connection conn=DBUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			//columns 数组制定更新完之后要返回哪几列的值
			String[] columns={"id"};
			PreparedStatement pst=conn.prepareStatement(sql,columns);
			pst.setString(1, role.getName());
			pst.executeUpdate();
			
			//2.得到刚刚插入的id
			ResultSet rs=pst.getGeneratedKeys();
			int roleId=0;
			if(rs.next()){
				roleId=rs.getInt(1);
			}
			String[] privilegeIds=role.getPrivilegeIds();
			if(privilegeIds!=null&&privilegeIds.length>0){
				String sql2="insert into role_privilege values(?,?)";
				PreparedStatement pst2=conn.prepareStatement(sql2);
				for(String privilegeId: privilegeIds){
					pst2.setInt(1, roleId);
					pst2.setInt(2, Integer.parseInt(privilegeId));
					pst2.addBatch();
				}
				pst2.executeBatch();
			}
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
				throw new DAOException("新增角色失败",e1);
			}
		}
	}

	public Role findById(int id) throws DAOException {
		Role role=null;
		String sql="select * from role where id=?";
		Connection conn=DBUtil.getConnection();
		try {
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setInt(1,id);
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				role=createRole(rs);
			}
			String sql2="select * from role_privilege where role_id=?";
			PreparedStatement pst2=conn.prepareStatement(sql2);
			pst2.setInt(1, id);
			ResultSet rs2=pst2.executeQuery();
			List<String> list=new ArrayList<String>();
			while(rs2.next()){
				String privilegeId=rs2.getString("privilege_id");
				list.add(privilegeId);
			}
			String[] privilegeIds=list.toArray(new String[0]);
			role.setPrivilegeIds(privilegeIds);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DAOException("根据ID查询角色失败",e);
		}finally{
			DBUtil.closeConnection();
		}
		
		return role;
	}

	public void updateRole(Role role) throws DAOException {
		if(role==null){
			return;
		}
		//1.更新角色表
		String sql="update role set name=? where id=?";
		Connection conn=DBUtil.getConnection();
		try {
			conn.setAutoCommit(false);
			PreparedStatement pst=conn.prepareStatement(sql);
			pst.setString(1, role.getName());
			pst.setInt(2, role.getId());
			pst.executeUpdate();
			//2.删除该角色对应的所有权限数据
			String sql2="delete from role_privilege where role_id=?";
			PreparedStatement pst2=conn.prepareStatement(sql2);
			pst2.setInt(1, role.getId());
			pst2.executeUpdate();
			//3.新增角色对应的权限数据
			String[] privilegeIds=role.getPrivilegeIds();
			if(privilegeIds!=null&&privilegeIds.length>0){
				String sql3="insert into role_privilege values(?,?)";
				PreparedStatement pst3=conn.prepareStatement(sql3);
				for(String privilegeId:privilegeIds){
					pst3.setObject(1, role.getId());
					pst3.setObject(2, privilegeId);
					pst3.addBatch();
				}
				pst3.executeBatch();
			}
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
				throw new DAOException("更新角色失败",e1);
			}
		}finally{
			DBUtil.closeConnection();
		}
		
	}

	public void deleteRole(int id) throws DAOException {
		String sql1="delete from role_privilege where role_id=?";
		String sql2="delete from role where id=?";
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
				throw new DAOException("删除角色失败",e1);
			}
		}
		
	}

	public List<Role> findAll() throws DAOException {
		List<Role> list=new ArrayList<Role>();
		String sql="select * from role";
		Connection conn=DBUtil.getConnection();
		try {
			Statement st=conn.createStatement();
			ResultSet rs=st.executeQuery(sql);
			while(rs.next()){
				Role r=createRole(rs);
				list.add(r);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}


}

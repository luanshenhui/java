package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBUtil;
import entity.User;

public class UserDAOImpl implements UserDAO{
	public void save(User user) throws SQLException{
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "insert into t_user(username,pwd,age) " +
					"values(?,?,?)";
			/*
			 * oracle :
			 * 		String sql = "insert into t_user 
			 * values(t_user_seq.nextval,?,?,?)";
			 */
			 stat = 
				conn.prepareStatement(sql);
			stat.setString(1, user.getUsername());
			stat.setString(2, user.getPwd());
			stat.setInt(3, user.getAge());
			stat.executeUpdate();
		} catch (SQLException e) {
			//����־��һ����Ҫ��¼���ļ����档
			//(���磬����ʹ��log4j)
			e.printStackTrace();
			throw e;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close(conn);
		}
	}
	
	public List<User> findAll() throws SQLException{
		List<User> users = new ArrayList<User>();
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from t_user";
			stat = conn.prepareStatement(sql);
			rst = stat.executeQuery();
			while(rst.next()){
				int id = rst.getInt(1);
				String username = rst.getString(2);
				String pwd = rst.getString(3);
				int age = rst.getInt(4);
				User user = new User();
				user.setUsername(username);
				user.setPwd(pwd);
				user.setAge(age);
				users.add(user);
			}
		} catch (SQLException e) {
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
		return users;
	}
	
	public void delete(int id) throws SQLException{
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "delete from t_user where id=?";
			stat = conn.prepareStatement(sql);
			stat.setInt(1, id);
			stat.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close(conn);
		}
	}
	
	public User findByUsername(String username) throws SQLException{
		User user = null;
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try {
			conn = DBUtil.getConnection();
			String sql = "select * from t_user " +
					"where username=?";
			stat = conn.prepareStatement(sql);
			stat.setString(1, username);
			rst = stat.executeQuery();
			if(rst.next()){
				user = new User();
				user.setId(rst.getInt("id"));
				user.setUsername(username);
				user.setPwd(rst.getString("pwd"));
				user.setAge(rst.getInt("age"));
			}
		} catch (SQLException e) {
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
		return user;
	}
	
	public void saveList(List<User> users) throws SQLException{
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);
			String sql = "insert into t_user(username,pwd,age) " +
					"values(?,?,?)";
			stat = conn.prepareStatement(sql);
			for(int i=0;i<users.size();i++){
//				if(i == 16){
					//throw new SQLException("ģ��һ���쳣�������ж�");
//				}
				User user = users.get(i);
				stat.setString(1, user.getUsername());
				stat.setString(2, user.getPwd());
				stat.setInt(3, user.getAge());
				stat.executeUpdate();
			}
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			conn.rollback();
			throw e;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close(conn);
		}
	}
	
	//����������ķ�ʽ������
	public void saveBatch(List<User> users) throws SQLException{
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);
			String sql = "insert into t_user(username,pwd,age) " +
					"values(?,?,?)";
			stat = conn.prepareStatement(sql);
			int j = 0;
			int size = 30; //ÿ��ʮ���û���һ��������
			for(int i=0;i<users.size();i++){
				j ++;
				User user = users.get(i);
				stat.setString(1, user.getUsername());
				stat.setString(2, user.getPwd());
				stat.setInt(3, user.getAge());
				//��һ�����(username,pwd,age)���
				//��stat�������档
				stat.addBatch();
				if(j == size){
					stat.executeBatch();
					//��շ���stat��������Ĳ���
					stat.clearBatch();
					j = 0;
				}
			}
			//��֮ǰ�����stat��������Ĳ���
			//һ���Եط��͸����ݿ�ȥִ�С�
			stat.executeBatch();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			conn.rollback();
			throw e;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close(conn);
		}
	}
	
	//����user�����ṩ����Ϣ���޸����ݿ��е�
	//��Ӧ�ļ�¼,Ҫ��������
	public void modify(User user) throws SQLException{
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			conn = DBUtil.getConnection();
			conn.setAutoCommit(false);
			String sql = "update t_user set username=?," +
					"pwd=?,age=? where id=?";
			stat = conn.prepareStatement(sql);
			stat.setString(1, user.getUsername());
			stat.setString(2, user.getPwd());
			stat.setInt(3, user.getAge());
			stat.setInt(4, user.getId());
			stat.executeUpdate();
			conn.commit();
		}catch (SQLException e) {
			e.printStackTrace();
			conn.rollback();
			throw e;
		}finally{
			if(stat != null){
				stat.close();
			}
			DBUtil.close(conn);
		}
	}
	
	/**
	 *  pages:�ڼ�ҳ
	 *  pageSize:ÿҳ��������¼
	 */
	public List<User> findByPages(
			int pages,int pageSize) throws SQLException{
		List<User> users = new ArrayList<User>();
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try {
			
			conn = DBUtil.getConnection();
			String sql = "select * from t_user limit ?,?";
			stat = conn.prepareStatement(sql);
			stat.setInt(1, pageSize*(pages - 1));
			stat.setInt(2, pageSize);
			rst = stat.executeQuery();
			while(rst.next()){
				User user = new User();
				user.setId(rst.getInt("id"));
				user.setUsername(rst.getString("username"));
				user.setPwd(rst.getString("pwd"));
				user.setAge(rst.getInt("age"));
				users.add(user);
			}
		} catch (SQLException e) {
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
		return users;
	}
	
	/**
	 * 	����ܵ�ҳ��
	 * @throws SQLException 
	 */
	public int getTotalPages(int pageSize) throws SQLException{
		int totalPages = 0;
		//����ܵļ�¼��
		int totalRows = 0;
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try {
			conn = DBUtil.getConnection();
			
			String sql = "select count(*) from t_user";
			stat = conn.prepareStatement(sql);
			rst = stat.executeQuery();
			if(rst.next()){
				totalRows = rst.getInt(1);
			}
			if(totalRows % pageSize == 0){
				totalPages = totalRows / pageSize;
			}else{
				totalPages = totalRows / pageSize + 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
		return totalPages;
	}
	
	
}

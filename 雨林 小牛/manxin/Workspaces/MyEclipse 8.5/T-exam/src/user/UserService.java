package user;

import java.sql.*;

import javax.swing.JOptionPane;

import exam_util.exam_sql;

public class UserService {
	/* User 业务层 */
	Connection conn = null;
	exam_sql sql = new exam_sql();
	//验证用户名
	private boolean checkUser_id(String user_id){
		try {
			conn = sql.exam_Date();
			String strSql = "select * from user_m";
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(strSql);
			while(rs.next()){
				if(user_id.equals(rs.getString("user_id"))){
					JOptionPane.showMessageDialog(null, "输入的用户名已存在");
					return false;
				} else{
					return true;
				}
			}
			
		} catch (SQLException e) {
			System.out.println("连接数据库失败");
			e.printStackTrace();
		}
		return false;
	}
	
	//验证密码
	private boolean checkUser_pwd(String pwd1,String pwd2){
		return pwd1.equals(pwd2);
	}
	
	//插入数据
	public boolean insert(String user_id,String user_pwd,String user_name,String email){//
		conn = sql.exam_Date();
		String strSql;
		boolean bo = false;
		try {
			if(checkUser_id(user_id)){
				strSql = "insert into user_m(user_id,user_pwd,user_name,user_email)"+
						" values('"+ user_id +"','" + user_pwd +"','" + user_name + "','" + email + "')";
				Statement stmt = conn.createStatement();
				System.out.println(stmt.execute(strSql));//--------
				bo = stmt.execute(strSql);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return bo;
	}
}

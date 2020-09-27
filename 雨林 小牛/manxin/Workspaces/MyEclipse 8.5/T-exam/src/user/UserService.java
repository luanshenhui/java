package user;

import java.sql.*;

import javax.swing.JOptionPane;

import exam_util.exam_sql;

public class UserService {
	/* User ҵ��� */
	Connection conn = null;
	exam_sql sql = new exam_sql();
	//��֤�û���
	private boolean checkUser_id(String user_id){
		try {
			conn = sql.exam_Date();
			String strSql = "select * from user_m";
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(strSql);
			while(rs.next()){
				if(user_id.equals(rs.getString("user_id"))){
					JOptionPane.showMessageDialog(null, "������û����Ѵ���");
					return false;
				} else{
					return true;
				}
			}
			
		} catch (SQLException e) {
			System.out.println("�������ݿ�ʧ��");
			e.printStackTrace();
		}
		return false;
	}
	
	//��֤����
	private boolean checkUser_pwd(String pwd1,String pwd2){
		return pwd1.equals(pwd2);
	}
	
	//��������
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

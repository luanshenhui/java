package day01;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Demo {
	private static String className = "com.mysql.jdbc.Driver";
	private static String url = "jdbc:mysql://localhost:3306/test";
	private static String username = "root";
	private static String pwd = "1234";
	//����Ϊʲô����Ҫ����ֵ
	public static void save(){
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			//����������  ͨ�����·�����ܴ�����Ķ���
			Class.forName(className);
			//��������
			 conn = 
				DriverManager.getConnection(url, username, pwd);
			//����statement
			String sql = "insert into t_user(username,pwd,age) values (?,?,?)";
			 stat = conn.prepareStatement(sql);
			 stat.setString(1, "zs1");
			 stat.setString(2, "12341");
			 stat.setInt(3, 181);
			 stat.executeUpdate();//ʲôʱ���� ������ ɾ �ĵ�ʱ��ʹ���������
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(stat != null){
				try {
					stat.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
	}
	public static void main(String[] args) {
		//save();
		findAll();
	}
	public static void findAll(){
		Connection conn = null;
		PreparedStatement  stat = null;
		ResultSet rst = null;
		try {
			Class.forName(className);
			 conn = DriverManager.getConnection(url, username, pwd);
			String sql = "select * from t_user";
			stat = conn.prepareStatement(sql);
			 rst = stat.executeQuery();
			while(rst.next()){
				String id = rst.getString("id");
				String username = rst.getString("username");
				String pwd = rst.getString("pwd");
				int age = rst.getInt("age");
				System.out.println( id + " " + username + pwd + age);
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(rst != null){
				try {
					rst.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(stat != null){
				try {
					stat.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
}

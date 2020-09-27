package day01;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PreparedStatementTest {
	//mysql���ݿ�����ò���
	private static String className =
		"com.mysql.jdbc.Driver";
	private static String url =
		"jdbc:mysql://localhost:3306/test";
	private static String username = "root";
	private static String pwd = "1234";
	/*��ѯt_user�����ñ������еļ�¼
		��ѯ������
		create table t_user(
			id int primary key auto_increment,
			username varchar(50) unique,
			pwd varchar(30),
			age int
		)type=innodb;
		insert into t_user(username,pwd,age) 
		values('eric','test',22);
		insert into t_user(username,pwd,age) 
		values('tom','test1',22);
		insert into t_user(username,pwd,age) 
		values('kitty','test2',22);
		unique:Ψһ��Լ��,��usernameҪ��Ψһ��
	*/
	public static void findAll(String username1,String pwd1){
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try {
			Class.forName(className);
			conn = 
				DriverManager.getConnection(url,username,pwd);
			String sql = "select * from t_user " +
					"where username=? and pwd=?";
			stat = 
				conn.prepareStatement(sql);
			stat.setString(1, username1);
			stat.setString(2, pwd1);
			rst = stat.executeQuery();
			while(rst.next()){
				int id = rst.getInt("id");
				String username = rst.getString("username");
				String pwd = rst.getString("pwd");
				int age = rst.getInt("age");
				System.out.println("id:" + id 
						+ " username:" + username 
						+ " pwd:" + pwd + " age:" + age);
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			System.out.println("��������ʧ��");
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("�������ݿ�ʧ��");
		}finally{
			if(rst != null){
				try {
					rst.close();
				} catch (SQLException e) {
					e.printStackTrace();
					System.out.println("������ر�ʧ��");
				}
			}
			if(stat != null){
				try {
					stat.close();
				} catch (SQLException e) {
					e.printStackTrace();
					System.out.println("statement�ر�ʧ��");
				}
			}
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
					System.out.println("���ӹر�ʧ��");
				}
			}
		}
	}
	
	public static void insert() {
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			Class.forName(className);
			conn = DriverManager.getConnection(
					url,username,pwd);
			String sql = 
				"insert into t_user(username,pwd,age) " +
				"values(?,?,?)";
			stat = conn.prepareStatement(sql);
			stat.setString(1, "user123");
			stat.setString(2, "test");
			stat.setInt(3, 22);
			stat.executeUpdate();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			System.out.println("��������ʧ��");
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("�������ݿ�ʧ��");
		}finally{
			if(stat != null){
				try {
					stat.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		//findAll("eric","test");
		//findAll("afdasdfasdf","1' or '1' = '1");
		insert();
		
		
	}

}

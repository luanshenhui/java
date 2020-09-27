package com.zy;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DAOImple implements Dao {

	@Override
	public Bank findBankByID(int i) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void update(Bank bank) {
		// TODO Auto-generated method stub

	}

	@Override
	public void delete(Bank bank) {
		// TODO Auto-generated method stub

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn=DriverManager.getConnection("jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			conn.setAutoCommit(false);
			String sql="delete from bank where id=?";
			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setInt(1, bank.getId());
//			ps.setString(2, bank.getName());
//			ps.setString(3, bank.getPassword());
//			ps.setDouble(4, bank.getMoney());
			int rs=ps.executeUpdate();
			System.out.println("Ö´ÐÐ"+rs+"Ìõ¼ÇÂ¼");
			conn.commit();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		
	}

}

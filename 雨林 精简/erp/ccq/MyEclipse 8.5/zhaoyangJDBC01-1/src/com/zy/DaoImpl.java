package com.zy;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DaoImpl implements Dao {
	@Override
	public Bank findBankByID(int i) {
		Bank bank = new Bank();
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			String sq = "select * from bank where id= ?";
			PreparedStatement ps = conn.prepareStatement(sq);
			ps.setInt(1, i);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {// while里面是一条条记录
				// System.out.println("结果是"+rs.next());
				bank.setId(rs.getInt("id"));
				bank.setName(rs.getString("username"));
				bank.setPassword(rs.getString("password"));
				bank.setMoney(rs.getDouble("money"));
				// bank=new Bank(rs.getInt("id"),rs.getString("username"),
				// rs.getString("password"), rs.getInt("money"));
				return bank;

			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;

	}

	@Override
	public void update(Bank bank) {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			String sq = "update bank set username= ? ,password =?,money =? where id=?";
			PreparedStatement ps = conn.prepareStatement(sq);
			ps.setString(1, bank.getName());
			ps.setString(2, bank.getPassword());
			ps.setDouble(3, bank.getMoney());
			ps.setInt(4, bank.getId());

			int rs = ps.executeUpdate();
			System.out.println("执行" + rs + "条记录");
			conn.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@Override
	public void delete(Bank bank) {
		// TODO Auto-generated method stub

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@127.0.0.1:1521:orcl", "a1", "abc");
			conn.setAutoCommit(false);
			String sql = "delete from bank where id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, bank.getId());
			// ps.setString(2, bank.getName());
			// ps.setString(3, bank.getPassword());
			// ps.setDouble(4, bank.getMoney());
			int rs = ps.executeUpdate();
			System.out.println("执行" + rs + "条记录");
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

package com.am.lsh;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.lsh.domen.Company;
import com.lsh.domen.Mem;
import com.lsh.util.DBFactory;

public class MemDAOImpl extends BaseDAO implements MemDAO {

	@Override
	public Mem getMemByID(int id) {

		Mem mem = new Mem();
		// Connection conn=null;
		try {
			// Class.forName("org.gjt.mm.mysql.Driver");
			// Connection
			// conn=DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/luan","root","12345");
			// System.out.println(conn);
			// conn=DBFactory.openConnection();
			String sql = "select m.id,m.name,m.age,c.name k from mem m,company c where m.id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Company com = new Company();
				mem.setId(rs.getInt("id"));
				mem.setName(rs.getString("name"));
				mem.setAge(rs.getInt("age"));
				com.setName(rs.getString("k"));
				mem.setCompany(com);
				System.out.println();
				// mem.setCompany(rs.getString("k");
				// mem.setCompany(com.setName(rs.getString("k")));
				// mem.setCompany(rs.getString("k"));
				// int i=rs.getInt("id");
				// String s=rs.getString("name");
				// int a=rs.getInt("age");
				// System.out.println(i+" "+s+"  "+a);
			}
			// } catch (ClassNotFoundException e) {
			// // TODO Auto-generated catch block
			// e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			DBFactory.closeConnection(conn);
		}

		return mem;
	}

}

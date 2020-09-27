package com.zhaoyang04;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAOIpml extends ConFarther implements CompanyDAO {

	@Override
	public Company getAllById(int i) {
		// TODO Auto-generated method stub
		Company com = new Company();	
		try {
			String sql = "select * from company where id=" + i + "";
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next()) {
				com.setId(rs.getInt("id"));
				com.setName(rs.getString("name"));
			}

			sql = "select * from mem where comid=" + i + "";
			st = conn.createStatement();
			rs = st.executeQuery(sql);

			while (rs.next()) {
				Mem m = new Mem();
				m.setName(rs.getString("name"));
				m.setAge(rs.getInt("age"));
				m.setCompany(com);
//				list.add(m);
//				com.setList(list);
			
//				List<Mem>list=new ArrayList<Mem>();
				com.getList().add(m);

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return com;
	}

}

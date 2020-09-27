package com.am.lsh;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.lsh.domen.Company;
import com.lsh.domen.Mem;
import com.lsh.util.DBFactory;

public class CompanyDAOImpl extends BaseDAO implements CompanyDAO {

	@Override
	public Company getCompanyByID(int id) {
		Company com=new Company();
		List<Mem>list=new ArrayList<Mem>();
		//Connection conn=null;
			try {
//				Class.forName("org.gjt.mm.mysql.Driver");
//				Connection conn=DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/luan","root","12345");	
				//conn=DBFactory.openConnection();
				String sql="select * from company c ,mem m where ?=m.comid";
				PreparedStatement ps=conn.prepareStatement(sql);
				ps.setInt(1,id);
				ResultSet rs=ps.executeQuery();
				while(rs.next()){
					Mem m=new Mem();
					com.setId(rs.getInt("c.id"));
					com.setName(rs.getString("c.name"));
					m.setName(rs.getString("m.name"));
					m.setAge(rs.getInt("age"));
					m.setId(rs.getInt("m.id"));
					m.setCompany(com);
					list.add(m);
					com.setList(list);
					//String="找员工"
					//new company
					//while(){}
					//获得员工
					//company.getList().add(member);

				}
//			} catch (ClassNotFoundException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				DBFactory.closeConnection(conn);
			}
			
		System.out.println("                      "+com);

	
		return com;
	
//			try {
//				Class.forName("org.gjt.mm.mysql.Driver");
//				Connection conn=DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/luan","root","12345");
//				//System.out.println(conn);
//				String sql="select * from company where id=?";
//				PreparedStatement ps=conn.prepareStatement(sql);
//				ps.setInt(1,id);
//				ResultSet rs=ps.executeQuery();
//				while(rs.next()){
//					com.setId(rs.getInt("id"));
//					com.setName(rs.getString("name"));
////					int i=rs.getInt("id");
////					String s=rs.getString("name");
////					int a=rs.getInt("age");
////					System.out.println(i+" "+s+"  "+a);
//				}
//			} catch (ClassNotFoundException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			} catch (SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		
//
//	
//		return com;
	}

//	@Override
//	public List<Mem> getList() {
//		List<Mem>list=new ArrayList<Mem>();
//		// TODO Auto-generated method stub
//			try {
//				Class.forName("org.gjt.mm.mysql.Driver");
//				Connection conn=DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/luan","root","12345");
//				//String sql="select m.name from company c ,mem m where c.id=m.comid";
//				String sql="select * from mem";
//				PreparedStatement ps=conn.prepareStatement(sql);
//				
//				ResultSet rs=ps.executeQuery();
//				
//				while(rs.next()){
//					Mem m=new Mem();
//					m.setName(rs.getString("name"));
//					m.setAge(rs.getInt("age"));
//					list.add(m);
//					System.out.println("是"+rs.next());
//					//Company com=new Company();
//					//com.setList(list);
//					return list;
//				}
//				System.out.println(list);
//			//	conn.commit();
//			} catch (ClassNotFoundException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			} catch (SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		return list;
//	}

	

}

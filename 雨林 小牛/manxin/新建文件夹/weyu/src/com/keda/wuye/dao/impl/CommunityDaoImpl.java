package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


import com.keda.wuye.dao.CommunityDao;
import com.keda.wuye.entity.Community;
import com.keda.wuye.util.ConnectionUtils;

public class CommunityDaoImpl implements CommunityDao {

	public List<Community> getCommunity()
	{
		List<Community> listCommunity = new ArrayList<Community>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from community");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String com_id = rs.getString(1);		//С����
				String com_name = rs.getString(2); 		//С�����
				String com_date = rs.getString(3);		//��������
				String com_principal = rs.getString(4);	//��Ҫ������
				double com_area = rs.getDouble(5);		//ռ�����
				double com_buildarea = rs.getDouble(6);	//�������
				String com_location = rs.getString(7);	//λ��˵��
				Community community = new Community();
				community.setCom_id(com_id);
				community.setCom_name(com_name);
				community.setCom_date(com_date);
				community.setCom_principal(com_principal);
				community.setCom_area(com_area);
				community.setCom_buildarea(com_buildarea);
				community.setCom_location(com_location);
				
				
				listCommunity.add(community);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listCommunity;
	}
	
	public void insertCommunity(String com_id,String com_name,String com_date,String com_principal,double com_area,double com_buildarea,String com_location)
	{
		String data1 = com_id;			
		String data2 = com_name;		
		String data3 = com_date;		
		String data4 = com_principal;	
		double data5 = com_area;		
		double data6 = com_buildarea;	
		String data7 = com_location;	
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("insert into community(com_id,com_name,com_date,com_principal,com_area,com_buildarea,com_location) values('"+data1+"','" +data2+"','"+data3+"','"+data4+"','"+data5+"','"+data6+"','"+data7+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void deleteCommunity(String com_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
//			System.out.println("select * from community where com_id like '%"+com_id+"%' or com_name like '%"+com_id+"%' or com_date like '%"+com_id+"%' or com_principal like '%"+com_id+"%' or com_area like '%"+com_id+"%' or com_buildarea like '%"+com_id+"%' or com_location like '%"+com_id+"%'");
			PreparedStatement stmt = con.prepareStatement("delete from community where com_id='"+com_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	public void updateCommunity(String com_id,String com_name,String com_date,String com_principal,double com_area,double com_buildarea,String com_location)
	{
		String data1 = com_id;			
		String data2 = com_name;		
		String data3 = com_date;
		System.out.println(data3);
		String data4 = com_principal;	
		double data5 = com_area;		
		double data6 = com_buildarea;	
		String data7 = com_location;	
		try {
			Connection con = ConnectionUtils.openConnection(); 
			System.out.println("update community set com_name='"+data2+"',com_date='"+data3+"','com_principal='"+data4+"',com_area='"+data5+"',com_buildarea='"+data6+"',com_location='"+data7+"'"+"where com_id='"+data1+"'");
			PreparedStatement stmt = con.prepareStatement("update community set com_name='"+data2+"',com_date='"+data3+"',com_principal='"+data4+"',com_area='"+data5+"',com_buildarea='"+data6+"',com_location='"+data7+"'"+"where com_id='"+data1+"'");
			stmt.executeUpdate();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//��ѯһ����Ϣ
	public Community getCommunity(String id)
	{
		Community community = new Community();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from community where com_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String com_id = rs.getString(1);		//С����
				String com_name = rs.getString(2); 		//С�����
				String com_date = rs.getString(3);		//��������
				String com_principal = rs.getString(4);	//��Ҫ������
				double com_area = rs.getDouble(5);		//ռ�����
				double com_buildarea = rs.getDouble(6);	//�������
				String com_location = rs.getString(7);	//λ��˵��
				community.setCom_id(com_id);
				community.setCom_name(com_name);
				community.setCom_date(com_date);
				community.setCom_principal(com_principal);
				community.setCom_area(com_area);
				community.setCom_buildarea(com_buildarea);
				community.setCom_location(com_location);					
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return community;
	}
	
	public boolean idEqual(String com_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from community where com_id='"+com_id+"'");
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
			{
				b = true;
			}
			else
			{
				b = false;
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return b;	
		
	}
	
	//ģ���ѯ
	public List<Community> select(String s)
	{
		List<Community> listselect = new ArrayList<Community>();
		try {
			Connection con = ConnectionUtils.openConnection();

			PreparedStatement stmt = con.prepareStatement("select * from community " +
					"where com_id like '%"+s+"%' " +
					"or com_name like '%"+s+"%' " +
					"or com_date like '%"+s+"%' " +
					"or com_principal like '%"+s+"%' " +
					"or com_area like '%"+s+"%' " +
					"or com_buildarea like '%"+s+"%' " +
					"or com_location like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String com_id = rs.getString(1);		//С����
				String com_name = rs.getString(2); 		//С�����
				String com_date = rs.getString(3);		//��������
				String com_principal = rs.getString(4);	//��Ҫ������
				double com_area = rs.getDouble(5);		//ռ�����
				double com_buildarea = rs.getDouble(6);	//�������
				String com_location = rs.getString(7);	//λ��˵��
				Community community = new Community();
				community.setCom_id(com_id);
				community.setCom_name(com_name);
				community.setCom_date(com_date);
				community.setCom_principal(com_principal);
				community.setCom_area(com_area);
				community.setCom_buildarea(com_buildarea);
				community.setCom_location(com_location);
	
				listselect.add(community);	
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listselect;
	}
	
}

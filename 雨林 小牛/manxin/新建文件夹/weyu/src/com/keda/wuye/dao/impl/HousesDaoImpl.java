package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.util.ConnectionUtils;

public class HousesDaoImpl implements HousesDao {

	//��ʾ������Ϣ
	public List<Houses> getHouses()
	{
		List<Houses> listHouses = new ArrayList<Houses>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houses");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String houses_id = rs.getString(1);			//¥�̱��
				String houses_comid = rs.getString(2); 		//С����
				String houses_date = rs.getString(3);		//��������
				int houses_floor = rs.getInt(4);				//¥�̲���
				double houses_area = rs.getDouble(5);		//¥�����
				String houses_face = rs.getString(6);		//¥�̷���
				String houses_type = rs.getString(7);		//¥������
				
				Houses houses = new Houses();
				houses.setHouses_id(houses_id);
				houses.setHouses_comid(houses_comid);
				houses.setHouses_date(houses_date);
				houses.setHouses_face(houses_face);
				houses.setHouses_floor(houses_floor);
				houses.setHouses_type(houses_type);
				houses.setHouses_area(houses_area);
				
				listHouses.add(houses);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listHouses;
	}
	
	//��ʾ������Ϣ
	public List<Houses> select(String s)
	{
		List<Houses> listHouses = new ArrayList<Houses>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houses " +
					"where houses_id like '%"+s+"%' " +
					"or houses_comid like '%"+s+"%' " +
					"or houses_date like '%"+s+"%' " +
					"or houses_floor like '%"+s+"%' " +
					"or houses_area like '%"+s+"%' " +
					"or houses_face like '%"+s+"%' " +
					"or houses_type like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String houses_id = rs.getString(1);			//¥�̱��
				String houses_comid = rs.getString(2); 		//С����
				String houses_date = rs.getString(3);		//��������
				int houses_floor = rs.getInt(4);				//¥�̲���
				double houses_area = rs.getDouble(5);		//¥�����
				String houses_face = rs.getString(6);		//¥�̷���
				String houses_type = rs.getString(7);		//¥������
				
				Houses houses = new Houses();
				houses.setHouses_id(houses_id);
				houses.setHouses_comid(houses_comid);
				houses.setHouses_date(houses_date);
				houses.setHouses_face(houses_face);
				houses.setHouses_floor(houses_floor);
				houses.setHouses_type(houses_type);
				houses.setHouses_area(houses_area);
				
				listHouses.add(houses);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listHouses;
	}
	//��ѯһ����Ϣ
	public Houses getHouses(String id)
	{
		Houses houses = new Houses();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from houses where houses_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String houses_id = rs.getString(1);			//¥�̱��
				String houses_comid = rs.getString(2); 		//С����
				String houses_date = rs.getString(3);		//��������
				int houses_floor = rs.getInt(4);				//¥�̲���
				double houses_area = rs.getDouble(5);		//¥�����
				String houses_face = rs.getString(6);		//¥�̷���
				String houses_type = rs.getString(7);		//¥������
				
				houses.setHouses_id(houses_id);
				houses.setHouses_comid(houses_comid);
				houses.setHouses_area(houses_area);
				houses.setHouses_date(houses_date);
				houses.setHouses_face(houses_face);
				houses.setHouses_floor(houses_floor);
				houses.setHouses_type(houses_type);		
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return houses;
	}
	
	//���
	public void insertHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type)
	{
		System.out.println(houses_date);
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into houses(houses_id,houses_comid,houses_date,houses_floor,houses_area,houses_face,houses_type) values('"+houses_id+"','" +houses_comid+"','"+houses_date+"','"+houses_floor+"','"+houses_area+"','"+houses_face+"','"+houses_type+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//�޸�
	public void updateHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type)
	{
		String data1 = houses_id;			
		String data2 = houses_comid;
		String data3 = houses_date;
		int data4 = houses_floor;	
		double data5 = houses_area;		
		String data6 = houses_face;	
		String data7 = houses_type;		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 
			System.out.println("update houses set houses_comid='"+data2+"',houses_date='"+data3+"',houses_floor='"+data4+"',houses_area='"+data5+"',houses_face='"+data6+"',houses_type='"+data7+"'"+"where houses_id='"+data1+"'");
			PreparedStatement stmt = con.prepareStatement("update houses set houses_comid='"+data2+"',houses_date='"+data3+"',houses_floor='"+data4+"',houses_area='"+data5+"',houses_face='"+data6+"',houses_type='"+data7+"'"+"where houses_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//ɾ��
	public void deleteHouses(String houses_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from houses where houses_id='"+houses_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String houses_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from houses where houses_id='"+houses_id+"'");
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
	
	//��ȡcommunity���е�С����
	public List<String> get_comid()
	{
		List<String> list_comid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select com_id from community");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String com_id = rs.getString(1);			//¥�̱��
				list_comid.add(com_id);	
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return list_comid;
	}
	
}

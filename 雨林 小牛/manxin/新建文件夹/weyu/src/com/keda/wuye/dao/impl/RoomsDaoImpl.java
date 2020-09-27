package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.RoomsDao;
import com.keda.wuye.dao.UserDao;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Rooms;
import com.keda.wuye.entity.User;
import com.keda.wuye.util.ConnectionUtils;

public class RoomsDaoImpl implements RoomsDao {

	//��ʾ������Ϣ
	public List<Rooms> getRooms()
	{
		List<Rooms> listRooms = new ArrayList<Rooms>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from rooms");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String rooms_id = rs.getString(1);			//�����
				String rooms_housesid = rs.getString(2); 		//����¥�̺�
				String rooms_type = rs.getString(3);		//����
				double rooms_area = rs.getDouble(4);				//���佨�����
				double rooms_usearea = rs.getDouble(5);		//�������
				
				Rooms rooms = new Rooms();
				rooms.setRooms_area(rooms_area);
				rooms.setRooms_housesid(rooms_housesid);
				rooms.setRooms_id(rooms_id);
				rooms.setRooms_type(rooms_type);
				rooms.setRooms_usearea(rooms_usearea);
				
				listRooms.add(rooms);		
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listRooms;
	}
	//��ʾ������Ϣ
	public List<Rooms> select(String s)
	{
		List<Rooms> listRooms = new ArrayList<Rooms>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from rooms " +
					"where rooms_id like '%"+s+"%' " +
					"or rooms_housesid like '%"+s+"%' " +
					"or rooms_type like '%"+s+"%' " +
					"or rooms_area like '%"+s+"%' " +
					"or rooms_usearea like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String rooms_id = rs.getString(1);			//�����
				String rooms_housesid = rs.getString(2); 		//����¥�̺�
				String rooms_type = rs.getString(3);		//����
				double rooms_area = rs.getDouble(4);				//���佨�����
				double rooms_usearea = rs.getDouble(5);		//�������
				
				Rooms rooms = new Rooms();
				rooms.setRooms_area(rooms_area);
				rooms.setRooms_housesid(rooms_housesid);
				rooms.setRooms_id(rooms_id);
				rooms.setRooms_type(rooms_type);
				rooms.setRooms_usearea(rooms_usearea);
				
				listRooms.add(rooms);		
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listRooms;
	}

	//���
	public void insertRooms(String rooms_id,String rooms_housesid,String rooms_type,double rooms_area,double rooms_usearea)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 
			System.out.println("insert into rooms(rooms_id,rooms_housesid,rooms_type,rooms_area,rooms_usearea) values('"+rooms_id+"','" +rooms_housesid+"','" +rooms_type+"','"+rooms_area+"','"+rooms_usearea+"')");
			PreparedStatement stmt = con.prepareStatement("insert into rooms(rooms_id,rooms_housesid,rooms_type,rooms_area,rooms_usearea) values('"+rooms_id+"','" +rooms_housesid+"','" +rooms_type+"','"+rooms_area+"','"+rooms_usearea+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//��ѯһ����Ϣ
	public Rooms getRooms(String id)
	{
		Rooms rooms = new Rooms();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from rooms where rooms_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String rooms_id = rs.getString(1);			//�����
				String rooms_housesid = rs.getString(2); 		//����¥�̺�
				String rooms_type = rs.getString(3);		//����
				double rooms_area = rs.getDouble(4);				//���佨�����
				double rooms_usearea = rs.getDouble(5);		//�������
				
				rooms.setRooms_area(rooms_area);
				rooms.setRooms_housesid(rooms_housesid);
				rooms.setRooms_id(rooms_id);
				rooms.setRooms_type(rooms_type);
				rooms.setRooms_usearea(rooms_usearea);		
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rooms;
	}
	
	
	//�޸�
	public void updateRooms(String rooms_id,String rooms_housesid,String rooms_type,double rooms_area,double rooms_usearea)
	{
		String data1 = rooms_id;			
		String data2 = rooms_housesid;
		String data3 = rooms_type;
		double data4 = rooms_area;	
		double data5 = rooms_usearea;		
			
		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 	
			PreparedStatement stmt = con.prepareStatement("update rooms set rooms_housesid='"+data2+"',rooms_type='"+data3+"',rooms_area='"+data4+"',rooms_usearea='"+data5+"'where rooms_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//ɾ��
	public void deleteRooms(String rooms_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from rooms where rooms_id='"+rooms_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String rooms_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from rooms where rooms_id='"+rooms_id+"'");
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
	
	//��ȡcommunity���е�С�����
	public List<String> get_houseid()
	{
		List<String> list_houseid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select houses_id from houses");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String houses_id = rs.getString(1);			//������
				list_houseid.add(houses_id);	
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return list_houseid;
	}

}

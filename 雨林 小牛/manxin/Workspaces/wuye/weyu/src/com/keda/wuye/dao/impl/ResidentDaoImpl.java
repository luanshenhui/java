package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.ResidentDao;
import com.keda.wuye.entity.Resident;
import com.keda.wuye.util.ConnectionUtils;

public class ResidentDaoImpl implements ResidentDao {
	//显示所有信息
	public List<Resident> getResident()
	{
		List<Resident> listResident = new ArrayList<Resident>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from resident");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String resident_id = rs.getString(1);			//业主编号
				String resident_roomsid = rs.getString(2); 		//房号
				String resident_name = rs.getString(3);		//业主姓名
				String resident_phone = rs.getString(4);		//业主电话		
				String resident_unit = rs.getString(5);		//业主单位
				String resident_sex = rs.getString(6);		//业主性别
				
				Resident resident = new Resident();
				
				resident.setResident_id(resident_id);
				resident.setResident_name(resident_name);
				resident.setResident_phone(resident_phone);
				resident.setResident_roomsid(resident_roomsid);
				resident.setResident_sex(resident_sex);
				resident.setResident_unit(resident_unit);
							
				listResident.add(resident);		
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listResident;
	}
	//显示所有信息
	public List<Resident> select(String s)
	{
		List<Resident> listResident = new ArrayList<Resident>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from resident " +
					"where resident_id like '%"+s+"%' " +
					"or resident_roomsid like '%"+s+"%' " +
					"or resident_name like '%"+s+"%' " +
					"or resident_phone like '%"+s+"%' " +
					"or resident_unit like '%"+s+"%' " +
					"or resident_sex like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String resident_id = rs.getString(1);			//业主编号
				String resident_roomsid = rs.getString(2); 		//房号
				String resident_name = rs.getString(3);		//业主姓名
				String resident_phone = rs.getString(4);		//业主电话		
				String resident_unit = rs.getString(5);		//业主单位
				String resident_sex = rs.getString(6);		//业主性别
				
				Resident resident = new Resident();
				
				resident.setResident_id(resident_id);
				resident.setResident_name(resident_name);
				resident.setResident_phone(resident_phone);
				resident.setResident_roomsid(resident_roomsid);
				resident.setResident_sex(resident_sex);
				resident.setResident_unit(resident_unit);
							
				listResident.add(resident);		
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listResident;
	}

	//添加
	public void insertResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into resident(resident_id,resident_roomsid,resident_name,resident_phone,resident_unit,resident_sex) values('"+resident_id+"','" +resident_roomsid+"','" +resident_name+"','"+resident_phone+"','"+resident_unit+"','"+resident_sex+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//查询一条信息
	public Resident getResident(String id)
	{
		Resident resident = new Resident();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from resident where resident_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String resident_id = rs.getString(1);			//业主编号
				String resident_roomsid = rs.getString(2); 		//房号
				String resident_name = rs.getString(3);		//业主姓名
				String resident_phone = rs.getString(4);		//业主电话		
				String resident_unit = rs.getString(5);		//业主单位
				String resident_sex = rs.getString(6);		//业主性别
				
				resident.setResident_id(resident_id);
				resident.setResident_name(resident_name);
				resident.setResident_phone(resident_phone);
				resident.setResident_roomsid(resident_roomsid);
				resident.setResident_sex(resident_sex);
				resident.setResident_unit(resident_unit);								
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resident;
	}
	
	
	//修改
	public void updateResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit)
	{
		String data1 = resident_id;			
		String data2 = resident_roomsid;
		String data3 = resident_name;
		String data4 = resident_phone;	
		String data5 = resident_unit;	
		String data6 = resident_sex;

		try {
			Connection con = ConnectionUtils.openConnection(); 	
			PreparedStatement stmt = con.prepareStatement("update resident set resident_roomsid='"+data2+"',resident_name='"+data3+"',resident_phone='"+data4+"',resident_unit='"+data5+"',resident_sex='"+data6+"'where resident_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//删除
	public void deleteResident(String resident_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from resident where resident_id='"+resident_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//判断编号是否重复
	public boolean idEqual(String resident_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from resident where resident_id='"+resident_id+"'");
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
	
	//获取rooms表中的小区编号
	public List<String> get_roomid()
	{
		List<String> list_roomid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select rooms_id from rooms");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String rooms_id = rs.getString(1);			//房间编号
				list_roomid.add(rooms_id);	
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return list_roomid;
	}

}

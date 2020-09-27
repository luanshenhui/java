package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.PlantDao;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Plant;
import com.keda.wuye.util.ConnectionUtils;

public class PlantDaoImpl implements PlantDao {
	
	//显示所有信息
	public List<Plant> getPlant()
	{
		List<Plant> listPlant = new ArrayList<Plant>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from plant");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String plant_id = rs.getString(1);			//楼盘编号
				String plant_name = rs.getString(2); 		//小区编号
				String plant_comid = rs.getString(3);		//建成日期
				String plant_factory = rs.getString(4);		//楼盘面积
				String plant_date = rs.getString(5);		//楼盘方向
				int plant_num = rs.getInt(6);		//楼盘类型
				int plant_repaircycle = rs.getInt(7);
				
				Plant plant = new Plant();
				plant.setPlant_comid(plant_comid);
				plant.setPlant_date(plant_date);
				plant.setPlant_factory(plant_factory);
				plant.setPlant_id(plant_id);
				plant.setPlant_name(plant_name);
				plant.setPlant_num(plant_num);
				plant.setPlant_repaircycle(plant_repaircycle);
				
				listPlant.add(plant);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listPlant;
	}
	//显示所有信息
	public List<Plant> select(String s)
	{
		List<Plant> listPlant = new ArrayList<Plant>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from plant " +
					"where plant_id like '%"+s+"%' " +
					"or plant_name like '%"+s+"%' " +
					"or plant_comid like '%"+s+"%' " +
					"or plant_factory like '%"+s+"%' " +
					"or plant_date like '%"+s+"%' " +
					"or plant_num like '%"+s+"%' " +
					"or plant_repaircycle like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String plant_id = rs.getString(1);			//楼盘编号
				String plant_name = rs.getString(2); 		//小区编号
				String plant_comid = rs.getString(3);		//建成日期
				String plant_factory = rs.getString(4);		//楼盘面积
				String plant_date = rs.getString(5);		//楼盘方向
				int plant_num = rs.getInt(6);		//楼盘类型
				int plant_repaircycle = rs.getInt(7);
				
				Plant plant = new Plant();
				plant.setPlant_comid(plant_comid);
				plant.setPlant_date(plant_date);
				plant.setPlant_factory(plant_factory);
				plant.setPlant_id(plant_id);
				plant.setPlant_name(plant_name);
				plant.setPlant_num(plant_num);
				plant.setPlant_repaircycle(plant_repaircycle);
				
				listPlant.add(plant);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listPlant;
	}
	//查询一条信息
	public Plant getPlant(String id)
	{
		Plant plant = new Plant();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from plant where plant_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String plant_id = rs.getString(1);			//楼盘编号
				String plant_name = rs.getString(2); 		//小区编号
				String plant_comid = rs.getString(3);		//建成日期
				String plant_factory = rs.getString(4);		//楼盘面积
				String plant_date = rs.getString(5);		//楼盘方向
				int plant_num = rs.getInt(6);		//楼盘类型
				int plant_repaircycle = rs.getInt(7);
				
				plant.setPlant_comid(plant_comid);
				plant.setPlant_date(plant_date);
				plant.setPlant_factory(plant_factory);
				plant.setPlant_id(plant_id);
				plant.setPlant_name(plant_name);
				plant.setPlant_num(plant_num);
				plant.setPlant_repaircycle(plant_repaircycle);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return plant;
	}
	
	//添加
	public void insertPlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 	
			System.out.println("insert into plant(plant_id,plant_name,plant_comid,plant_factory,plant_date,plant_num,plant_repaircycle) values('"+plant_id+"','" +plant_name+"','"+plant_comid+"','"+plant_factory+"',TO_DATE('" +plant_date+"','YYYY-MM-DD'"+"),'"+plant_num+"','"+plant_repaircycle+"')");
			PreparedStatement stmt = con.prepareStatement("insert into plant(plant_id,plant_name,plant_comid,plant_factory,plant_date,plant_num,plant_repaircycle) values('"+plant_id+"','" +plant_name+"','"+plant_comid+"','"+plant_factory+"','"+plant_date+"','"+plant_num+"','"+plant_repaircycle+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//修改
	public void updatePlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle)
	{
		String data1 = plant_id;			
		String data2 = plant_name;
		String data3 = plant_comid;
		String data4 = plant_factory;	
		String data5 = plant_date;	
		int data6 = plant_num;	
		int data7 = plant_repaircycle;		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("update plant set plant_name='"+data2+"',plant_comid='"+data3+"',plant_factory='"+data4+"',plant_date='"+data5+"',plant_num='"+data6+"',plant_repaircycle='"+data7+"'"+"where plant_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//删除
	public void deletePlant(String plant_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from plant where plant_id='"+plant_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//判断编号是否重复
	public boolean idEqual(String plant_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from plant where plant_id='"+plant_id+"'");
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
	
	//获取community表中的小区编号
	public List<String> get_comid()
	{
		List<String> list_comid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select com_id from community");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String com_id = rs.getString(1);			//楼盘编号
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

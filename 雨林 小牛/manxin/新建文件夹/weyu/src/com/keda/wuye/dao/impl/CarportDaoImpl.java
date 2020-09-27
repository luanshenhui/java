package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.CarportDao;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.util.ConnectionUtils;

public class CarportDaoImpl implements CarportDao {
	//显示所有信息
	public List<Carport> getCarport()
	{
		List<Carport> listCarport = new ArrayList<Carport>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from carport");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String carport_id = rs.getString(1);			//楼盘编号
				String carport_resid = rs.getString(2); 		//小区编号
				String carport_carnum = rs.getString(3);		//建成日期
				String carport_cartype = rs.getString(4);				//楼盘层数
				double carport_area = rs.getDouble(5);		//楼盘面积
	
				Carport carport = new Carport();
				carport.setCarport_area(carport_area);
				carport.setCarport_carnum(carport_carnum);
				carport.setCarport_cartype(carport_cartype);
				carport.setCarport_id(carport_id);
				carport.setCarport_resid(carport_resid);

				listCarport.add(carport);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listCarport;
	}
	
	//模糊查询
	public List<Carport> select(String s)
	{
		List<Carport> listCarport = new ArrayList<Carport>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from carport " +
					"where carport_id like '%"+s+"%' " +
					"or carport_resid like '%"+s+"%' " +
					"or carport_carnum like '%"+s+"%' " +
					"or carport_cartype like '%"+s+"%' " +
					"or carport_area like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String carport_id = rs.getString(1);			//楼盘编号
				String carport_resid = rs.getString(2); 		//小区编号
				String carport_carnum = rs.getString(3);		//建成日期
				String carport_cartype = rs.getString(4);				//楼盘层数
				double carport_area = rs.getDouble(5);		//楼盘面积
	
				Carport carport = new Carport();
				carport.setCarport_area(carport_area);
				carport.setCarport_carnum(carport_carnum);
				carport.setCarport_cartype(carport_cartype);
				carport.setCarport_id(carport_id);
				carport.setCarport_resid(carport_resid);

				listCarport.add(carport);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listCarport;
	}
	
	//查询一条信息
	public Carport getCarport(String id)
	{
		Carport carport = new Carport();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from carport where carport_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String carport_id = rs.getString(1);			//楼盘编号
				String carport_resid = rs.getString(2); 		//小区编号
				String carport_carnum = rs.getString(3);		//建成日期
				String carport_cartype = rs.getString(4);				//楼盘层数
				double carport_area = rs.getDouble(5);		//楼盘面积
				
				carport.setCarport_area(carport_area);
				carport.setCarport_carnum(carport_carnum);
				carport.setCarport_cartype(carport_cartype);
				carport.setCarport_id(carport_id);
				carport.setCarport_resid(carport_resid);			
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return carport;
	}
	
	//添加
	public void insertCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into Carport(carport_id,carport_resid,carport_carnum,carport_cartype,carport_area) values('"+carport_id+"','" +carport_resid+"','" +carport_carnum+"','"+carport_cartype+"','"+carport_area+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//修改
	public void updateCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area)
	{
		String data1 = carport_id;	
		String data2 = carport_resid;
		String data3 = carport_carnum;
		String data4 = carport_cartype;
		double data5 = carport_area;
		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("update carport set carport_resid='"+data2+"',carport_carnum='"+data3+"',carport_cartype='"+data4+"',carport_area='"+data5+"'"+"where carport_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//删除
	public void deleteCarport(String carport_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from carport where carport_id='"+carport_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//判断编号是否重复
	public boolean idEqual(String carport_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from carport where carport_id='"+carport_id+"'");
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
	public List<String> get_resiid()
	{
		List<String> list_resiid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select resident_id from resident");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String resident_id = rs.getString(1);			//楼盘编号
				list_resiid.add(resident_id);	
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return list_resiid;
	}
	
}

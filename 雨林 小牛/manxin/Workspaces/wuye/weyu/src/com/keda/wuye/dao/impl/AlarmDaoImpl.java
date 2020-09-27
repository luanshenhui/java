package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


import com.keda.wuye.dao.AlarmDao;
import com.keda.wuye.dao.CommunityDao;
import com.keda.wuye.entity.Alarm;
import com.keda.wuye.entity.Community;
import com.keda.wuye.util.ConnectionUtils;

public class AlarmDaoImpl implements AlarmDao {
	//显示所有信息
	public List<Alarm> getAlarm()
	{
		List<Alarm> listAlarm = new ArrayList<Alarm>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from alarm");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String alarm_id = rs.getString(1);		//报警编号
				String alarm_date = rs.getString(2); 		//报警时间
				String alarm_location = rs.getString(3);		//事发地点
				String alarm_matter = rs.getString(4);	//案情内容
				String alarm_way = rs.getString(5);		//报警方式
				String alarm_dealway = rs.getString(6);	//处理方式
				String alarm_dealperson = rs.getString(7);	//处理人员
				String alarm_dealresult = rs.getString(8);	//处理结果
				
				Alarm alarm = new Alarm();
				
				alarm.setAlarm_date(alarm_date);
				alarm.setAlarm_dealperson(alarm_dealperson);
				alarm.setAlarm_dealresult(alarm_dealresult);
				alarm.setAlarm_dealway(alarm_dealway);
				alarm.setAlarm_id(alarm_id);
				alarm.setAlarm_location(alarm_location);
				alarm.setAlarm_matter(alarm_matter);
				alarm.setAlarm_way(alarm_way);
								
				listAlarm.add(alarm);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listAlarm;
	}
	
	//模糊查询
	public List<Alarm> select(String s)
	{
		List<Alarm> listAlarm = new ArrayList<Alarm>();
		try {
			System.out.println("select * from alarm " +
					"where alarm_id like '%"+s+"%' " +
					"or alarm_date like '%"+s+"%' " +
					"or alarm_location like '%"+s+"%' " +
					"or alarm_matter like '%"+s+"%' " +
					"or alarm_way like '%"+s+"%' " +
					"or alarm_dealway like '%"+s+"%' " +
					"or alarm_dealperson like '%"+s+"%' " +
					"or alarm_dealresult like '%"+s+"%'");
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from alarm " +
					"where alarm_id like '%"+s+"%' " +
					"or alarm_date like '%"+s+"%' " +
					"or alarm_location like '%"+s+"%' " +
					"or alarm_matter like '%"+s+"%' " +
					"or alarm_way like '%"+s+"%' " +
					"or alarm_dealway like '%"+s+"%' " +
					"or alarm_dealperson like '%"+s+"%' " +
					"or alarm_dealresult like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String alarm_id = rs.getString(1);		//报警编号
				String alarm_date = rs.getString(2); 		//报警时间
				String alarm_location = rs.getString(3);		//事发地点
				String alarm_matter = rs.getString(4);	//案情内容
				String alarm_way = rs.getString(5);		//报警方式
				String alarm_dealway = rs.getString(6);	//处理方式
				String alarm_dealperson = rs.getString(7);	//处理人员
				String alarm_dealresult = rs.getString(8);	//处理结果
				
				Alarm alarm = new Alarm();
				
				alarm.setAlarm_date(alarm_date);
				alarm.setAlarm_dealperson(alarm_dealperson);
				alarm.setAlarm_dealresult(alarm_dealresult);
				alarm.setAlarm_dealway(alarm_dealway);
				alarm.setAlarm_id(alarm_id);
				alarm.setAlarm_location(alarm_location);
				alarm.setAlarm_matter(alarm_matter);
				alarm.setAlarm_way(alarm_way);
								
				listAlarm.add(alarm);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listAlarm;
	}
	
	//添加
	public void insertAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult)
	{
		String data1 = alarm_id;			
		String data2 = alarm_date;		
		String data3 = alarm_location;		
		String data4 = alarm_matter;	
		String data5 = alarm_way;		
		String data6 = alarm_dealway;	
		String data7 = alarm_dealperson;	
		String data8 = alarm_dealresult;
		try {
			Connection con = ConnectionUtils.openConnection(); 
			System.out.println("insert into alarm(alarm_id,alarm_date,alarm_location,alarm_matter,alarm_way,alarm_dealway,alarm_dealperson,alarm_dealresult) values('"+data1+"','"+data2+"','"+data3+"','"+data4+"','"+data5+"','"+data6+"','"+data7+"','"+data8+"')");
			PreparedStatement stmt = con.prepareStatement("insert into alarm(alarm_id,alarm_date,alarm_location,alarm_matter,alarm_way,alarm_dealway,alarm_dealperson,alarm_dealresult) values('"+data1+"','"+data2+"','"+data3+"','"+data4+"','"+data5+"','"+data6+"','"+data7+"','"+data8+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	//删除
	public void deleteAlarm(String alarm_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from alarm where alarm_id='"+alarm_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	//修改
	public void updateAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult)
	{
		String data1 = alarm_id;			
		String data2 = alarm_date;		
		String data3 = alarm_location;		
		String data4 = alarm_matter;	
		String data5 = alarm_way;		
		String data6 = alarm_dealway;	
		String data7 = alarm_dealperson;	
		String data8 = alarm_dealresult;
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("update alarm set alarm_date='" +data2+"',alarm_location='"+data3+"',alarm_matter='"+data4+"',alarm_way='"+data5+"',alarm_dealperson='"+data6+"',alarm_dealresult='"+data7+"',alarm_dealway='"+data8+"'"+"where alarm_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//查询一条信息
	public Alarm getAlarm(String id)
	{
		Alarm alarm = new Alarm();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from alarm where alarm_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String alarm_id = rs.getString(1);		//报警编号
				String alarm_date = rs.getString(2); 		//报警时间
				String alarm_location = rs.getString(3);		//事发地点
				String alarm_matter = rs.getString(4);	//案情内容
				String alarm_way = rs.getString(5);		//报警方式
				String alarm_dealway = rs.getString(6);	//处理方式
				String alarm_dealperson = rs.getString(7);	//处理人员
				String alarm_dealresult = rs.getString(8);	//处理结果
				
				alarm.setAlarm_date(alarm_date);
				alarm.setAlarm_dealperson(alarm_dealperson);
				alarm.setAlarm_dealresult(alarm_dealresult);
				alarm.setAlarm_dealway(alarm_dealway);
				alarm.setAlarm_id(alarm_id);
				alarm.setAlarm_location(alarm_location);
				alarm.setAlarm_matter(alarm_matter);
				alarm.setAlarm_way(alarm_way);					
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return alarm;
	}
	//判断编号是否重复
	public boolean idEqual(String alarm_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from alarm where alarm_id='"+alarm_id+"'");
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
	
}

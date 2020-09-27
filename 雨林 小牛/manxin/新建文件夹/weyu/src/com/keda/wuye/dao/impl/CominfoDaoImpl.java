package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.CominfoDao;
import com.keda.wuye.dao.RoomsDao;
import com.keda.wuye.dao.UserDao;
import com.keda.wuye.entity.Cominfo;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Rooms;
import com.keda.wuye.entity.User;
import com.keda.wuye.util.ConnectionUtils;

public class CominfoDaoImpl implements CominfoDao {	
	//��ʾ������Ϣ
	public List<Cominfo> getCominfo()
	{
		List<Cominfo> listCominfo = new ArrayList<Cominfo>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from cominfo");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String cominfo_id = rs.getString(1);			//С�����
				String cominfo_bus = rs.getString(2); 		///�ܱ߹���
				String cominfo_medical = rs.getString(3);		//�ܱ�ҽ��
				String cominfo_news = rs.getString(4);			//С������
				String cominfo_weather = rs.getString(5);		//����Ԥ��
				String cominfo_notice = rs.getString(6);		//С������
				
				Cominfo cominfo = new Cominfo();		
				cominfo.setCominfo_bus(cominfo_bus);
				cominfo.setCominfo_id(cominfo_id);
				cominfo.setCominfo_medical(cominfo_medical);
				cominfo.setCominfo_news(cominfo_news);
				cominfo.setCominfo_notice(cominfo_notice);
				cominfo.setCominfo_weather(cominfo_weather);
				
				listCominfo.add(cominfo);	
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listCominfo;
	}
	//ģ����ѯ
	public List<Cominfo> select(String s)
	{
		List<Cominfo> listCominfo = new ArrayList<Cominfo>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from cominfo " +
					"where cominfo_id like '%"+s+"%' " +
					"or cominfo_bus like '%"+s+"%' " +
					"or cominfo_medical like '%"+s+"%' " +
					"or cominfo_news like '%"+s+"%' " +
					"or cominfo_weather like '%"+s+"%' " +
					"or cominfo_notice like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String cominfo_id = rs.getString(1);			//С�����
				String cominfo_bus = rs.getString(2); 		///�ܱ߹���
				String cominfo_medical = rs.getString(3);		//�ܱ�ҽ��
				String cominfo_news = rs.getString(4);			//С������
				String cominfo_weather = rs.getString(5);		//����Ԥ��
				String cominfo_notice = rs.getString(6);		//С������
				
				Cominfo cominfo = new Cominfo();		
				cominfo.setCominfo_bus(cominfo_bus);
				cominfo.setCominfo_id(cominfo_id);
				cominfo.setCominfo_medical(cominfo_medical);
				cominfo.setCominfo_news(cominfo_news);
				cominfo.setCominfo_notice(cominfo_notice);
				cominfo.setCominfo_weather(cominfo_weather);
				
				listCominfo.add(cominfo);	
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listCominfo;
	}

	//���
	public void insertCominfo(String cominfo_id,String cominfo_bus,String cominfo_medical,String cominfo_news,String cominfo_weather,String cominfo_notice)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into cominfo(cominfo_id,cominfo_bus,cominfo_medical,cominfo_news,cominfo_weather,cominfo_notice) values('"+cominfo_id+"','" +cominfo_bus+"','" +cominfo_medical+"','"+cominfo_news+"','"+cominfo_weather+"','"+cominfo_notice+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//��ȡcommunity���е�С�����
	public List<String> get_comid()
	{
		List<String> list_comid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select com_id from community where com_id not in (select cominfo_id from cominfo)");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String com_id = rs.getString(1);			//������
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

	
	//��ѯһ����Ϣ
	public Cominfo getCominfo(String id)
	{
		Cominfo cominfo = new Cominfo();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from cominfo where cominfo_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String cominfo_id = rs.getString(1);			//�����
				String cominfo_bus = rs.getString(2); 		//����¥�̺�
				String cominfo_medical = rs.getString(3);		//����
				String cominfo_news = rs.getString(4);				//���佨�����
				String cominfo_weather = rs.getString(5);		//�������
				String cominfo_notice = rs.getString(6);
				
				cominfo.setCominfo_bus(cominfo_bus);
				cominfo.setCominfo_id(cominfo_id);
				cominfo.setCominfo_medical(cominfo_medical);
				cominfo.setCominfo_news(cominfo_news);
				cominfo.setCominfo_notice(cominfo_notice);
				cominfo.setCominfo_weather(cominfo_weather);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cominfo;
	}
	
	
	//�޸�
	public void updateCominfo(String cominfo_id,String cominfo_bus,String cominfo_medical,String cominfo_news,String cominfo_weather,String cominfo_notice)
	{
		String data1 = cominfo_id;			
		String data2 = cominfo_bus;
		String data3 = cominfo_medical;
		String data4 = cominfo_news;	
		String data5 = cominfo_weather;	
		String data6 = cominfo_notice;
			
		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 	
			PreparedStatement stmt = con.prepareStatement("update cominfo set cominfo_bus='"+data2+"',cominfo_medical='"+data3+"',cominfo_news='"+data4+"',cominfo_weather='"+data5+"',cominfo_notice='"+data6+"'where cominfo_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//ɾ��
	public void deleteCominfo(String cominfo_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from cominfo where cominfo_id='"+cominfo_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String cominfo_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from rooms where cominfo_id='"+cominfo_id+"'");
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

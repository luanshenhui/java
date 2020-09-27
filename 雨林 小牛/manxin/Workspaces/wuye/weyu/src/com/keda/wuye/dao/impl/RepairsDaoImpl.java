package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.RepairsDao;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;
import com.keda.wuye.util.ConnectionUtils;

public class RepairsDaoImpl implements RepairsDao {

	//��ʾ������Ϣ
	public List<Repairs> getRepairs()
	{
		List<Repairs> listRepairs = new ArrayList<Repairs>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from repairs");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String repairs_id = rs.getString(1);			//���ޱ��
				String repairs_plantid = rs.getString(2); 		//�豸���
				String repairs_date = rs.getString(3);		//����ʱ��
				String repairs_reason = rs.getString(4);				//����ԭ��
				String repairs_way = rs.getString(5);		//���޷�ʽ
				String repairs_person = rs.getString(6);		//������Ա
				String repairs_result = rs.getString(7);		//���޽��
				
				Repairs repairs = new Repairs();
				
				repairs.setRepairs_date(repairs_date);
				repairs.setRepairs_id(repairs_id);
				repairs.setRepairs_person(repairs_person);
				repairs.setRepairs_plantid(repairs_plantid);
				repairs.setRepairs_result(repairs_result);
				repairs.setRepairs_way(repairs_way);
				repairs.setRepairs_reason(repairs_reason);
				
				listRepairs.add(repairs);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listRepairs;
	}
	//��ʾ������Ϣ
	public List<Repairs> select(String s)
	{
		List<Repairs> listRepairs = new ArrayList<Repairs>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from repairs " +
					"where repairs_id like '%"+s+"%' " +
					"or repairs_plantid like '%"+s+"%' " +
					"or repairs_date like '%"+s+"%' " +
					"or repairs_reason like '%"+s+"%' " +
					"or repairs_way like '%"+s+"%' " +
					"or repairs_person like '%"+s+"%' " +
					"or repairs_result like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String repairs_id = rs.getString(1);			//���ޱ��
				String repairs_plantid = rs.getString(2); 		//�豸���
				String repairs_date = rs.getString(3);		//����ʱ��
				String repairs_reason = rs.getString(4);				//����ԭ��
				String repairs_way = rs.getString(5);		//���޷�ʽ
				String repairs_person = rs.getString(6);		//������Ա
				String repairs_result = rs.getString(7);		//���޽��
				
				Repairs repairs = new Repairs();
				
				repairs.setRepairs_date(repairs_date);
				repairs.setRepairs_id(repairs_id);
				repairs.setRepairs_person(repairs_person);
				repairs.setRepairs_plantid(repairs_plantid);
				repairs.setRepairs_result(repairs_result);
				repairs.setRepairs_way(repairs_way);
				repairs.setRepairs_reason(repairs_reason);
				
				listRepairs.add(repairs);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listRepairs;
	}
	//��ѯһ����Ϣ
	public Repairs getRepairs(String id)
	{
		Repairs repairs = new Repairs();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from repairs where repairs_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String repairs_id = rs.getString(1);			//���ޱ��
				String repairs_plantid = rs.getString(2); 		//�豸���
				String repairs_date = rs.getString(3);		//����ʱ��
				String repairs_reason = rs.getString(4);				//����ԭ��
				String repairs_way = rs.getString(5);		//���޷�ʽ
				String repairs_person = rs.getString(6);		//������Ա
				String repairs_result = rs.getString(7);		//���޽��
				
				repairs.setRepairs_date(repairs_date);
				repairs.setRepairs_id(repairs_id);
				repairs.setRepairs_person(repairs_person);
				repairs.setRepairs_plantid(repairs_plantid);
				repairs.setRepairs_result(repairs_result);
				repairs.setRepairs_way(repairs_way);
				repairs.setRepairs_reason(repairs_reason);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return repairs;
	}
	
	//���
	public void insertRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into repairs(repairs_id,repairs_plantid,repairs_date,repairs_reason,repairs_way,repairs_person,repairs_result) values('"+repairs_id+"','" +repairs_plantid+"','"+repairs_date+"','"+repairs_reason+"','"+repairs_way+"','"+repairs_person+"','"+repairs_result+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//�޸�
	public void updateRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result)
	{
		String data1 = repairs_id;			
		String data2 = repairs_plantid;
		String data3 = repairs_date;
		String data4 = repairs_reason;	
		String data5 = repairs_way;		
		String data6 = repairs_person;	
		String data7 = repairs_result;		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("update repairs set repairs_plantid='"+data2+"',repairs_date='"+data3+"',"+"repairs_reason='"+data4+"',repairs_way='"+data5+"',repairs_person='"+data6+"',repairs_result='"+data7+"'"+"where repairs_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//ɾ��
	public void deleteRepairs(String repairs_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from repairs where repairs_id='"+repairs_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String repairs_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from repairs where repairs_id='"+repairs_id+"'");
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
	
	//��ȡplant���е�С�����
	public List<String> get_plantid()
	{
		List<String> list_plantid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select plant_id from plant");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String plant_id = rs.getString(1);			//¥�̱��
				list_plantid.add(plant_id);	
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return list_plantid;
	}
	
}

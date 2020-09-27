package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.ComplaintDao;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.RepairsDao;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Complaint;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;
import com.keda.wuye.util.ConnectionUtils;

public class ComplaintDaoImpl implements ComplaintDao {
	//��ʾ������Ϣ
	public List<Complaint> getComplaint()
	{
		List<Complaint> listComplaint = new ArrayList<Complaint>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from complaint");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String complaint_id = rs.getString(1);			//Ͷ�߱��
				String complaint_resid = rs.getString(2); 		//Ͷ��ҵ��
				String complaint_date = rs.getString(3);		//Ͷ��ʱ��
				String complaint_matter = rs.getString(4);				//Ͷ���¼�
				String complaint_dealperson = rs.getString(5);		//������Ա
				String complaint_way = rs.getString(6);		//����ʽ
				String complaint_result = rs.getString(7);		//������
				
				Complaint complaint = new Complaint();
				
				complaint.setComplaint_date(complaint_date);
				complaint.setComplaint_dealperson(complaint_dealperson);
				complaint.setComplaint_id(complaint_id);
				complaint.setComplaint_matter(complaint_matter);
				complaint.setComplaint_resid(complaint_resid);
				complaint.setComplaint_result(complaint_result);
				complaint.setComplaint_way(complaint_way);
				
				listComplaint.add(complaint);	
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listComplaint;
	}
	
	//ģ����ѯ
	public List<Complaint> select(String s)
	{
		List<Complaint> listComplaint = new ArrayList<Complaint>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from complaint " +
					"where complaint_id like '%"+s+"%' " +
					"or complaint_resid like '%"+s+"%' " +
					"or complaint_date like '%"+s+"%' " +
					"or complaint_matter like '%"+s+"%' " +
					"or complaint_dealperson like '%"+s+"%' " +
					"or complaint_way like '%"+s+"%' " +
					"or complaint_result like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String complaint_id = rs.getString(1);			//Ͷ�߱��
				String complaint_resid = rs.getString(2); 		//Ͷ��ҵ��
				String complaint_date = rs.getString(3);		//Ͷ��ʱ��
				String complaint_matter = rs.getString(4);				//Ͷ���¼�
				String complaint_dealperson = rs.getString(5);		//������Ա
				String complaint_way = rs.getString(6);		//����ʽ
				String complaint_result = rs.getString(7);		//������
				
				Complaint complaint = new Complaint();
				
				complaint.setComplaint_date(complaint_date);
				complaint.setComplaint_dealperson(complaint_dealperson);
				complaint.setComplaint_id(complaint_id);
				complaint.setComplaint_matter(complaint_matter);
				complaint.setComplaint_resid(complaint_resid);
				complaint.setComplaint_result(complaint_result);
				complaint.setComplaint_way(complaint_way);
				
				listComplaint.add(complaint);	
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listComplaint;
	}
	
	//��ѯһ����Ϣ
	public Complaint getComplaint(String id)
	{
		Complaint complaint = new Complaint();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from complaint where complaint_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String complaint_id = rs.getString(1);			//Ͷ�߱��
				String complaint_resid = rs.getString(2); 		//Ͷ��ҵ��
				String complaint_date = rs.getString(3);		//Ͷ��ʱ��
				String complaint_matter = rs.getString(4);				//Ͷ���¼�
				String complaint_dealperson = rs.getString(5);		//������Ա
				String complaint_way = rs.getString(6);		//����ʽ
				String complaint_result = rs.getString(7);		//������
				
				complaint.setComplaint_date(complaint_date);
				complaint.setComplaint_dealperson(complaint_dealperson);
				complaint.setComplaint_id(complaint_id);
				complaint.setComplaint_matter(complaint_matter);
				complaint.setComplaint_resid(complaint_resid);
				complaint.setComplaint_result(complaint_result);
				complaint.setComplaint_way(complaint_way);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return complaint;
	}
	
	//���
	public void insertComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into complaint(complaint_id,complaint_resid,complaint_date,complaint_matter,complaint_dealperson,complaint_way,complaint_result) values('"+complaint_id+"','" +complaint_resid+"','" +complaint_date+"','"+complaint_matter+"','"+complaint_dealperson+"','"+complaint_way+"','"+complaint_result+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//�޸�
	public void updateComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result)
	{
		String data1 = complaint_id;			
		String data2 = complaint_resid;
		String data3 = complaint_date;
		String data4 = complaint_matter;	
		String data5 = complaint_dealperson;		
		String data6 = complaint_way;	
		String data7 = complaint_result;		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("update complaint set complaint_resid='"+data2+"',complaint_date='" +data3+"',complaint_matter='"+data4+"',complaint_dealperson='"+data5+"',complaint_way='"+data6+"',complaint_result='"+data7+"'"+"where complaint_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//ɾ��
	public void deleteComplaint(String complaint_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from complaint where complaint_id='"+complaint_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String complaint_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from complaint where complaint_id='"+complaint_id+"'");
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
	
	//��ȡresident���е�С�����
	public List<String> get_resiid()
	{
		List<String> list_resiid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select resident_id from resident");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String resident_id = rs.getString(1);			//¥�̱��
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

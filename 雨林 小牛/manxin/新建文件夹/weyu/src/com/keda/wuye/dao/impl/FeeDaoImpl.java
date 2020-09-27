package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.FeeDao;
import com.keda.wuye.dao.RoomsDao;
import com.keda.wuye.dao.UserDao;
import com.keda.wuye.entity.Fee;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Rooms;
import com.keda.wuye.entity.User;
import com.keda.wuye.util.ConnectionUtils;

public class FeeDaoImpl implements FeeDao {

	//��ʾ������Ϣ
	public List<Fee> getFee()
	{
		List<Fee> listFee = new ArrayList<Fee>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from fee");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String fee_id = rs.getString(1);			//�����
				String fee_comid = rs.getString(2); 		//����¥�̺�
				String fee_name = rs.getString(3);		//����
				double fee_standard = rs.getDouble(4);				//���佨�����
				String fee_date = rs.getString(5);		//�������
				
				Fee fee = new Fee();
				fee.setFee_comid(fee_comid);
				fee.setFee_date(fee_date);
				fee.setFee_id(fee_id);
				fee.setFee_name(fee_name);
				fee.setFee_standard(fee_standard);
				
				listFee.add(fee);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listFee;
	}
	//ģ����ѯ
	public List<Fee> select(String s)
	{
		List<Fee> listFee = new ArrayList<Fee>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from fee " +
					"where fee_id like '%"+s+"%' " +
					"or fee_comid like '%"+s+"%' " +
					"or fee_name like '%"+s+"%' " +
					"or fee_standard like '%"+s+"%' " +
					"or fee_date like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String fee_id = rs.getString(1);			//�����
				String fee_comid = rs.getString(2); 		//����¥�̺�
				String fee_name = rs.getString(3);		//����
				double fee_standard = rs.getDouble(4);				//���佨�����
				String fee_date = rs.getString(5);		//�������
				
				Fee fee = new Fee();
				fee.setFee_comid(fee_comid);
				fee.setFee_date(fee_date);
				fee.setFee_id(fee_id);
				fee.setFee_name(fee_name);
				fee.setFee_standard(fee_standard);
				
				listFee.add(fee);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listFee;
	}

	//���
	public void insertFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into fee(fee_id,fee_comid,fee_name,fee_standard,fee_date) values('"+fee_id+"','" +fee_comid+"','" +fee_name+"','"+fee_standard+"','"+fee_date+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//��ѯһ����Ϣ
	public Fee getFee(String id)
	{
		Fee fee = new Fee();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from fee where fee_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String fee_id = rs.getString(1);			//�����
				String fee_comid = rs.getString(2); 		//����¥�̺�
				String fee_name = rs.getString(3);		//����
				double fee_standard = rs.getDouble(4);				//���佨�����
				String fee_date = rs.getString(5);		//
				
				fee.setFee_comid(fee_comid);
				fee.setFee_date(fee_date);
				fee.setFee_id(fee_id);
				fee.setFee_name(fee_name);
				fee.setFee_standard(fee_standard);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return fee;
	}
	
	
	//�޸�
	public void updateFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date)
	{
		String data1 = fee_id;			
		String data2 = fee_comid;
		String data3 = fee_name;
		double data4 = fee_standard;	
		String data5 = fee_date;	
			
		try {
			Connection con = ConnectionUtils.openConnection(); 	
			PreparedStatement stmt = con.prepareStatement("update fee set fee_comid='"+data2+"',fee_name='"+data3+"',fee_standard='"+data4+"',fee_date="+data5+"where fee_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();																
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//ɾ��
	public void deleteFee(String fee_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from fee where fee_id='"+fee_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String fee_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from fee where fee_id='"+fee_id+"'");
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
	public List<String> get_comid()
	{
		List<String> list_comid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select com_id from community");
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

}

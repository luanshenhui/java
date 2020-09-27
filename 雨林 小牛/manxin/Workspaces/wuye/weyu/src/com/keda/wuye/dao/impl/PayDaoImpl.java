package com.keda.wuye.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.PayDao;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Pay;
import com.keda.wuye.util.ConnectionUtils;

public class PayDaoImpl implements PayDao {
	//显示所有信息
	public List<Pay> getPay()
	{
		List<Pay> listPay = new ArrayList<Pay>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from pay");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String pay_id = rs.getString(1);			//缴费编号
				String pay_resid = rs.getString(2); 		//业主编号
				String pay_feeid = rs.getString(3);		//费用编号（种类）
				double pay_number = rs.getDouble(4);				//支付数目
				String pay_date = rs.getString(5);		//支付时间
				double pay_overdue = rs.getDouble(6);		//欠费数目
				
				Pay pay = new Pay();
				pay.setPay_date(pay_date);
				pay.setPay_feeid(pay_feeid);
				pay.setPay_id(pay_id);
				pay.setPay_number(pay_number);
				pay.setPay_overdue(pay_overdue);
				pay.setPay_resid(pay_resid);
				
				listPay.add(pay);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listPay;
	}
	//显示所有信息
	public List<Pay> select(String s)
	{
		List<Pay> listPay = new ArrayList<Pay>();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from pay " +
					"where pay_id like '%"+s+"%' " +
					"or pay_resid like '%"+s+"%' " +
					"or pay_feeid like '%"+s+"%' " +
					"or pay_number like '%"+s+"%' " +
					"or pay_date like '%"+s+"%' " +
					"or pay_overdue like '%"+s+"%'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){									
				String pay_id = rs.getString(1);			//缴费编号
				String pay_resid = rs.getString(2); 		//业主编号
				String pay_feeid = rs.getString(3);		//费用编号（种类）
				double pay_number = rs.getDouble(4);				//支付数目
				String pay_date = rs.getString(5);		//支付时间
				double pay_overdue = rs.getDouble(6);		//欠费数目
				
				Pay pay = new Pay();
				pay.setPay_date(pay_date);
				pay.setPay_feeid(pay_feeid);
				pay.setPay_id(pay_id);
				pay.setPay_number(pay_number);
				pay.setPay_overdue(pay_overdue);
				pay.setPay_resid(pay_resid);
				
				listPay.add(pay);
				
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return listPay;
	}
	//查询一条信息
	public Pay getPay(String id)
	{
		Pay pay = new Pay();
		try {
			Connection con = ConnectionUtils.openConnection();
			PreparedStatement stmt = con.prepareStatement("select * from pay where pay_id='"+id+"'");
			
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String pay_id = rs.getString(1);			//缴费编号
				String pay_resid = rs.getString(2); 		//业主编号
				String pay_feeid = rs.getString(3);		//费用编号（种类）
				double pay_number = rs.getDouble(4);				//支付数目
				String pay_date = rs.getString(5);		//支付时间
				double pay_overdue = rs.getDouble(6);		//欠费数目
				
				pay.setPay_date(pay_date);
				pay.setPay_feeid(pay_feeid);
				pay.setPay_id(pay_id);
				pay.setPay_number(pay_number);
				pay.setPay_overdue(pay_overdue);
				pay.setPay_resid(pay_resid);
			}
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return pay;
	}
	
	//添加
	public void insertPay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue)
	{
		try {
			Connection con = ConnectionUtils.openConnection(); 																													
			PreparedStatement stmt = con.prepareStatement("insert into pay(pay_id,pay_resid,pay_feeid,pay_number,pay_date,pay_overdue) values('"+pay_id+"','" +pay_resid+"','"+pay_feeid+"','"+pay_number+"','"+pay_date+"','"+pay_overdue+"')");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//修改
	public void updatePay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue)
	{
		String data1 = pay_id;			
		String data2 = pay_resid;
		String data3 = pay_feeid;
		double data4 = pay_number;	
		String data5 = pay_date;		
		double data6 = pay_overdue;		
		
		try {
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("update pay set pay_resid='"+data2+"',pay_feeid='"+data3+"',pay_number='"+data4+"',pay_date='"+data5+"',pay_overdue='"+data6+"'"+"where pay_id='"+data1+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	//删除
	public void deletePay(String pay_id)
	{
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("delete from pay where pay_id='"+pay_id+"'");
			ResultSet rs = stmt.executeQuery();
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
	//判断编号是否重复
	public boolean idEqual(String pay_id)
	{
		boolean b=false;
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select * from pay where pay_id='"+pay_id+"'");
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
	
	//获取resident表中的住户编号
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
	
	//获取fee表中的费用编号
	public List<String> get_feeid()
	{
		List<String> list_feeid = new ArrayList<String>();
		try{
			Connection con = ConnectionUtils.openConnection(); 
			PreparedStatement stmt = con.prepareStatement("select fee_id from fee");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				String fee_id = rs.getString(1);			//楼盘编号
				list_feeid.add(fee_id);	
			}
			rs.close();
			stmt.close();
			con.close();
		}catch(SQLException e){
			e.printStackTrace();
		}
		return list_feeid;
	}
	
}

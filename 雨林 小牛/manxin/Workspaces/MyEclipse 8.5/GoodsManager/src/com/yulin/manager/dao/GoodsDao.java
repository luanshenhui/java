package com.yulin.manager.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Scanner;

import com.yulin.manager.bean.Goods;
import com.yulin.manager.util.DBUtil;

public class GoodsDao {
	private String queryAll = "select * from goods";
	private String insert = "insert into goods values(?,?,?,to_date(?,'yyyy-mm-dd'))";
	private String query = "select * from (select rownum r,id,cls,name,to_char(input_time,'yyyy-mm-dd')"
		+" from goods) where r >= ? and r <= ?";
	private String updateGood = "update goods set cls = ?,name = ?,input_time = to_date(?, 'yyyy-mm-dd') where id = ?";
	private String queryCount = "select count(*) from goods";
	private String deleteGood = "delete goods where id = ?";
	
	/*��ѯ�����е���Ʒ*/
	public ArrayList<Goods> findAll(){
		Connection conn = DBUtil.getConnextion();
		Goods goods = null;
		ArrayList<Goods> arr = new ArrayList<Goods>();
		try {
			PreparedStatement ps = conn.prepareStatement(queryAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				goods = new Goods(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getString(4));
				arr.add(goods);
			}
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return arr;
	}
	
	/*���һ����Ʒ*/
	public boolean insert(Goods goods){
		Connection conn = DBUtil.getConnextion();
		int flag = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(insert);
			ps.setInt(1, goods.getId());
			ps.setString(2, goods.getCls());
			ps.setString(3, goods.getName());
			ps.setString(4, goods.getInput_time());
			flag = ps.executeUpdate();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag == 1;	
	}
	
	/*ͨ��ҳ�������ƷÿҳҪ����ʾ5����Ʒ*/
	public ArrayList<Goods> findByPage(int page){
		Connection conn = DBUtil.getConnextion();
		Goods goods = null;
		ArrayList<Goods> arr = new ArrayList<Goods>();
		try {
			PreparedStatement ps = conn.prepareStatement(query);
			int from = 1 + (page - 1) * 5;
			int to = 5 * page;
			ps.setInt(1, from);
			ps.setInt(2, to);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				goods = new Goods(rs.getInt(2),rs.getString(3),rs.getString(4),rs.getString(5));
				arr.add(goods);
			}
			rs.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return arr;
		
	}
	
	/*�޸�*/
	public boolean updateGoods(Goods goods){
		Connection conn = DBUtil.getConnextion();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(updateGood);
			ps.setString(1, goods.getCls());
			ps.setString(2, goods.getName());
			ps.setString(3, goods.getInput_time());
			ps.setInt(4, goods.getId());
			falg = ps.executeUpdate();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	//������ж�������
	public int queryCount(){
		Connection conn = DBUtil.getConnextion();
		int count = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(queryCount);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				count = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;
	}
	
	/*ɾ��*/
	public boolean deleteGood(Goods goods){
		Connection conn = DBUtil.getConnextion();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(deleteGood);
			ps.setInt(1, goods.getId());
			falg = ps.executeUpdate();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	public static void main(String[] args) {
		GoodsDao gd = new GoodsDao();
		ArrayList<Goods> arr = gd.findAll();
		for(int i = 0; i < arr.size(); i++){
			System.out.println(arr.get(i));
		}
		//����
//		Goods goods = new Goods(10021,"������Ʒ","����","2013-4-15");
//		gd.insert(goods);
		//5����Ʒ	
//		System.out.println(gd.findByPage(2));
		
		//
		System.out.println(gd.queryCount());
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

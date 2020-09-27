package com.yulin.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import sun.security.pkcs11.Secmod.DbMode;

import com.yulin.web.DB.DBUtil;
import com.yulin.web.entity.Shopping;

public class ShoppingDao {
	private String findAll = "select * from t_computer";
	private String insert = "insert into t_computer values(?,?,?)";
	private String delete = "delete from t_computer where t_name = ?";
	private String update = "update t_computer set t_descript = ?,t_price = ? where t_name = ?";
	private String findByName = "select * from t_computer where t_name = ?";
	
	/*插入商品*/
	public boolean insert(Shopping shop){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(insert);
			ps.setString(1, shop.getT_name());
			ps.setString(2, shop.getT_descript());
			ps.setDouble(3, shop.getT_price());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	/*修改商品*/
	public boolean update(Shopping shop){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(update);
			ps.setString(1, shop.getT_descript());
			ps.setDouble(2, shop.getT_price());
			ps.setString(3, shop.getT_name());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	/*查找所有商品*/
	public List<Shopping> findAll(){
		Connection conn = DBUtil.getConn();
		Shopping shop = null;
		List<Shopping> list = new ArrayList<Shopping>();
		try {
			PreparedStatement ps = conn.prepareStatement(findAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				shop = new Shopping(rs.getString(1),rs.getString(2),rs.getDouble(3));
				list.add(shop);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/*删除商品*/
	public boolean delete(Shopping shop){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(delete);
			ps.setString(1, shop.getT_name());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	/*根据产品名字查找*/
	public List<Shopping> findByName(String t_name){
		Connection conn = DBUtil.getConn();
		Shopping shopping = null;
		List<Shopping> list = new ArrayList<Shopping>();
		try {
			PreparedStatement ps = conn.prepareStatement(findByName);
			ps.setString(1, t_name);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				shopping = new Shopping(rs.getString(1),rs.getString(2),rs.getDouble(3));
				list.add(shopping);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public static void main(String[] args) {
		ShoppingDao sd = new ShoppingDao();
		sd.insert(new Shopping("1","1",1));
	}
}

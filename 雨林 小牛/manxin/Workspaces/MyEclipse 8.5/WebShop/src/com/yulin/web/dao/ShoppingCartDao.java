package com.yulin.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.yulin.web.DB.DBUtil;
import com.yulin.web.entity.Shopping;
import com.yulin.web.entity.ShoppingCart;

public class ShoppingCartDao {
	private String findAll = "select * from t_computer_cart";
	private String updateNum = "update t_computer_cart set t_num = t_num + 1 where t_name = ?";
	private String delete = "delete from t_computer_cart where t_name = ?";
	private String insert = "insert into t_computer_cart values(?,?,?)";
	private String findByName = "select * from t_computer where t_name = ?";
	private String price = "select sum(t_price) from t_computer_cart";
	private String findCartByName = "select * from t_computer_cart where t_name = ?";
	private String updateCartNum = "update t_computer_cart set t_num = ? where t_name = ?";
	
	/*查询所有*/
	public List<ShoppingCart> findAll(){
		Connection conn = DBUtil.getConn();
		ShoppingCart sc = null;
		List<ShoppingCart> list = new ArrayList<ShoppingCart>();
		try {
			PreparedStatement ps = conn.prepareStatement(findAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				list.add(new ShoppingCart(rs.getString("t_name"),rs.getDouble("t_price"),rs.getDouble("t_num")));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/*插入*/
	public boolean insert(ShoppingCart sc){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(insert);
			ps.setString(1, sc.getT_name());
			ps.setString(2, sc.getT_name());
			ps.setDouble(3, sc.getT_num());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	/*查询价格*/
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
	
	/*查询购物车*/
	public List<ShoppingCart> findCartByName(String t_name){
		Connection conn = DBUtil.getConn();
		ShoppingCart shopping = null;
		List<ShoppingCart> list = new ArrayList<ShoppingCart>();
		try {
			PreparedStatement ps = conn.prepareStatement(findCartByName);
			ps.setString(1, t_name);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				shopping = new ShoppingCart(rs.getString(1),rs.getDouble(2),rs.getDouble(3));
				list.add(shopping);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/*修改数量*/
	public boolean updateNum(String t_name){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(updateNum);
			ps.setString(1, t_name);
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1; 
	}
	
	/*删除*/
	public boolean delete(ShoppingCart sc){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(delete);
			ps.setString(1, sc.getT_name());
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if(falg > 0){
			return true;
		}else{
			return false;
		}
	}
	
	/*修改数量*/
	public boolean updateCartNum(String t_name,double t_num){
		Connection conn = DBUtil.getConn();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(updateCartNum);
			ps.setDouble(1, t_num);
			ps.setString(2, t_name);
			falg = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	/*计算价格*/
	public int sumPrice(){
		Connection conn = DBUtil.getConn();
		int in = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(price);
			ResultSet rs = ps.executeQuery();
			rs.next();
			in = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return in;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

package com.yulin.web.service;

import java.util.List;

import com.yulin.web.dao.ShoppingCartDao;
import com.yulin.web.entity.Shopping;
import com.yulin.web.entity.ShoppingCart;

public class ShoppingCartService {
	ShoppingCartDao scd = new ShoppingCartDao();
	
	public List<ShoppingCart> findAll(){
		return scd.findAll();
	}
	
	public boolean insert(String t_name,double t_price, double t_num){
		return scd.insert(new ShoppingCart(t_name, t_price, t_num));
	}
	
	public List<Shopping> finfByName(String t_name){
		return scd.findByName(t_name);
	}
	
	public boolean updateNum(String t_name){
		return scd.updateNum(t_name);
	}
	
	public boolean delete(String t_name){
		ShoppingCart sc = new ShoppingCart();
		sc.setT_name(t_name);
		if(scd.delete(sc)){
			return true;
		}else{
			return false;
		}
	}
	
	public List<ShoppingCart> findCartByName(String t_name){
		return scd.findCartByName(t_name);
	}
	
	public boolean updateCartNum(String t_name,double t_num){
		return scd.updateCartNum(t_name, t_num);
	}
}

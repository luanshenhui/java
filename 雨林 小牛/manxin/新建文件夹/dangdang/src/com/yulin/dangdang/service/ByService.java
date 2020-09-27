package com.yulin.dangdang.service;

import java.util.ArrayList;
import java.util.List;

import com.yulin.dangdang.bean.Product;
import com.yulin.dangdang.dao.daoimpl.ItemDaoImpl;

public class ByService {
	List<Product> cart = new ArrayList<Product>();
	
	public List<Product> findAll(int id){
		return new ItemDaoImpl().findAll(id);
	}
	
	public List<Product> ListAll(int id){
		ByService bs = new ByService();
		List<Product> list = bs.findAll(id);
		for(int i = 0; i < cart.size(); i++){
			Product p = list.get(i);
			cart.add(p);
		}
		return cart;
	}
}

package com.yulin.web.service;

import java.util.List;

import com.yulin.web.dao.ShoppingDao;
import com.yulin.web.entity.Shopping;

public class ShoppingService {
	private ShoppingDao sd = new ShoppingDao();
	
	
	/*插入商品*/
	public boolean insert(String t_name,String t_descript,double t_price){
		return sd.insert(new Shopping(t_name,t_descript,t_price));
	}
	
	/*修改商品*/
	public boolean update(String t_name,String t_descript,double t_price){
		return sd.update(new Shopping(t_name,t_descript,t_price));
	}
	
	/*查询所有商品*/
	public List<Shopping> findAll(){
		return sd.findAll();
	}
	
	/*删除商品*/
	public boolean delete(String t_name){
		Shopping s = new Shopping();
		s.setT_name(t_name);
		return sd.delete(s);
	}
	
	/*通过产品名称查找*/
	public List<Shopping> finfByName(String t_name){
		return sd.findByName(t_name);
	}
}

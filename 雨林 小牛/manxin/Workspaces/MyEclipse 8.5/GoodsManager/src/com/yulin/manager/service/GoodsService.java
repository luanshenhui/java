package com.yulin.manager.service;

import java.util.*;

import com.yulin.manager.bean.Goods;
import com.yulin.manager.dao.GoodsDao;

public class GoodsService {
	
	private GoodsDao gd = new GoodsDao();
	private ArrayList<Goods> goods;
	
	public void findByPage(int page){
		goods = gd.findByPage(page);
	}

	public ArrayList<Goods> getGoods() {
		return goods;
	} 
	
	public boolean insert(int id,String cls,String name,String time){
		Goods g = new Goods();
		g.setId(id);
		g.setCls(cls);
		g.setName(name);
		g.setInput_time(time);
		if(gd.insert(g)){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean updateGood(int id,String cls,String name,String time){
		Goods g = new Goods();
		g.setId(id);
		g.setCls(cls);
		g.setName(name);
		g.setInput_time(time);
		if(gd.updateGoods(g)){
			return true;
		}else{
			return false;
		}
	}
	
	public int queryCount(){
		int count = gd.queryCount();
		return count;
	}
	
	public boolean deleteGood(int id){
		Goods goods = new Goods();
		goods.setId(id);
		if(gd.deleteGood(goods)){
			return true;
		}else{
			return false;
		}
	}
}

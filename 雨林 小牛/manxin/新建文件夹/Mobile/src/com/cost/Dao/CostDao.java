package com.cost.Dao;

import java.util.List;

import com.cost.entity.Cost;


public interface CostDao {
	//查找
	List<Cost> findAll() throws Exception;
	//添加
	Cost insertCost(Cost cost)throws Exception;
	//修改
	void updateCost(Cost cost)throws Exception;
	//删除
	void deleteCost(int id)throws Exception; 
	//id查找
	Cost finById(int id)throws Exception;
	//分页
	List<Cost> findPage(int page, int pageSize) throws Exception;
	//查询总页数
	public int findTotalPage(int pageSize) throws Exception;
	//查找资费名称
	Cost findByName(String name) throws Exception;
}

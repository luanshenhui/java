package com.yulin.dangdang.dao;

import java.util.List;

import com.yulin.dangdang.bean.Product;

public interface ProductDao {
	/**
	 * 通过id获得分类列表
	 * @param id 分类表中的id
	 * @return 返回商品列表
	 */
	public List<Product> findProduct(int id, int page);
	
	public List<Product> findAll();
	
	public List<Product> findProductByTime();
	
	public List<Product> findProductAll();
	
	public List<Product> findById(int id);
	
	public List<Product> findProductByTimeAll();
	
	public List<Product> findGood(int id);
}

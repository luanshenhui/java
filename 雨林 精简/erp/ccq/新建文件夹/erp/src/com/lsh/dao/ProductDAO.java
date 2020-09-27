package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Product;

public interface ProductDAO {
	
	/**
	 * 增加商品
	 * @param product
	 */
	public abstract void add(Product product);
	/**
	 * 修改商品
	 * @param product
	 */
	public abstract void update(Product product);
	
	/**
	 * 删除商品
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * 根据id查商品
	 * @param id
	 * @return
	 */
	public abstract Product getByID(long id);
	
	/**
	 *查询所有商品 
	 * @return
	 */
	public abstract List<Product> getAll();

}

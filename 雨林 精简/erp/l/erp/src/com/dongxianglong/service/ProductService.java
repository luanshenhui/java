/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Product;

/**
 * @author 董祥龙
 *
 * 2015-2-5下午03:11:49
 */
public interface ProductService {
	
	/**
	 * 增
	 * @param product
	 * @return
	 */
	public abstract boolean add(Product product);
	/**
	 * 删
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	/**
	 * 改
	 * @param product
	 * @return
	 */
	public abstract boolean update(Product product);
	/**
	 * 查单个
	 * @param id
	 * @return
	 */
	public abstract Product getByID(long id);
	/**
	 * 查所有
	 * @return
	 */
	public abstract List<Product> getAll();

}

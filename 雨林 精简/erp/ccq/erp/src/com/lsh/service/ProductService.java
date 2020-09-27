/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.domain.Product;

/**
 * @author 栾慎辉
 *
 * 2015-2-5下午03:17:29
 */
public interface ProductService {
	
	/**
	 * 增加一个商品
	 * @param product
	 * @return
	 */
	public abstract boolean add(Product product);
	
	/**
	 * 删除一个商品
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	/**
	 * 修改一个商品
	 * @param product
	 * @return
	 */
	public abstract boolean update(Product product);
	
	/**
	 * 修改一个商品
	 * @return
	 */
	public abstract Product getByID(long id);
	
	/**
	 * 修改所有
	 * @return
	 */
	public abstract List<Product>getAll();

}

/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Product;

/**
 * @author ������
 *
 * 2015-2-5����03:11:49
 */
public interface ProductService {
	
	/**
	 * ��
	 * @param product
	 * @return
	 */
	public abstract boolean add(Product product);
	/**
	 * ɾ
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	/**
	 * ��
	 * @param product
	 * @return
	 */
	public abstract boolean update(Product product);
	/**
	 * �鵥��
	 * @param id
	 * @return
	 */
	public abstract Product getByID(long id);
	/**
	 * ������
	 * @return
	 */
	public abstract List<Product> getAll();

}

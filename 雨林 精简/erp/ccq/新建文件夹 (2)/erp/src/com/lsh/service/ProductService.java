/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.domain.Product;

/**
 * @author ������
 *
 * 2015-2-5����03:17:29
 */
public interface ProductService {
	
	/**
	 * ����һ����Ʒ
	 * @param product
	 * @return
	 */
	public abstract boolean add(Product product);
	
	/**
	 * ɾ��һ����Ʒ
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	/**
	 * �޸�һ����Ʒ
	 * @param product
	 * @return
	 */
	public abstract boolean update(Product product);
	
	/**
	 * �޸�һ����Ʒ
	 * @return
	 */
	public abstract Product getByID(long id);
	
	/**
	 * �޸�����
	 * @return
	 */
	public abstract List<Product>getAll();

}

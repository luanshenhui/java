package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Product;

public interface ProductDAO {
	
	/**
	 * ������Ʒ
	 * @param product
	 */
	public abstract void add(Product product);
	/**
	 * �޸���Ʒ
	 * @param product
	 */
	public abstract void update(Product product);
	
	/**
	 * ɾ����Ʒ
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * ����id����Ʒ
	 * @param id
	 * @return
	 */
	public abstract Product getByID(long id);
	
	/**
	 *��ѯ������Ʒ 
	 * @return
	 */
	public abstract List<Product> getAll();

}

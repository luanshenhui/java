/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Category;

/**
 * @author ������
 *
 * 2015-2-5����03:03:06
 */
public interface CategoryService {
	
	/**
	 * ��
	 * @param category
	 * @return
	 */
	public abstract boolean add(Category category);
	/***
	 * ɾ
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	/**
	 * ��
	 * @param category
	 * @return
	 */
	public abstract boolean update(Category category);
	/**
	 * �鵥��
	 * @param id
	 * @return
	 */
	public abstract Category getByID(long id);
	/**
	 * ������
	 * @return
	 */
	public abstract List<Category> getAll();

}

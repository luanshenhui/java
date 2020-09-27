/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Category;

/**
 * @author 董祥龙
 *
 * 2015-2-5下午03:03:06
 */
public interface CategoryService {
	
	/**
	 * 增
	 * @param category
	 * @return
	 */
	public abstract boolean add(Category category);
	/***
	 * 删
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	/**
	 * 改
	 * @param category
	 * @return
	 */
	public abstract boolean update(Category category);
	/**
	 * 查单个
	 * @param id
	 * @return
	 */
	public abstract Category getByID(long id);
	/**
	 * 查所有
	 * @return
	 */
	public abstract List<Category> getAll();

}

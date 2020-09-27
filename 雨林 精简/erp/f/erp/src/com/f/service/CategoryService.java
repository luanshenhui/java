/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.domain.Category;

/**
 * @author 冯学明
 *
 * 2015-2-5下午3:02:18
 */
public interface CategoryService {
	
	
	/**
	 * //添加类别
	 * @param person
	 * @return 
	 */
	boolean add(Category category);
	/**
	 * //修改类别信息
	 * @param person
	 */
	boolean update(Category category);
	/**
	 * //删除类别
	 * @param id
	 */
	boolean delete(long id);
	/**
	 * //查看类别信息
	 * @param id
	 * @return Category
	 */
	Category getByID(long id);
	/**
	 * //查看所有类别
	 * @return list
	 */
	List<Category> getAll();

}

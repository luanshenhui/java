package com.f.DAO;

import java.util.List;

import com.f.domain.Category;

/**
 * 
 * @author 冯学明
 *
 * 2015-2-2下午4:44:39
 *类别的数据访问对象
 *
 */
public interface CategoryDAO {
	/**
	 * //添加类别
	 * @param person
	 */
	void add(Category category);
	/**
	 * //修改类别信息
	 * @param person
	 */
	void update(Category category);
	/**
	 * //删除类别
	 * @param id
	 */
	void delete(long id);
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

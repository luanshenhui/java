package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Category;

public interface CategoryDAO {
	/**
	 * 增加一个类别
	 * @param category
	 */
	public abstract void add(Category category);
	
	/**
	 * 修改一个类别
	 * @param category
	 */
	public abstract void update(Category category);
	
	/**
	 * 删除一个类别
	 * @param id
	 */
	public abstract void delete(long id);
	
	/**
	 * 根据id查询一个类别
	 * @param id
	 * @return
	 */
	public abstract Category getByID(long id);
	
	/**
	 * 查询所有类别
	 * @return
	 */
	public abstract List<Category>getAll();

}

package com.lsh.service;

import java.util.List;

import com.lsh.domain.Category;
import com.lsh.domain.Person;

public interface CategoryService {
	/**
	 * 增加一个类别
	 * @param category
	 * @return
	 */
	public abstract boolean add(Category category);
	
	/**
	 * 修改一个类别
	 * @param category
	 * @return
	 */
	public abstract boolean update(Category category);
	
	/**
	 * 删除一个类别
	 * @param id
	 * @return
	 */
	public abstract boolean delele(long id);
	
	/**
	 * 查找一个类别
	 * @param id
	 * @return
	 */
	public abstract Category getByID(long id);
	
	/**
	 * 查找所有类别
	 * @return
	 */
	public abstract List<Category>getAll();

}

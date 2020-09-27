package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Category;


/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午04:39:30
 * 
 * 类别的数据访问标准
 */

public interface CategoryDAO {
	
	/**
	 * 
	 * @param category
	 * 增
	 */
	public abstract void add( Category  category);
	/**
	 * 
	 * @param id
	 * 删
	 */
	
	public abstract void delete( long  id);
	
	/**
	 * 
	 * @param category
	 * 改
	 */
	
	public abstract void update( Category  category);
	
	/**
	 * 
	 * @param id
	 * @return
	 * 查单个
	 */
	public abstract  Category getByID( long id);
	
	/**
	 * 
	 * @return
	 * 查所有
	 */
   public abstract List<Category> getAll();
}

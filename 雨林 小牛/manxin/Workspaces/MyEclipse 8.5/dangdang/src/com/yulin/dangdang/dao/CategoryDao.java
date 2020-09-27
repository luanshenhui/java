package com.yulin.dangdang.dao;

import java.util.List;

import com.yulin.dangdang.bean.Category;

public interface CategoryDao {
	/**
	 * 根据parentId获得分类列表
	 * @param parentId 父分类的id 
	 * @return 返回子分类的列表
	 */
	public List<Category> findByParent_id(int parentId);
	
	public Category findById(int id);
	
	public Category findParentId(int id);
	
}

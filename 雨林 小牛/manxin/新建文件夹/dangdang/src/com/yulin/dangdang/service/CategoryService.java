package com.yulin.dangdang.service;

import java.util.List;

import com.yulin.dangdang.bean.Category;
import com.yulin.dangdang.dao.CategoryDao;
import com.yulin.dangdang.dao.daoimpl.CategoryDaoImpl;

public class CategoryService {
	public List<Category> findByParentId(int parentId){
		CategoryDao cd = new CategoryDaoImpl();
		return cd.findByParent_id(parentId);
	}
	
	public Category findById(int id){
		CategoryDao cd = new CategoryDaoImpl();
		return cd.findById(id);
	}
	
	public Category findParentId(int id){
		CategoryDao cd = new CategoryDaoImpl();
		return cd.findParentId(id);
	}
	
	public static void main(String[] args) {
		CategoryDao cate = new CategoryDaoImpl();
		System.out.println(cate.findParentId(3));
	}
}

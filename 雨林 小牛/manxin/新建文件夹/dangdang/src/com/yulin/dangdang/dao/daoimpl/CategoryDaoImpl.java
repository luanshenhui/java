package com.yulin.dangdang.dao.daoimpl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.yulin.dangdang.bean.Category;
import com.yulin.dangdang.common.MyBatisUtil;
import com.yulin.dangdang.dao.CategoryDao;

public class CategoryDaoImpl implements CategoryDao{
	private String namespace = "com.yulin.cateMapping";
	@Override
	public List<Category> findByParent_id(int parentId) {
		List<Category> list = new ArrayList<Category>();
		SqlSession session = MyBatisUtil.getSession();
		list = session.selectList(namespace + ".findByparent", parentId);
		return list;
	}
	
	public static void main(String[] args) {
//		List<Category> list = new CategoryDaoImpl().findByParent_id(1);
//		for(int i = 0; i < list.size(); i++){
//			System.out.println(list.get(i));
//		}
		CategoryDao cd = new CategoryDaoImpl();
		System.out.println(cd.findParentId(9));
	}

	@Override
	public Category findById(int id) {
		Category cate = null;
		SqlSession session = MyBatisUtil.getSession();
		cate = session.selectOne(namespace + ".findByIdCate", id);
		return cate;
	}

	@Override
	public Category findParentId(int id) {
		// 导航栏的位置显示
		Category cate = null;
		SqlSession session = MyBatisUtil.getSession();
		cate = session.selectOne(namespace + ".findParentId", id);
		return cate;
	}

}

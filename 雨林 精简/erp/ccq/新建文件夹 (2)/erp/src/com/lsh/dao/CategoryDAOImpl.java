package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Category;

public class CategoryDAOImpl extends BaseDAO implements CategoryDAO {
	private static final String NAMESPACE="com.lsh.domain.Category";
	public void add(Category category) {
		// TODO Auto-generated method stub
		session.insert(NAMESPACE+".add",category);
		session.commit();
	}

	public void delete(long id) {
		// TODO Auto-generated method stub
		session.delete(NAMESPACE+".del",id);
		session.commit();

	}

	public List<Category> getAll() {
		// TODO Auto-generated method stub
		List<Category>list=session.selectList(NAMESPACE+".all");
		return list;
	}

	public Category getByID(long id) {
		// TODO Auto-generated method stub
		Category c=session.selectOne(NAMESPACE+".getID",id);
		return c;
	}

	public void update(Category category) {
		// TODO Auto-generated method stub
		session.update(NAMESPACE+".update",category);
		session.commit();
	}
public static void main(String[] args) {
	CategoryDAO dao = new CategoryDAOImpl();
//	List<Category>list = dao.getAll();
//	for (Category p : list) {
//		System.out.println(p);
//		System.out.println(p.getList());
//	}
	
	Category c=dao.getByID(2);
	System.out.println(c);
}
}

package com.lsh.service;

import java.util.List;

import com.lsh.dao.CategoryDAO;
import com.lsh.dao.CategoryDAOImpl;
import com.lsh.domain.Category;

public class CategoryServiceImpl implements CategoryService {
private CategoryDAO dao=new CategoryDAOImpl();
	public boolean add(Category category) {
		// TODO Auto-generated method stub
		dao.add(category);
		return true;
	}

	public boolean delele(long id) {
		// TODO Auto-generated method stub
		dao.delete(id);
		return true;
	}

	public List<Category> getAll() {
		// TODO Auto-generated method stub
		return dao.getAll();
	}

	public Category getByID(long id) {
		// TODO Auto-generated method stub
		
		return dao.getByID(id);
	}

	public boolean update(Category category) {
		// TODO Auto-generated method stub
		dao.update(category);
		return true;
	}

}

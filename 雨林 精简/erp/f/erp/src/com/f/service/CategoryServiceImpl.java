/**
 * 
 */
package com.f.service;

import java.util.List;


import com.f.DAO.CategoryDAO;
import com.f.DAO.CategoryDAOImpl;
import com.f.domain.Category;

/**
 * @author ·ëÑ§Ã÷
 *
 * 2015-2-5ÏÂÎç3:07:28
 */
public class CategoryServiceImpl extends BaseService implements CategoryService {
	
	private  CategoryDAO dao=new CategoryDAOImpl();
	/* (non-Javadoc)
	 * @see com.f.service.CategoryService#add(com.f.domain.Category)
	 */
	public boolean add(Category category) {
		dao.add(category);
		return true;
		
	}

	/* (non-Javadoc)
	 * @see com.f.service.CategoryService#update(com.f.domain.Category)
	 */
	public boolean update(Category category) {
		dao.update(category);
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.CategoryService#delete(long)
	 */
	public boolean delete(long id) {
		dao.delete(id);
		return true;
		

	}

	/* (non-Javadoc)
	 * @see com.f.service.CategoryService#getByID(long)
	 */
	public Category getByID(long id) {
		
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.f.service.CategoryService#getAll()
	 */
	public List<Category> getAll() {
		
		return dao.getAll();
	}

}

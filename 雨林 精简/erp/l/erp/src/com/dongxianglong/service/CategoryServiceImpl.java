/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.dao.CategoryDAO;
import com.dongxianglong.dao.CategoryDAOImpl;
import com.dongxianglong.domain.Category;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-5ÏÂÎç03:07:28
 */
public class CategoryServiceImpl implements CategoryService {
  private CategoryDAO dao=new CategoryDAOImpl();
	/* (non-Javadoc)
	 * @see com.dongxianglong.service.CategoryService#add(com.dongxianglong.domain.Category)
	 */
	public boolean add(Category category) {
		dao.add(category);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.CategoryService#delete(long)
	 */
	public boolean delete(long id) {
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.CategoryService#getAll()
	 */
	public List<Category> getAll() {
		
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.CategoryService#getByID(long)
	 */
	public Category getByID(long id) {
		
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.CategoryService#update(com.dongxianglong.domain.Category)
	 */
	public boolean update(Category category) {
		dao.update(category);
		return true;
	}

}

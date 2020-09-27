/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Category;

/**
 * @author 冯学明
 *
 * 2015-2-2下午4:58:48
 *CategoryDAO实现类
 *
 */
public class CategoryDAOImpl extends BaseDAO implements CategoryDAO {
	
	
	private static final String NAMESPACE="com.f.domain.Category.";
	/* (non-Javadoc)
	 * @see com.f.DAO.CategoryDAO#add(com.f.domain.Category)
	 */
	public void add(Category category) {
		session.insert(NAMESPACE+"add",category);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.CategoryDAO#update(com.f.domain.Category)
	 */
	public void update(Category category) {
		session.update(NAMESPACE+"update",category);
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.f.DAO.CategoryDAO#delete(long)
	 */
	public void delete(long id) {
		session.delete(NAMESPACE+"delete",id);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.CategoryDAO#getByID(long)
	 */
	public Category getByID(long id) {
		Category category=session.selectOne(NAMESPACE+"getByID",id);
		return category;
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.CategoryDAO#getAll()
	 */
	public List<Category> getAll() {
		List<Category> list=session.selectList(NAMESPACE+"getAll");
		return list;
	}

}

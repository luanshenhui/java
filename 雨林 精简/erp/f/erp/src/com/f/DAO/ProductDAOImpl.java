/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Product;

/**
 * @author 冯学明
 *
 * 2015-2-2下午4:59:27
 *	ProductDAO实现类
 *
 */
public class ProductDAOImpl extends BaseDAO implements ProductDAO {
	private static final String NANMSPACE="com.f.domain.Product.";

	/* (non-Javadoc)
	 * @see com.f.DAO.ProductDAO#add(com.f.domain.Product)
	 */
	public void add(Product product) {
		session.insert(NANMSPACE+"add",product);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.ProductDAO#update(com.f.domain.Product)
	 */
	public void update(Product product) {
		session.update(NANMSPACE+"update",product);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.ProductDAO#delete(long)
	 */
	public void delete(long id) {
		session.delete(NANMSPACE+"delete",id);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.ProductDAO#getByID(long)
	 */
	public Product getByID(long id) {
		Product product=session.selectOne(NANMSPACE+"getByID", id);
		return product;
	}

	/* (non-Javadoc)
	 * @see com.f.DAO.ProductDAO#getAll()
	 */
	public List<Product> getAll() {
		List<Product> list=session.selectList(NANMSPACE+"getAll");
		return list;
	}
}

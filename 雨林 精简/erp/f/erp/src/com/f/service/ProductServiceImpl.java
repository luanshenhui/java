/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.DAO.ProductDAO;
import com.f.DAO.ProductDAOImpl;
import com.f.domain.Product;

/**
 * @author ·ëÑ§Ã÷
 *
 * 2015-2-5ÏÂÎç3:22:02
 */
public class ProductServiceImpl implements ProductService {
	private  ProductDAO dao=new ProductDAOImpl();
	/* (non-Javadoc)
	 * @see com.f.service.ProductService#add(com.f.domain.Product)
	 */
	public boolean add(Product product) {
		dao.add(product);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.ProductService#update(com.f.domain.Product)
	 */
	public boolean update(Product product) {
		dao.update(product);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.ProductService#delete(long)
	 */
	public boolean delete(long id) {
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.f.service.ProductService#getByID(long)
	 */
	public Product getByID(long id) {
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.f.service.ProductService#getAll()
	 */
	public List<Product> getAll() {
		return dao.getAll();
	}
	
}

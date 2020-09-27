/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.dao.ProductDAO;
import com.lsh.dao.ProductDAOImpl;
import com.lsh.domain.Product;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-5ÏÂÎç03:25:26
 */
public class ProductServiceImpl implements ProductService {
private ProductDAO dao=new ProductDAOImpl();
	/* (non-Javadoc)
	 * @see com.lsh.service.ProductService#add(com.lsh.domain.Product)
	 */
	public boolean add(Product product) {
		// TODO Auto-generated method stub
		dao.add(product);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.ProductService#delete(long)
	 */
	public boolean delete(long id) {
		// TODO Auto-generated method stub
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.ProductService#getAll()
	 */
	public List<Product> getAll() {
		// TODO Auto-generated method stub
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.ProductService#getByID()
	 */
	public Product getByID(long id) {
		// TODO Auto-generated method stub
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.lsh.service.ProductService#update(com.lsh.domain.Product)
	 */
	public boolean update(Product product) {
		// TODO Auto-generated method stub
		dao.update(product);
		return true;
	}

}

/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.dao.ProductDAO;
import com.dongxianglong.dao.ProductDAOImpl;
import com.dongxianglong.domain.Product;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-5ÏÂÎç03:15:43
 */
public class ProductServiceImpl implements ProductService {

	private ProductDAO dao=new ProductDAOImpl();
	/* (non-Javadoc)
	 * @see com.dongxianglong.service.ProductService#add(com.dongxianglong.domain.Product)
	 */
	public boolean add(Product product) {
		dao.add(product);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.ProductService#delete(long)
	 */
	public boolean delete(long id) {
		dao.delete(id);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.ProductService#getAll()
	 */
	public List<Product> getAll() {
		
		return dao.getAll();
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.ProductService#getByID(long)
	 */
	public Product getByID(long id) {
		
		return dao.getByID(id);
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.service.ProductService#update(com.dongxianglong.domain.Product)
	 */
	public boolean update(Product product) {
		dao.update(product);
		return true;
	}

}

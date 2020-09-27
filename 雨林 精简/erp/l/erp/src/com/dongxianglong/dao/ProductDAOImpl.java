/**
 * 
 */
package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Product;

/**
 * @author ¶­ÏéÁú
 *
 * 2015-2-2ÏÂÎç05:02:40
 */
public class ProductDAOImpl extends BaseDAO implements ProductDAO {
	
     private static final String NAMESPACE="com.dongxianglong.domain.Product.";
	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.ProductDAO#add(com.dongxianglong.domain.Product)
	 */
	public void add(Product product) {
		session.insert(NAMESPACE+"add",product);
        session.commit();
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.ProductDAO#delete(long)
	 */
	public void delete(long id) {
		session.delete(NAMESPACE+"delete",id);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.ProductDAO#getAll()
	 */
	public List<Product> getAll() {
		List<Product>list=session.selectList(NAMESPACE+"all");
		return list;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.ProductDAO#getByID(long)
	 */
	public Product getByID(long id) {
		Product product=session.selectOne(NAMESPACE+"one",id);
		return product;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.ProductDAO#update(com.dongxianglong.domain.Product)
	 */
	public void update(Product product) {
		session.update(NAMESPACE+"update",product);
		session.commit();
	}
	public static void main(String[] args)
	{
//		ProductDAO dao=new ProductDAOImpl();
//		List<Product>list=dao.getAll();
//		for(Product p:list)
//		{
//		System.out.println(p);
//		System.out.println(p.getCategory());
//		}
//		Product p=dao.getByID(2);
//		System.out.println(p+p.getCategory().getName());
	}

}

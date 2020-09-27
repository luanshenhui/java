/**
 * 
 */
package com.lsh.dao;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.lsh.domain.Product;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-2ÏÂÎç05:07:27
 */
public class ProductDAOImpl extends BaseDAO implements ProductDAO {
	private static final String  NAMESPACE="com.lsh.domain.Product";

	/* (non-Javadoc)
	 * @see com.lsh.dao.ProductDAO#add(com.lsh.domain.Product)
	 */
	public void add(Product product) {
		// TODO Auto-generated method stub
		session.insert(NAMESPACE+".add",product);
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.ProductDAO#delete(com.lsh.domain.Product)
	 */
	public void delete(long id) {
		// TODO Auto-generated method stub
		session.delete(NAMESPACE+".del",id);
		session.commit();

	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.ProductDAO#getAll()
	 */
	public List<Product> getAll() {
		// TODO Auto-generated method stub
	
//		try {
//			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
//			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");
//			SqlSession session=factory.openSession();
		List<Product>list=session.selectList("com.lsh.domain.Product.all");
			
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		

		return list;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.ProductDAO#getByID(long)
	 */
	public Product getByID(long id) {
		// TODO Auto-generated method stub
		Product product=session.selectOne(NAMESPACE+".getID",id);
		return product;
	}

	/* (non-Javadoc)
	 * @see com.lsh.dao.ProductDAO#update(com.lsh.domain.Product)
	 */
	public void update(Product product) {
		// TODO Auto-generated method stub
		session.update(NAMESPACE+".update",product);
		session.commit();

	}
	public static void main(String[] args) {
		ProductDAO dao = new ProductDAOImpl();
		List<Product>list = dao.getAll();
		for (Product p : list) {
			System.out.println(p);
			System.out.println(p.getCategory());
			System.out.println();
		}
		
		Product p=dao.getByID(1);
	}
}

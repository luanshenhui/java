/**
 * 
 */
package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Category;
import com.dongxianglong.domain.Product;

/**
 * @author 董祥龙
 *
 * 2015-2-2下午04:59:15
 * 类别DAO的实现类
 * 
 */
public class CategoryDAOImpl extends BaseDAO implements CategoryDAO {
	
	private static final String NAMESPACE="com.dongxianglong.domain.Category.";

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.CategoryDAO#add(com.dongxianglong.domain.Category)
	 */
	public void add(Category category) {
		session.insert(NAMESPACE+"add",category);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.CategoryDAO#delete(long)
	 */
	public void delete(long id) {
		session.delete(NAMESPACE+"delete",id);
		session.commit();
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.CategoryDAO#getAll()
	 */
	public List<Category> getAll() {
		
		List<Category>list=session.selectList(NAMESPACE+"all");
		return list;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.CategoryDAO#getByID(long)
	 */
	public Category getByID(long id) {
		
		Category category=session.selectOne(NAMESPACE+"one",id);
		return category;
	}

	/* (non-Javadoc)
	 * @see com.dongxianglong.dao.CategoryDAO#update(com.dongxianglong.domain.Category)
	 */
	public void update(Category category) {
		session.update(NAMESPACE+"update",category);
		session.commit();
	}
	
	public static void main(String[] args)
	{
//		CategoryDAO c=new CategoryDAOImpl();
//		List<Category>list=c.getAll();
//		for(Category ca:list)
//		{
//			System.out.println(ca);
//			for(Product p:ca.getList()){
//				System.out.println(p);
//			}
//		}
	//	System.out.println(c.getByID(2));
//		Category ca =new Category();
		
//		ca=c.getByID(2);
//		System.out.println(ca);
		
	}

}

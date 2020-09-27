package com.f.DAO;

import java.util.List;

import com.f.domain.Product;
/**
 * 
 * @author 冯学明
 *
 * 2015-2-2下午4:45:16
 *产品的数据访问对象
 */


public interface ProductDAO {
	/**
	 * //添加商品
	 * @param person
	 */
	void add(Product product);
	/**
	 * //修改商品信息
	 * @param person
	 */
	void update(Product product);
	/**
	 * //删除商品
	 * @param id
	 */
	void delete(long id);
	/**
	 * //查看商品信息
	 * @param id
	 * @return Product
	 */
	Product getByID(long id);
	/**
	 * //查看所有商品
	 * @return list
	 */
	List<Product> getAll();
}

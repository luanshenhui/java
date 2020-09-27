package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Product;

/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午04:44:37
 * 产品类别的数据访问接口
 */

public interface ProductDAO {
	
	/**
	 * 
	 * @param product
	 * 增
	 */
		public abstract void add(Product product);
		
		/**
		 * 
		 * @param id
		 * 删
		 */
		public abstract void delete(long id);
		/**
		 * 
		 * @param product
		 * 改
		 */
		public abstract void update(Product product);
		
		/**
		 * 
		 * @param id
		 * @return
		 * 查单个
		 */
		public abstract Product getByID(long id);
		
		/**
		 * 
		 * @return
		 * 查所有
		 */
		public abstract List<Product> getAll();

}

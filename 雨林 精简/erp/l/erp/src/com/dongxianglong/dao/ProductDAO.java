package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Product;

/**
 * 
 * @author ������
 *
 * 2015-2-2����04:44:37
 * ��Ʒ�������ݷ��ʽӿ�
 */

public interface ProductDAO {
	
	/**
	 * 
	 * @param product
	 * ��
	 */
		public abstract void add(Product product);
		
		/**
		 * 
		 * @param id
		 * ɾ
		 */
		public abstract void delete(long id);
		/**
		 * 
		 * @param product
		 * ��
		 */
		public abstract void update(Product product);
		
		/**
		 * 
		 * @param id
		 * @return
		 * �鵥��
		 */
		public abstract Product getByID(long id);
		
		/**
		 * 
		 * @return
		 * ������
		 */
		public abstract List<Product> getAll();

}

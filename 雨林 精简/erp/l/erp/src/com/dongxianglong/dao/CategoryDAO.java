package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Category;


/**
 * 
 * @author ������
 *
 * 2015-2-2����04:39:30
 * 
 * �������ݷ��ʱ�׼
 */

public interface CategoryDAO {
	
	/**
	 * 
	 * @param category
	 * ��
	 */
	public abstract void add( Category  category);
	/**
	 * 
	 * @param id
	 * ɾ
	 */
	
	public abstract void delete( long  id);
	
	/**
	 * 
	 * @param category
	 * ��
	 */
	
	public abstract void update( Category  category);
	
	/**
	 * 
	 * @param id
	 * @return
	 * �鵥��
	 */
	public abstract  Category getByID( long id);
	
	/**
	 * 
	 * @return
	 * ������
	 */
   public abstract List<Category> getAll();
}

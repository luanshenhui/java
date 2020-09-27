/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.domain.Category;

/**
 * @author ��ѧ��
 *
 * 2015-2-5����3:02:18
 */
public interface CategoryService {
	
	
	/**
	 * //������
	 * @param person
	 * @return 
	 */
	boolean add(Category category);
	/**
	 * //�޸������Ϣ
	 * @param person
	 */
	boolean update(Category category);
	/**
	 * //ɾ�����
	 * @param id
	 */
	boolean delete(long id);
	/**
	 * //�鿴�����Ϣ
	 * @param id
	 * @return Category
	 */
	Category getByID(long id);
	/**
	 * //�鿴�������
	 * @return list
	 */
	List<Category> getAll();

}

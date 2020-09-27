package com.f.DAO;

import java.util.List;

import com.f.domain.Category;

/**
 * 
 * @author ��ѧ��
 *
 * 2015-2-2����4:44:39
 *�������ݷ��ʶ���
 *
 */
public interface CategoryDAO {
	/**
	 * //������
	 * @param person
	 */
	void add(Category category);
	/**
	 * //�޸������Ϣ
	 * @param person
	 */
	void update(Category category);
	/**
	 * //ɾ�����
	 * @param id
	 */
	void delete(long id);
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

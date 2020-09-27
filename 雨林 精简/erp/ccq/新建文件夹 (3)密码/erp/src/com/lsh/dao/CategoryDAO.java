package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Category;

public interface CategoryDAO {
	/**
	 * ����һ�����
	 * @param category
	 */
	public abstract void add(Category category);
	
	/**
	 * �޸�һ�����
	 * @param category
	 */
	public abstract void update(Category category);
	
	/**
	 * ɾ��һ�����
	 * @param id
	 */
	public abstract void delete(long id);
	
	/**
	 * ����id��ѯһ�����
	 * @param id
	 * @return
	 */
	public abstract Category getByID(long id);
	
	/**
	 * ��ѯ�������
	 * @return
	 */
	public abstract List<Category>getAll();

}

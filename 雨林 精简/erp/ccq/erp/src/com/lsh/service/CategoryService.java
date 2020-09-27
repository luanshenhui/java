package com.lsh.service;

import java.util.List;

import com.lsh.domain.Category;
import com.lsh.domain.Person;

public interface CategoryService {
	/**
	 * ����һ�����
	 * @param category
	 * @return
	 */
	public abstract boolean add(Category category);
	
	/**
	 * �޸�һ�����
	 * @param category
	 * @return
	 */
	public abstract boolean update(Category category);
	
	/**
	 * ɾ��һ�����
	 * @param id
	 * @return
	 */
	public abstract boolean delele(long id);
	
	/**
	 * ����һ�����
	 * @param id
	 * @return
	 */
	public abstract Category getByID(long id);
	
	/**
	 * �����������
	 * @return
	 */
	public abstract List<Category>getAll();

}

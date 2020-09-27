package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Person;

/**
 * DAO:���ݷ��ʶ���
 * 
 * �û������ݷ��ʽӿ�
 * 
 * */


public interface PersonDAO {
	
	/**
	 * 
	 * @param person
	 * ��
	 * 
	 */
	
	public abstract void add(Person person);
	
	
	/**
	 * @author Administrator
	 * ɾ
	 * 
	 */
	public abstract void delete(long id);
	

	
	/**
	 * 
	 * @param person
	 * ��
	 */
	public abstract void update(Person person);
	
	
	
	/**
	 * 
	 * @param id
	 * �鵥��
	 */
	public abstract Person getByID(long id);
	
/**
 * 
 * @return
 * 
 * ������
 */
	public abstract List<Person> getAll();
	

}

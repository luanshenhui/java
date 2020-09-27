package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Person;

/**
 * DAO��
 * 
 * person�û���
 * 
 * ���ݷ��ʶ���
 */
public interface PersonDAO {
	/**
	 * ����һ���û�
	 * @param person
	 */
	public abstract void add(Person person); 
	
	/**
	 * �޸�һ���û�
	 * @param person
	 */
	public abstract void update(Person person); 
	
	/**
	 * ����idɾ���û�
	 * @param id
	 */
	public abstract void delete(long id); 
	
	/**
	 * ��ѯһ���û�
	 * @param id
	 * @return
	 */
	public abstract Person getByID(long id); 
	
	/**
	 * ��ѯ�����û�
	 * @return
	 */
	public abstract List<Person> getAll(); 
	
	
}

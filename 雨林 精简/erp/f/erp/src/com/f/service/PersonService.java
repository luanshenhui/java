package com.f.service;

import java.util.List;

import com.f.domain.Person;
/**
 * 
 * @author ��ѧ��
 *		�û���ҵ����
 *		EIS:�洢
 *		DAO�����ݵķ���
 *		Service��ҵ��Ĺ���
 *
 * 2015-2-5����2:01:47
 */


public interface PersonService {
	/**
	 * ��¼
	 * @param username
	 * @param password
	 * @return
	 */
	boolean islogin(String username,String password);
	/**
	 *  ע��
	 * @param person
	 * @return
	 */
	
	boolean register(Person person);
	/**
	 * �����û�����ȡ�û�����
	 * @param username
	 * @return
	 */
	public abstract Person getPersonByName(String username);
	
	/**
	 * �鿴������Ϣ
	 * @param id
	 * @return
	 */
	Person getByID(long id);
	
	/**
	 * �޸ĸ�����Ϣ
	 * @param person
	 * @return
	 */
	boolean Uinformtion(Person person);
	/**
	 * �޸�����
	 * @param id
	 * @param password
	 * @return
	 */
	boolean Upassword(Person person);
	
	/**
	 * ע��
	 */
	void invalidate();
	/**
	 * �鿴����
	 * @return
	 */
	List<Person> getAll();
	

	
}

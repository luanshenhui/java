/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Person;

/**
 * @author ������
 * 
 *     EIS�㣺�洢��
 *     DAO�㣺���ݵķ���
 * Service�㣺ҵ��Ĺ���(��һ����DAO����з�װ���ڶ��������µ�ҵ�񷽷���)
 *    
 *
 * 2015-2-5����02:01:57
 * �û���ҵ���׼
 */
public interface PersonService {
	
	/**
	 * ע��
	 * @param person
	 * @return
	 */
	public abstract boolean register(Person person);
	/**
	 * �޸�
	 * @param person
	 * @return
	 */
	public abstract boolean update(Person person);
	/**
	 * ע��
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	/**
	 * �鿴��ϸ��Ϣ
	 * @param id
	 * @return
	 */
	public abstract Person getByID(long id);
	
	/**
	 * �鿴����
	 * @return
	 */
	public abstract List<Person> getAll();
	
	/**
	 * ��¼
	 * ��ӵ��·���
	 * @param username
	 * @param password
	 * @return
	 */
	public abstract boolean isLogin(String username,String password);
	
	
	/**
	 * �����û�����ȡ�û�����
	 * @param username
	 * @return
	 */
	public abstract Person getPersonByName(String username);
	
	
	
	

}

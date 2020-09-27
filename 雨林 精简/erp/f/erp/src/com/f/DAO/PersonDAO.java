package com.f.DAO;

import java.util.List;

import com.f.domain.Person;

/**
 * 
 * @author ��ѧ��
 *
 * 2015-2-2����4:27:02
 *	�û������ݷ��ʽӿ�
 *
 */

public interface PersonDAO {
	/**
	 * //����û�
	 * @param person
	 */
	void add(Person person);
	/**
	 * //�޸��û���Ϣ
	 * @param person
	 */
	void update(Person person);
	/**
	 * //ɾ���û�
	 * @param id
	 */
	void delete(long id);
	/**
	 * //�鿴�û���Ϣ
	 * @param id
	 * @return Person
	 */
	Person getByID(long id);
	/**
	 * //�鿴�����û�
	 * @return list
	 */
	List<Person> getAll();
}

/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.domain.Repertory;

/**
 * @author ��ѧ��
 *
 * 2015-2-5����3:21:08
 */
public interface RepertoryService {
	/**
	 * //�޸Ŀ����Ʒ
	 * @param person
	 * @return 
	 */
	boolean add(Repertory repertory);
	/**
	 * //�޸���Ʒ��Ϣ
	 * @param person
	 */
	boolean update(Repertory repertory);
	/**
	 * //ɾ����Ʒ
	 * @param id
	 */
	boolean delete(long id);
	/**
	 * //�鿴��Ʒ��Ϣ
	 * @param id
	 * @return Person
	 */
	Repertory getByID(long id);
	/**
	 * //�鿴������Ʒ
	 * @return list
	 */
	List<Repertory> getAll();

}

/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.domain.Sell;

/**
 * @author ��ѧ��
 *
 * 2015-2-5����3:18:56
 */
public interface SellService {
	/**
	 * //���������Ϣ
	 * @param person
	 */
	boolean add(Sell sell);
	/**
	 * //�޸�������Ϣ
	 * @param person
	 */
	boolean update(Sell sell);
	/**
	 * //ɾ������
	 * @param id
	 * @return 
	 */
	boolean delete(long id);
	/**
	 * //�鿴������Ϣ
	 * @param id
	 * @return Person
	 */
	Sell getByID(long id);
	/**
	 * //�鿴����������Ϣ
	 * @return list
	 */
	List<Sell> getAll();
}

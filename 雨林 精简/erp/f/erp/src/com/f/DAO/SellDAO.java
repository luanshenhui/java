/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Sell;

/**
 * @author ��ѧ��
 *
 * 2015-2-2����5:09:13
 * ���۵����ݷ��ʶ���
 */
public interface SellDAO {
	/**
	 * //���������Ϣ
	 * @param person
	 */
	void add(Sell sell);
	/**
	 * //�޸�������Ϣ
	 * @param person
	 */
	void update(Sell sell);
	/**
	 * //ɾ������
	 * @param id
	 */
	void delete(long id);
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

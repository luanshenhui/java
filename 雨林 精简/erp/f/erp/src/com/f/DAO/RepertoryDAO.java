/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Repertory;

/**
 * @author ��ѧ��
 *
 * 2015-2-2����5:12:32
 * �������ݷ��ʶ���
 *
 */
public interface RepertoryDAO {
	/**
	 * //�����Ʒ
	 * @param person
	 */
	void add(Repertory repertory);
	/**
	 * //�޸���Ʒ��Ϣ
	 * @param person
	 */
	void update(Repertory repertory);
	/**
	 * //ɾ����Ʒ
	 * @param id
	 */
	void delete(long id);
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

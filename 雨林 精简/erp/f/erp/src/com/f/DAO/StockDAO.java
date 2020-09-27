/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Stock;


/**
 * @author ��ѧ��
 *
 * 2015-2-2����5:03:42
 *���������ݷ��ʶ���
 */
public interface StockDAO {
	/**
	 * //��ӽ���
	 * @param person
	 */
	void add(Stock stock);
	/**
	 * //�޸Ľ�����Ϣ
	 * @param person
	 */
	void update(Stock stock);
	/**
	 * //ɾ��������Ϣ
	 * @param id
	 */
	void delete(long id);
	/**
	 * //�鿴�û���Ϣ
	 * @param id
	 * @return Person
	 */
	Stock getByID(long id);
	/**
	 * //�鿴�����û�
	 * @return list
	 */
	List<Stock> getAll();
}

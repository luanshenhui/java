package com.f.DAO;

import java.util.List;

import com.f.domain.Product;
/**
 * 
 * @author ��ѧ��
 *
 * 2015-2-2����4:45:16
 *��Ʒ�����ݷ��ʶ���
 */


public interface ProductDAO {
	/**
	 * //�����Ʒ
	 * @param person
	 */
	void add(Product product);
	/**
	 * //�޸���Ʒ��Ϣ
	 * @param person
	 */
	void update(Product product);
	/**
	 * //ɾ����Ʒ
	 * @param id
	 */
	void delete(long id);
	/**
	 * //�鿴��Ʒ��Ϣ
	 * @param id
	 * @return Product
	 */
	Product getByID(long id);
	/**
	 * //�鿴������Ʒ
	 * @return list
	 */
	List<Product> getAll();
}

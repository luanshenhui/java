package com.f.service;

import java.util.List;

import com.f.domain.Product;

public interface ProductService {
	/**
	 * //�����Ʒ
	 * @param person
	 */
	boolean add(Product product);
	/**
	 * //�޸���Ʒ��Ϣ
	 * @param person
	 */
	boolean update(Product product);
	/**
	 * //ɾ����Ʒ
	 * @param id
	 */
	boolean delete(long id);
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

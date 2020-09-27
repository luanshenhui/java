package com.f.service;

import java.util.List;

import com.f.domain.Product;

public interface ProductService {
	/**
	 * //添加商品
	 * @param person
	 */
	boolean add(Product product);
	/**
	 * //修改商品信息
	 * @param person
	 */
	boolean update(Product product);
	/**
	 * //删除商品
	 * @param id
	 */
	boolean delete(long id);
	/**
	 * //查看商品信息
	 * @param id
	 * @return Product
	 */
	Product getByID(long id);
	/**
	 * //查看所有商品
	 * @return list
	 */
	List<Product> getAll();
}

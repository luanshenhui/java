/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.domain.Repertory;

/**
 * @author 冯学明
 *
 * 2015-2-5下午3:21:08
 */
public interface RepertoryService {
	/**
	 * //修改库存商品
	 * @param person
	 * @return 
	 */
	boolean add(Repertory repertory);
	/**
	 * //修改商品信息
	 * @param person
	 */
	boolean update(Repertory repertory);
	/**
	 * //删除商品
	 * @param id
	 */
	boolean delete(long id);
	/**
	 * //查看商品信息
	 * @param id
	 * @return Person
	 */
	Repertory getByID(long id);
	/**
	 * //查看所有商品
	 * @return list
	 */
	List<Repertory> getAll();

}

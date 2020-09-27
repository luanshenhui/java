/**
 * 
 */
package com.f.service;

import java.util.List;

import com.f.domain.Sell;

/**
 * @author 冯学明
 *
 * 2015-2-5下午3:18:56
 */
public interface SellService {
	/**
	 * //添加销售信息
	 * @param person
	 */
	boolean add(Sell sell);
	/**
	 * //修改销售信息
	 * @param person
	 */
	boolean update(Sell sell);
	/**
	 * //删除销售
	 * @param id
	 * @return 
	 */
	boolean delete(long id);
	/**
	 * //查看销售信息
	 * @param id
	 * @return Person
	 */
	Sell getByID(long id);
	/**
	 * //查看所有销售信息
	 * @return list
	 */
	List<Sell> getAll();
}

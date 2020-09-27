/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Sell;

/**
 * @author 冯学明
 *
 * 2015-2-2下午5:09:13
 * 销售的数据访问对象
 */
public interface SellDAO {
	/**
	 * //添加销售信息
	 * @param person
	 */
	void add(Sell sell);
	/**
	 * //修改销售信息
	 * @param person
	 */
	void update(Sell sell);
	/**
	 * //删除销售
	 * @param id
	 */
	void delete(long id);
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

/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Stock;


/**
 * @author 冯学明
 *
 * 2015-2-2下午5:03:42
 *进货的数据访问对象
 */
public interface StockDAO {
	/**
	 * //添加进货
	 * @param person
	 */
	void add(Stock stock);
	/**
	 * //修改进货信息
	 * @param person
	 */
	void update(Stock stock);
	/**
	 * //删除进货信息
	 * @param id
	 */
	void delete(long id);
	/**
	 * //查看用户信息
	 * @param id
	 * @return Person
	 */
	Stock getByID(long id);
	/**
	 * //查看所有用户
	 * @return list
	 */
	List<Stock> getAll();
}

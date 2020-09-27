/**
 * 
 */
package com.lsh.service;

import java.util.List;

import com.lsh.domain.Sell;

/**
 * @author 栾慎辉
 *
 * 2015-2-5下午03:43:19
 */
public interface SellService {
	/**
	 * 增加一个销售
	 * @param sell
	 * @return
	 */
	public abstract boolean add(Sell sell);
	
	/**
	 * 修改一个销售
	 * @param sell
	 * @return
	 */
	public abstract boolean update(Sell sell);
	
	/**
	 * 删除一个销售
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	
	/**
	 * 查找一个销售
	 * @param id
	 * @return
	 */
	public abstract Sell getByID(long id);
	
	/**
	 * 查找所有销售
	 * @return
	 */
	public abstract List<Sell> getAll();

}

package com.lsh.dao;

import java.util.List;


import com.lsh.domain.Sell;

public interface SellDAO {
	
	/**
	 * 增加销售
	 * @param product
	 */
	public abstract void add(Sell sell);
	/**
	 * 修改销售
	 * @param product
	 */
	public abstract void update(Sell sell);
	
	/**
	 * 删除销售
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * 根据id查销售
	 * @param id
	 * @return
	 */
	public abstract Sell getByID(long id);
	
	/**
	 *查询所有销售
	 * @return
	 */
	public abstract List<Sell> getAll();

}

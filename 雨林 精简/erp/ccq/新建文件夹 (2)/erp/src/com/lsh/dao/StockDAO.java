package com.lsh.dao;

import java.util.List;


import com.lsh.domain.Stock;

public interface StockDAO {
	
	/**
	 * 增加进货
	 * @param product
	 */
	public abstract void add(Stock stock);
	/**
	 * 修改进货
	 * @param product
	 */
	public abstract void update(Stock stock);
	
	/**
	 * 删除进货
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * 根据id查进货
	 * @param id
	 * @return
	 */
	public abstract Stock getByID(long id);
	
	/**
	 *查询所有进货
	 * @return
	 */
	public abstract List<Stock> getAll();

}

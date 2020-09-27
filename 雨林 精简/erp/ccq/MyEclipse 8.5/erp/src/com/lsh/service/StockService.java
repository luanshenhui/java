package com.lsh.service;

import java.util.List;

import com.lsh.domain.Stock;

public interface StockService {
	/**
	 * 增加一个
	 * @param stock
	 * @return
	 */
	public abstract boolean add(Stock stock);
	
	/**
	 * 修改一个进货
	 * @param stock
	 * @return
	 */
	public abstract boolean update(Stock stock);
	
	/**
	 * 删除一个进货
	 * @param id
	 * @return
	 */
	public abstract boolean delete(long id);
	
	/**
	 * 查找一个进货
	 * @param id
	 * @return
	 */
	public abstract Stock getByID(long id);
	
	/**
	 * 查找所有进货
	 * @return
	 */
	public abstract List<Stock> getAll();

}

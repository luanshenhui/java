package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Stock;

/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午05:04:14
 * 
 * 进货表的数据访问标准
 */

public interface StockDAO {
	/**
	 * 
	 * @param stock
	 * 增
	 */
	public abstract void add(Stock stock);
	

	
	/**
	 * 
	 * @return
	 * 查所有
	 */
	public abstract List<Stock> getAll();
	
}

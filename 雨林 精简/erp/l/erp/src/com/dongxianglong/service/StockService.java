/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Stock;

/**
 * @author 董祥龙
 *
 * 2015-2-5下午03:19:18
 */
public interface StockService {

	/**
	 * 增加进货
	 * @param stock
	 * @return
	 */
	public abstract boolean add(Stock stock);
	
	/**
	 * 
	 * 查看所有
	 * @return
	 */
	public abstract List<Stock> getAll();
	
	
}

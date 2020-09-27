/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Sell;

/**
 * @author 董祥龙
 *
 * 2015-2-5下午03:23:32
 */
public interface SellService {

	/**
	 * 增添
	 * @param sell
	 * @return
	 */
	public abstract boolean add(Sell sell);
	/**
	 * 查看所有
	 * @return
	 */
	public abstract List<Sell> getAll();
	
	
	
}

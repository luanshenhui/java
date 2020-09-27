package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Sell;


/**
 * 
 * @author 董祥龙
 *
 * 2015-2-2下午05:09:58
 * 
 * 销售的数据访问标准
 */
public interface SellDAO {
	
	/**
	 * 
	 * @param sell
	 * 增
	 */
	public abstract void add(Sell sell);
	
	
	/**
	 * 
	 * @return
	 * 查所有
	 */
	public abstract List<Sell> getAll();
	

}

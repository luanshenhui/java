/**
 * 
 */
package com.dongxianglong.service;

import java.util.List;

import com.dongxianglong.domain.Stock;

/**
 * @author ������
 *
 * 2015-2-5����03:19:18
 */
public interface StockService {

	/**
	 * ���ӽ���
	 * @param stock
	 * @return
	 */
	public abstract boolean add(Stock stock);
	
	/**
	 * 
	 * �鿴����
	 * @return
	 */
	public abstract List<Stock> getAll();
	
	
}

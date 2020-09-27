package com.dongxianglong.dao;

import java.util.List;

import com.dongxianglong.domain.Stock;

/**
 * 
 * @author ������
 *
 * 2015-2-2����05:04:14
 * 
 * ����������ݷ��ʱ�׼
 */

public interface StockDAO {
	/**
	 * 
	 * @param stock
	 * ��
	 */
	public abstract void add(Stock stock);
	

	
	/**
	 * 
	 * @return
	 * ������
	 */
	public abstract List<Stock> getAll();
	
}

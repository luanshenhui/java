package com.lsh.dao;

import java.util.List;


import com.lsh.domain.Stock;

public interface StockDAO {
	
	/**
	 * ���ӽ���
	 * @param product
	 */
	public abstract void add(Stock stock);
	/**
	 * �޸Ľ���
	 * @param product
	 */
	public abstract void update(Stock stock);
	
	/**
	 * ɾ������
	 * @param product
	 */
	public abstract void delete(long id);
	
	/**
	 * ����id�����
	 * @param id
	 * @return
	 */
	public abstract Stock getByID(long id);
	
	/**
	 *��ѯ���н���
	 * @return
	 */
	public abstract List<Stock> getAll();

}
